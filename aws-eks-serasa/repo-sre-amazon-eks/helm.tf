provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = var.assume_role_arn != "" ? local.args_helm_assume_role : local.args_helm
    }
  }
}

locals {
  # Helm provider
  args_helm_assume_role = ["eks", "get-token", "--cluster-name", "${local.cluster_name_env}", "--role-arn", "${var.assume_role_arn}"]
  args_helm = ["eks", "get-token", "--cluster-name", "${local.cluster_name_env}"]

  dynamic_variables = {
    "auto_private" = "${join("\\,", local.subnets)}",
    "auto_pod"     = "${join("\\,", data.aws_subnets.pods.ids)}"
  }

  dockerhub_ecr_cache_prefix = lookup({
    "off" = "docker.io"
    "own" = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/docker-hub"
  }, var.dockerhub_cache_prefix, var.dockerhub_cache_prefix)
  
  istio_annotation_dynamic = [
    for k, v in var.istio_ingress_annotation : {
      name  = format("%s.%s", "service.annotations", replace(k, ".", "\\."))
      value = trimspace(v)
    }
  ]

  istio_ports = flatten([
    for item in var.istio_ingress_ports : [
      for k, v in item : {
        name  = format("service.ports[%s].%s", index(var.istio_ingress_ports, item), k)
        value = v
      }
    ]
  ])

  values_kube_prometheus = <<EOF
alertmanager:
  alertmanagerSpec:
    resources:
      requests:
        cpu: 100m
        memory: 256Mi
    nodeSelector:
      Worker: infra
    tolerations:
      - key: dedicated
        operator: Equal
        value: infra
        effect: NoSchedule
grafana:
  image:
    registry: ${local.dockerhub_ecr_cache_prefix}
  adminPassword: "${random_password.password.result}"
  initChownData:
    enabled: false
  persistence:
    enabled: true
    storageClassName: ${var.efs_enabled ? "efs" : "gp2"}
  additionalDataSources:
    - name: Loki
      type: loki
      url: http://loki-stack:3100/
  nodeSelector:
    Worker: infra
  tolerations:
    - key: dedicated
      operator: Equal
      value: infra
      effect: NoSchedule
prometheusOperator:
  resources:
    requests:
      cpu: 100m
      memory: 256Mi
  admissionWebhooks:
    patch:
      nodeSelector:
        Worker: infra
      tolerations:
        - key: dedicated
          operator: Equal
          value: infra
          effect: NoSchedule
  nodeSelector:
    Worker: infra
  tolerations:
    - key: dedicated
      operator: Equal
      value: infra
      effect: NoSchedule
prometheus:
  prometheusSpec:
    scrapeInterval: 30s
    evaluationInterval: 30s
    query:
      maxConcurrency: 10
      maxSamples: 150000
      timeout: 5m
    resources:
      requests:
        memory: 5Gi
    storageSpec:
      volumeClaimTemplate:
        spec:
          storageClassName: ${var.efs_enabled ? "efs" : "gp2"}
          accessModes:
            - ReadWriteOnce
          resources:
            requests:
              storage: 128Gi
    nodeSelector:
      Worker: infra
    tolerations:
      - key: dedicated
        operator: Equal
        value: infra
        effect: NoSchedule
  additionalPodMonitors:
    - name: kube-prometheus-stack-istio-sidecars
      podMetricsEndpoints:
        - path: /stats/prometheus
          port: http-envoy-prom
          interval: 15s
          honorLabels: true
      namespaceSelector:
        any: true
      selector:
        matchLabels:
          security.istio.io/tlsMode: istio
    - name: kube-prometheus-stack-flagger
      podMetricsEndpoints:
        - port: http
          interval: 15s
          honorLabels: true
      namespaceSelector:
        matchNames:
          - istio-system
      selector:
        matchLabels:
          app.kubernetes.io/name: flagger
kube-state-metrics:
  nodeSelector:
    Worker: infra
  tolerations:
    - key: dedicated
      operator: Equal
      value: infra
      effect: NoSchedule
EOF

  values_loki_stack = <<EOF
promtail:
  image:
    registry: ${local.dockerhub_ecr_cache_prefix}
  tolerations:
    - operator: Exists
grafana:
  sidecar:
    datasources:
      enabled: false
loki:
  image:
    repository: ${local.dockerhub_ecr_cache_prefix}/grafana/loki
  resources:
    requests:
      cpu: 200m
      memory: 512Mi
    limits:
      cpu: 2000m
      memory: 4Gi
  nodeSelector:
    Worker: infra
  tolerations:
    - key: dedicated
      operator: Equal
      value: infra
      effect: NoSchedule
  config:
    schema_config:
      configs:
        - from: 2022-04-03
          store: boltdb-shipper
          object_store: s3
          schema: v11
          index:
            prefix: index_
            period: 24h
    storage_config:
      boltdb_shipper:
        active_index_directory: /data/loki/index
        cache_location: /data/loki/index_cache
        shared_store: s3
      aws:
        s3: ${aws_s3_bucket.eks_log_bucket.id}
        s3forcepathstyle: true
        region: ${data.aws_region.current.name}
        endpoint: s3.${data.aws_region.current.name}.amazonaws.com
    compactor:
      working_directory: /data/compactor
      compaction_interval: 5m
      shared_store: s3
EOF
}

resource "helm_release" "setup-rbac" {
  depends_on = [
    module.eks.aws_eks_cluster
  ]
  name       = "setup-rbac"
  namespace  = "kube-system"
  chart      = "./helm-charts/setup-rbac-1.0.0"
  
  values = [yamlencode({
    accountid = data.aws_caller_identity.current.account_id
    roles = join(" ", var.karpenter != "disabled" ? concat(var.roles, aws_iam_role.karpenter_node.*.name) : var.roles)
    users = join(" ", var.users)
    nodeSelector = {
      Worker = "infra"
    }
    tolerations = [{
      key = "dedicated"
      operator = "Equal"
      value = "infra"
      effect = "NoSchedule"
    }]    
  })]
}

resource "helm_release" "metrics-server" {
  depends_on = [
    # module.eks.aws_eks_cluster
    # helm_release.aws-vpc-cni-patch
    # module.eks.cluster_addons
    null_resource.wait_custom_networking
  ]
  name            = "metrics-server"
  namespace       = "kube-system"
  repository      = "https://kubernetes-sigs.github.io/metrics-server/"
  chart           = "metrics-server"
  version         = var.eks_charts_version[var.eks_cluster_version].metrics_server
  wait            = true
  timeout         = 600
  cleanup_on_fail = true

  values = [yamlencode({
    replicas = var.metrics_server_replicas
    hostNetwork = {
      enabled = var.metrics_server_hostNetwork_enabled
    }
    containerPort = var.metrics_server_containerPort
    resources = {
      requests = {
        cpu = "50m"
        memory = "64Mi"
      }
      limits = {
        cpu = "500m"
        memory = "512Mi"
      }
    }
    nodeSelector = {
      Worker = "infra"
    }
    tolerations = [{
      key = "dedicated"
      operator = "Equal"
      value = "infra"
      effect = "NoSchedule"
    }]
  })]
}

resource "helm_release" "cluster-autoscaler" {
  depends_on = [
    helm_release.metrics-server
  ]
  name             = "cluster-autoscaler"
  namespace        = "kube-system"
  repository       = "https://kubernetes.github.io/autoscaler"
  chart            = "cluster-autoscaler"
  version          = var.eks_charts_version[var.eks_cluster_version].cluster_autoscaler
  wait             = true
  timeout          = 300

  values = [yamlencode({
    extraEnv = {for item in local.proxy_env_vars: item.name => item.value}
    autoDiscovery = {
      clusterName = "${local.cluster_name_env}"
    }
    awsRegion = "${var.region}"
    resources = {
      requests = {
        cpu = "50m"
        memory = "128Mi"
      }
      limits = {
        cpu = "200m"
        memory = "256Mi"
      }
    }
    nodeSelector = {
      Worker = "infra"
    }
    tolerations = [{
      key = "dedicated"
      operator = "Equal"
      value = "infra"
      effect = "NoSchedule"
    }]
  })]
}

resource "helm_release" "karpenter" {
  count = var.karpenter != "disabled" ? 1 : 0
  depends_on = [
    helm_release.metrics-server
  ]
  name             = "karpenter"
  namespace        = "kube-system"
  repository       = "oci://public.ecr.aws/karpenter"
  chart            = "karpenter"
  version          = "0.35.5"
  force_update     = true
  wait             = true
  timeout          = 300

  values = [yamlencode({
    settings = {
      clusterName = local.cluster_name_env
    }
    serviceAccount = {
      annotations = {
        "eks.amazonaws.com/role-arn" = var.karpenter != "disabled" ? aws_iam_role.karpenter_controller.0.arn : ""
      }
    }
    controller = {
      env = [for k,v in local.proxy_env_vars: v]
      resources = {
        requests = {
          cpu = "50m"
          memory = "128Mi"
        }
        limits = {
          cpu = "500m"
          memory = "512Mi"
        }
      }
    }
    affinity = {
      nodeAffinity = { 
        requiredDuringSchedulingIgnoredDuringExecution = {
          nodeSelectorTerms = [{
            matchExpressions = [{
              key = "karpenter.sh/nodepool"
              operator = "DoesNotExist"
            }]
          },{
            matchExpressions = [{
              key = "eks.amazonaws.com/nodegroup"
              operator = "In"
              values = [local.eks_nodegroup_infra_name]
            }]
          }]
        }
      }
      podAntiAffinity = {}
    }
    nodeSelector = {
      "kubernetes.io/os" = "linux"
      Worker = "infra"
    }
    tolerations = [{
      key = "CriticalAddonsOnly"
      operator = "Exists"
    },{
      key = "dedicated"
      operator = "Equal"
      value = "infra"
      effect = "NoSchedule"
    }]
  })]
}

resource "helm_release" "aws-efs-csi-driver" {
  depends_on = [
    resource.aws_efs_mount_target.eks_file_system,
    helm_release.metrics-server
  ]
  name            = "aws-efs-csi-driver"
  namespace       = "kube-system"
  repository      = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
  chart           = "aws-efs-csi-driver"
  wait            = true
  timeout         = 300
  force_update    = true
  cleanup_on_fail = true

  values = [yamlencode({
    useFips = true
    hostNetwork = true
    image = {
      repository = "602401143452.dkr.ecr.sa-east-1.amazonaws.com/eks/aws-efs-csi-driver"
    }
    sidecars = {
      livenessProbe = {
        repository = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/aws-public/eks-distro/kubernetes-csi/livenessprobe"
      }
      csiProvisioner = {
        repository = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/aws-public/eks-distro/kubernetes-csi/external-provisioner"
      }
      nodeDriverRegistrar = {
        repository = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/aws-public/eks-distro/kubernetes-csi/node-driver-registrar"
      }
    }
    controller = {
      nodeSelector = {
        Worker = "infra"
      }
      tolerations = [{
        key = "dedicated"
        operator = "Equal"
        value = "infra"
        effect = "NoSchedule"
      }]
    }
    storageClasses = [
      {
        name = "efs"
        parameters = {
          provisioningMode = "efs-ap"
          fileSystemId = resource.aws_efs_file_system.eks_file_system[count.index].id
          directoryPerms = "700"
          gidRangeStart = "1000"
          gidRangeEnd = "2000"
          basePath = "/dynamic_provisioning"
        }
        reclaimPolicy = "Delete"
        volumeBindingMode = "Immediate"
      }
    ]
  })]

  count = var.efs_enabled ? 1 : 0
}

resource "null_resource" "efs_proxy_env_vars" {
  depends_on = [
    helm_release.aws-efs-csi-driver
  ]

  count = var.efs_enabled ? 1 : 0

  triggers = {
    manifest_sha1 = sha1("${var.efs_enabled ? helm_release.aws-efs-csi-driver[0].metadata[0].revision : ""}-${local.kubectl_proxy_cmds["aws-efs-csi-driver"]}")
  }
  
  provisioner "local-exec" {
    command = format("kubectl %s", local.kubectl_proxy_cmds["aws-efs-csi-driver"])
    environment = {
      KUBECONFIG = local_file.kubeconfig.filename
    }
  }
}

resource "helm_release" "istio-base" {
  depends_on = [
    helm_release.metrics-server
  ]
  name             = "istio-base"
  namespace        = "istio-system"
  create_namespace = true
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  force_update     = var.istio_ingress_force_update
  version          = var.eks_charts_version[var.eks_cluster_version].istio
  wait             = true
  timeout          = 60

  count = var.istio_ingress_enabled ? 1 : 0
}

resource "helm_release" "istio-discovery" {
  depends_on = [
    helm_release.metrics-server,
    helm_release.istio-base
  ]
  name         = "istiod"
  namespace    = "istio-system"
  repository   = "https://istio-release.storage.googleapis.com/charts"
  chart        = "istiod"
  force_update = var.istio_ingress_force_update
  version      = var.eks_charts_version[var.eks_cluster_version].istio
  wait         = true
  timeout      = 300

  values = [yamlencode({
    global = {
      hub = "${local.dockerhub_ecr_cache_prefix}/istio"
      tracer = {
        zipkin = {
          address = "jaeger-collector.istio-system:9411"
        }
      }
    }
    pilot = {
      resources = {
        requests = {
          cpu = "500m"
          memory = "512Mi"
        }
        limits = {
          cpu = "1000m"
          memory = "1Gi"
        }
      }
      nodeSelector = {
        Worker = "infra"
      }
      tolerations = [{
        key = "dedicated"
        operator = "Equal"
        value = "infra"
        effect = "NoSchedule"
      }]
    }
    proxy = {
      resources = {
        requests = {
          cpu = "50m"
          memory = "128Mi"
        }
        limits = {
          cpu = "1000m"
          memory = "512Mi"
        }
      }
    }
  })]

  count = var.istio_ingress_enabled ? 1 : 0
}

resource "helm_release" "istio-gateway" {
  depends_on = [
    helm_release.istio-discovery
  ]
  name         = "istio-ingress"
  namespace    = "istio-system"
  repository   = "https://istio-release.storage.googleapis.com/charts"
  chart        = "gateway"
  force_update = var.istio_ingress_force_update
  version      = var.eks_charts_version[var.eks_cluster_version].istio
  wait         = true
  timeout      = 300

  dynamic "set" {
    for_each = local.istio_annotation_dynamic
    content {
      name  = set.value.name
      value = lookup(local.dynamic_variables, set.value.value, null) == null ? set.value.value : local.dynamic_variables[set.value.value]
      type  = "string"
    }
  }

  dynamic "set" {
    for_each = local.istio_ports
    content {
      name  = set.value.name
      value = set.value.value
    }
  }

  values = [yamlencode({
    resources = {
      requests = {
        cpu = "100m"
        memory = "256Mi"
      }
      limits = {
        cpu = "1000m"
        memory = "512Mi"
      }
    }
    autoscaling = {
      minReplicas = 2
      targetCPUUtilizationPercentage = 100
    }
    service = {
      loadBalancerSourceRanges = var.istio_ingress_loadBalancerSourceRanges
      #loadBalancerSourceRanges = [${join(",", var.istio_ingress_loadBalancerSourceRanges)}]
      annotations = {
        "service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags" = "map-migrated=${var.map_server_id}"
        "service.beta.kubernetes.io/aws-load-balancer-access-log-s3-bucket-name" = aws_s3_bucket.eks_accesslog_bucket.id
      }
    }
    nodeSelector = {
      Worker = "infra"
    }
    tolerations = [{
      key = "dedicated"
      operator = "Equal"
      value = "infra"
      effect = "NoSchedule"
    }]
  })]

  count = var.istio_ingress_enabled ? 1 : 0
}

resource "helm_release" "external-dns" {
  depends_on = [
    helm_release.istio-base
  ]
  name       = "external-dns"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/external-dns"
  chart      = "external-dns"
  version    = var.eks_charts_version[var.eks_cluster_version].external_dns
  wait       = true
  timeout    = 300

  values = [yamlencode({
    env = [ for item in local.proxy_env_vars: { "name" = item.name, "value" = item.value } ]
    sources = var.external_dns_source
    logLevel = var.external_dns_logLevel
    provider = var.external_dns_provider
    domainFilters = var.external_dns_domain_filters
    extraArgs = var.external_dns_extra_args
    txtOwnerId = local.cluster_name_env
    resources = {
      requests = {
        cpu = "100m"
        memory = "256Mi"
      }
      limits = {
        cpu = "200m"
        memory = "512Mi"
      }
    }
    nodeSelector = {
      Worker = "infra"
    }
    tolerations = [{
      key = "dedicated"
      operator = "Equal"
      value = "infra"
      effect = "NoSchedule"
    }]
  })]
}

resource "helm_release" "velero" {
  depends_on = [
    helm_release.metrics-server
  ]
  name             = "velero"
  namespace        = "velero"
  repository       = "https://vmware-tanzu.github.io/helm-charts"
  chart            = "velero"
  version          = "6.7.0"
  create_namespace = true
  wait             = true
  timeout          = 300

  values = [yamlencode({
    kubectl = {
      image = {
        repository = "${local.dockerhub_ecr_cache_prefix}/bitnami/kubectl"
        tag = "latest"
      }
    }
    image = {
      repository = "${local.dockerhub_ecr_cache_prefix}/velero/velero"
    }
    credentials = {
      useSecret = false
    }
    configuration = {
      defaultBackupStorageLocation = local.cluster_name_env
      backupStorageLocation = [{
        name = local.cluster_name_env
        provider = "aws"
        bucket = aws_s3_bucket.eks_backup_bucket.id
        config = {
          region = data.aws_region.current.name
          s3ForcePathStyle = true
        }
      }]
      volumeSnapshotLocation = [{
        provider = "aws"
        config = {
          region = data.aws_region.current.name
        }
      }]
    }
    initContainers = [{
      name = "velero-plugin-for-aws" 
      image = "${local.dockerhub_ecr_cache_prefix}/velero/velero-plugin-for-aws:v1.6.1"
      imagePullPolicy = "IfNotPresent"
      volumeMounts = [{
        name = "plugins"
        mountPath = "/target"
      }]
    }]
    schedules = {
      "${local.cluster_name_env}" = {
        schedule = "0 3 * * *"
        useOwnerReferencesInBackup = false
        template = {
          ttl = "360h"
          csiSnapshotTimeout = "15m"
          includedNamespaces = ["*"]
          excludedNamespaces = ["kube-system"]
        }        
      }
    }
    resources = {
      requests = {
        cpu = "10m"
        memory = "128Mi"
      }
      limits = {
        cpu = "1000m"
        memory = "256Mi"
      }
    }
    nodeSelector = {
      Worker = "infra"
    }
    tolerations = [{
      key = "dedicated"
      operator = "Equal"
      value = "infra"
      effect = "NoSchedule"
    }]
  })]
}

resource "helm_release" "vpa" {
  depends_on = [
    helm_release.metrics-server
  ]
  name             = "vpa"
  namespace        = "kube-system"
  repository       = "https://cowboysysop.github.io/charts/"
  chart            = "vertical-pod-autoscaler"
  force_update     = true
  wait             = true
  timeout          = 300

  values = [yamlencode({
    updater = {
      enabled = false
    }
    admissionController = {
      enabled = false
    }
    crds = {
      nodeSelector = {
        Worker = "infra"
      }
      tolerations = [{
        key = "dedicated"
        operator = "Equal"
        value = "infra"
        effect = "NoSchedule"
      }]
    }
    recommender = {
      replicaCount = 1
      extraArgs = {
        pod-recommendation-min-cpu-millicores = 32
        pod-recommendation-min-memory-mb = 128
      }
      resources = {
        limits = {
          cpu = "256m"
          memory = "1Gi"
        }
        requests = {
          cpu = "128m"
          memory = "500Mi"
        }
      }
      nodeSelector = {
        Worker = "infra"
      }
      tolerations = [{
        key = "dedicated"
        operator = "Equal"
        value = "infra"
        effect = "NoSchedule"
      }]
    }
  })]
}

resource "helm_release" "kube-prometheus" {
  depends_on = [
    helm_release.metrics-server,
    helm_release.aws-efs-csi-driver
  ]
  name             = "kube-prometheus-stack"
  namespace        = "monitoring-system"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "60.4.0"
  force_update     = false
  create_namespace = true
  wait             = true
  timeout          = 1200

  values = [local.values_kube_prometheus, yamlencode({
    kube-state-metrics = {
      collectors = [
        "certificatesigningrequests",
        "configmaps",
        "cronjobs",
        "daemonsets",
        "deployments",
        "endpoints",
        "horizontalpodautoscalers",
        "ingresses",
        "jobs",
        "leases",
        "limitranges",
        "mutatingwebhookconfigurations",
        "namespaces",
        "networkpolicies",
        "nodes",
        "persistentvolumeclaims",
        "persistentvolumes",
        "poddisruptionbudgets",
        "pods",
        "replicasets",
        "replicationcontrollers",
        "resourcequotas",
        "secrets",
        "services",
        "statefulsets",
        "storageclasses",
        "validatingwebhookconfigurations",
        "volumeattachments"
      ]
    }
  })]
}

resource "helm_release" "prometheus-ingress" {
  depends_on = [
    helm_release.istio-base
  ]
  name             = "prometheus-ingress"
  namespace        = "monitoring-system"
  chart            = "./helm-charts/istio-integration-1.0.0"
  create_namespace = true

  values = [yamlencode({
    nameOverride = "prometheus"
    fullnameOverride = "prometheus"
    istio = {
      domain = join(",", var.external_dns_domain_filters)
    }
    service = {
      name = "kube-prometheus-stack-prometheus"
      port = "9090"
    }
  })]
}

resource "helm_release" "grafana-ingress" {
  depends_on = [
    helm_release.istio-base
  ]
  name             = "grafana-ingress"
  namespace        = "monitoring-system"
  chart            = "./helm-charts/istio-integration-1.0.0"
  create_namespace = true

  values = [yamlencode({
    nameOverride = "grafana"
    fullnameOverride = "grafana"
    istio = {
      domain = join(",", var.external_dns_domain_filters)
    }
    service = {
      name = "kube-prometheus-stack-grafana"
      port = "80"
    }
  })]
}

resource "helm_release" "envoy-monitoring" {
  depends_on = [
    helm_release.kube-prometheus
  ]
  name       = "envoy-monitoring"
  namespace  = "istio-system"
  chart      = "./helm-charts/prometheus-monitoring-1.0.0"

  values = [yamlencode({
    fullnameOverride = "envoy-stats-monitor"
    monitoring = {
      kind = "PodMonitor"
      spec = {
        jobLabel = "envoy-stats"
        selector = {
          matchExpressions = [{ key = "istio-prometheus-ignore", operator = "DoesNotExist" }]
        }
        namespaceSelector = {
          any = true
        }
        podMetricsEndpoints = [{
          interval = "15s"
          path = "/stats/prometheus"
          relabelings = [
            {
              action = "keep"
              regex = "istio-proxy"
              sourceLabels = [ "__meta_kubernetes_pod_container_name" ]
            },
            {
              action = "keep"
              sourceLabels = [ "__meta_kubernetes_pod_annotationpresent_prometheus_io_scrape" ]
            },
            {
              action = "replace"
              regex = "(\\d+);(([A-Fa-f0-9]{1,4}::?){1,7}[A-Fa-f0-9]{1,4})"
              replacement = "'[$2]:$1'"
              targetLabel = "__address__"
              sourceLabels = [ "__meta_kubernetes_pod_annotation_prometheus_io_port", "__meta_kubernetes_pod_ip" ]
            },
            {
              action = "replace"
              regex = "(\\d+);((([0-9]+?)(\\.|$)){4})"
              replacement = "$2:$1"
              targetLabel = "__address__"
              sourceLabels = [ "__meta_kubernetes_pod_annotation_prometheus_io_port", "__meta_kubernetes_pod_ip" ]
            },
            {
              action = "labeldrop"
              regex = "__meta_kubernetes_pod_label_(.+)"
            },
            {
              action = "replace"
              targetLabel = "namespace"
              sourceLabels = [ "__meta_kubernetes_namespace" ]
            },
            {
              action = "replace"
              targetLabel = "pod_name"
              sourceLabels = [ "__meta_kubernetes_pod_name" ]
            },
          ]
        }]
      }
    }
  })]
}

resource "helm_release" "istio-monitoring" {
  depends_on = [
    helm_release.kube-prometheus
  ]
  name       = "istio-monitoring"
  namespace  = "istio-system"
  chart      = "./helm-charts/prometheus-monitoring-1.0.0"

  values = [yamlencode({
    fullnameOverride = "istio-stats-monitor"
    monitoring = {
      kind = "ServiceMonitor"
      spec = {
        jobLabel = "istio"
        targetLabels = [ "app" ]
        selector = {
          matchExpressions = [{ key = "istio", operator = "In", values = [ "pilot" ] }]
        }
        namespaceSelector = {
          any = true
        }
        endpoints = [{
          interval = "15s"
          port = "http-monitoring"
        }]
      }
    }
  })]
}

resource "helm_release" "prometheus-dashboards" {
  depends_on = [
    helm_release.kube-prometheus
  ]
  name       = "kube-prometheus-dashboards"
  namespace  = "monitoring-system"
  chart      = "./helm-charts/grafana-dashboards-1.0.0"
}

resource "helm_release" "loki-stack" {
  depends_on = [
    helm_release.metrics-server
  ]
  name             = "loki-stack"
  namespace        = "monitoring-system"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "loki-stack"
  create_namespace = true
  force_update     = true
  wait             = true
  timeout          = 600

  values = [local.values_loki_stack]
}

resource "helm_release" "jaeger-istio" {
  depends_on = [
    helm_release.metrics-server,
    helm_release.kube-prometheus
  ]
  name             = "jaeger"
  namespace        = "istio-system"
  repository       = "https://jaegertracing.github.io/helm-charts"
  chart            = "jaeger"
  create_namespace = true
  force_update     = true
  wait             = true
  timeout          = 300

  values = [yamlencode({
    storage = {
      type = "memory"
    }
    provisionDataStore = {
      cassandra     = false
      elasticsearch = false
    }
    allInOne = {
      enabled = false
    }
    agent = {
      enabled = false
      image = {
        registry = local.dockerhub_ecr_cache_prefix
      }
    }
    collector = {
      enabled = true
      image = {
        registry = local.dockerhub_ecr_cache_prefix
      }
      extraEnv = [{
        name  = "COLLECTOR_ZIPKIN_HOST_PORT"
        value = "9411"
      }]
      service = {
        zipkin = {
          port = 9411
        }
      }
      resources = {
        limits = {
          cpu    = "500m"
          memory = "1Gi"
        }
        requests = {
          cpu    = "50m"
          memory = "1Gi"
        }
      }
      nodeSelector = {
        Worker = "infra"
      }
      tolerations = [{
        key      = "dedicated"
        operator = "Equal"
        value    = "infra"
        effect   = "NoSchedule"
      }]
      serviceMonitor = {
        enabled = true
        additionalLabels = {
          release = "kube-prometheus-stack"
        }
      }
    }
    query = {
      enabled = true
      image = {
        registry = local.dockerhub_ecr_cache_prefix
      }
      extraEnv = [{
        name  = "QUERY_BASE_PATH"
        value = "/"
      },{
        name  = "JAEGER_AGENT_PORT"
        value = "6831"
      }]
      resources = {
        limits = {
          cpu    = "500m"
          memory = "1Gi"
        }
        requests = {
          cpu    = "50m"
          memory = "1Gi"
        }
      }
      nodeSelector = {
        Worker = "infra"
      }
      tolerations = [{
        key      = "dedicated"
        operator = "Equal"
        value    = "infra"
        effect   = "NoSchedule"
      }]
      serviceMonitor = {
        enabled = true
        additionalLabels = {
          release = "kube-prometheus-stack"
        }
      }
    }
  })]
}

resource "helm_release" "jaeger-ingress" {
  depends_on = [
    helm_release.istio-base,
    helm_release.jaeger-istio
  ]
  name       = "jaeger-ingress"
  namespace  = "istio-system"
  chart      = "./helm-charts/istio-integration-1.0.0"
  wait       = true
  timeout    = 60

  values = [yamlencode({
    nameOverride = "jaeger"
    fullnameOverride = "jaeger-istio"
    istio = {
      domain = join(",", var.external_dns_domain_filters)
    }
    service = {
      name = "jaeger-query"
      port = "16686"
    }
  })]
}

resource "helm_release" "kiali" {
  depends_on = [
    helm_release.istio-discovery,
    helm_release.kube-prometheus
  ]
  name             = "kiali"
  namespace        = "istio-system"
  repository       = "https://kiali.org/helm-charts"
  chart            = "kiali-server"
  version          = var.eks_charts_version[var.eks_cluster_version].kiali
  wait             = true
  timeout          = 300

  values = [yamlencode({
    auth = {
      strategy = "anonymous"
    }
    external_services = {
      istio = {
        component_status = {
          enabled = false
        }
      }
      grafana = {
        enabled = true
        in_cluster_url = "http://kube-prometheus-stack-grafana.monitoring-system.svc"
        url = "https://grafana.external.address"
        auth = {
          type = "basic"
          username = "admin"
          password = random_password.password.result
        }
        dashboards = [
          {
            name      = "Istio Service Dashboard"
            variables = {
              service = "service"
            }
          },{
            name      = "Istio Workload Dashboard"
            variables = {
              namespace = "namespace"
              workload  = "workload"
            }
          },
          { name = "Istio Mesh Dashboard" },
          { name = "Istio Control Plane Dashboard" },
          { name = "Istio Performance Dashboard" },
          { name = "Istio Wasm Extension Dashboard" }
        ]        
      }
      prometheus = {
        url = "http://kube-prometheus-stack-prometheus.monitoring-system:9090"
      }
      tracing = {
        in_cluster_url          = "http://jaeger-query.istio-system:16685/jaeger"
        url                     = "https://jaeger.external.address"
        use_grpc                = true
        whitelist_istio_system  = ["jaeger-query", "istio-ingress"]
      }
    }
    deployment = {
      node_selector = {
        Worker = "infra"
      }
      tolerations = [{
        key = "dedicated"
        operator = "Equal"
        value = "infra"
        effect = "NoSchedule"
      }]
    }
  })]
}

resource "helm_release" "kiali-ingress" {
  depends_on = [
    helm_release.istio-base
  ]
  name             = "kiali-ingress"
  namespace        = "istio-system"
  chart            = "./helm-charts/istio-integration-1.0.0"
  create_namespace = true

  values = [yamlencode({
    nameOverride = "kiali"
    fullnameOverride = "kiali"
    istio = {
      domain = join(",", var.external_dns_domain_filters)
    }
    service = {
      name = "kiali"
      port = "20001"
    }
  })]
}

resource "helm_release" "flagger" {
  depends_on = [
    helm_release.metrics-server
  ]
  name       = "flagger"
  namespace  = "istio-system"
  repository = "https://flagger.app"
  chart      = "flagger"
  create_namespace = true
  wait       = true
  timeout    = 300

  values = [yamlencode({
    meshProvider = "istio"
    metricsServer = "http://kube-prometheus-stack-prometheus.monitoring-system:9090"

    nodeSelector = {
      Worker = "infra"
    }
    tolerations = [{
      key = "dedicated"
      operator = "Equal"
      value = "infra"
      effect = "NoSchedule"
    }]
  })]
}

resource "helm_release" "flagger-monitoring" {
  depends_on = [
    helm_release.kube-prometheus
  ]
  name       = "flagger-monitoring"
  namespace  = "istio-system"
  chart      = "./helm-charts/prometheus-monitoring-1.0.0"

  values = [yamlencode({
    fullnameOverride = "flagger-stats-monitor"
    monitoring = {
      kind = "PodMonitor"
      spec = {
        selector = {
          matchLabels = { "app.kubernetes.io/name" = "flagger" }
        }
        namespaceSelector = {
          matchNames = [ "istio-system" ]
        }
        podMetricsEndpoints = [{
          honorLabels = true
          interval = "15s"
          port = "http"
        }]
        }
    }
  })]
}

resource "helm_release" "kubecost" {
  depends_on = [
    helm_release.aws-efs-csi-driver
  ]
  name             = "kubecost"
  namespace        = "monitoring-system"
  repository       = "https://kubecost.github.io/cost-analyzer/"
  chart            = "cost-analyzer"
  version          = "2.3.1"
  wait             = true
  timeout          = 600

  values = [yamlencode({
    global = {
      grafana = {
        enabled = false
        proxy = false
      }
      prometheus = {
        enabled = false
        fqdn = "http://kube-prometheus-stack-prometheus.monitoring-system:9090"
      }
    }
    kubecostModel = {
      extraEnv = [{
        name = "AWS_CLUSTER_ID"
        value = local.cluster_name_env
      }]
    }
    persistentVolume = {
      storageClass = var.efs_enabled ? "efs" : "gp2"
    }
    nodeSelector = {
      Worker = "infra"
    }
    tolerations = [{
      key = "dedicated"
      operator = "Equal"
      value = "infra"
      effect = "NoSchedule"
    }]
  })]
}

resource "helm_release" "kubecost-ingress" {
  depends_on = [
    helm_release.istio-base
  ]
  name             = "kubecost-ingress"
  namespace        = "monitoring-system"
  chart            = "./helm-charts/istio-integration-1.0.0"
  create_namespace = true

  values = [yamlencode({
    nameOverride = "kubecost"
    fullnameOverride = "kubecost"
    istio = {
      domain = join(",", var.external_dns_domain_filters)
    }
    service = {
      name = "kubecost-cost-analyzer"
      port = "9090"
    }
  })]
}

resource "helm_release" "kubecost-monitoring" {
  depends_on = [
    helm_release.kube-prometheus
  ]
  name       = "kubecost-monitoring"
  namespace  = "monitoring-system"
  chart      = "./helm-charts/prometheus-monitoring-1.0.0"

  values = [yamlencode({
    fullnameOverride = "kubecost-stats-monitor"
    monitoring = {
      kind = "ServiceMonitor"
      spec = {
        selector = {
          matchLabels = { "app" = "cost-analyzer" }
        }
        namespaceSelector = {
          matchNames = [ "monitoring-system" ]
        }
        endpoints = [{
          honorLabels = true
          interval = "30s"
          port = "tcp-model"
        }]
        }
    }
  })]
}
