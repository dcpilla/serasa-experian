provider "helm" {

  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", "${local.cluster_name_env}"]
      command     = "aws"
    }
  }
}
locals {
  istio_annotation_nlb = var.istio_ingress_nlb_proxy_enabled ? {
  "service.beta.kubernetes.io/aws-load-balancer-proxy-protocol" = "*" } : {}

  lista = flatten([
    for key, value in local.default_tags_eks :
    ["${key}=${value}"]
  ])
  default_tags_istio = join(",", local.lista)
  dynamic_variables = {
    "auto_private"   = "${join("\\,", data.aws_subnets.experian.ids)}",
    "auto_pod"       = "${join("\\,", try(data.aws_subnets.internal_pods.ids, []))}",
    "eks_log_bucket" = aws_s3_bucket.eks_log_bucket.id
  }

  istio_annotation_dynamic = [
    for k, v in merge(var.istio_ingress_annotation, local.istio_annotation_nlb) : {
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

}

# Source: https://github.com/kubernetes-sigs/metrics-server/blob/master/charts/metrics-server/
resource "helm_release" "metrics-server" {
  depends_on = [
    module.eks.cluster_addons
  ]
  name                = "metrics-server"
  namespace           = "kube-system"
  repository          = format("oci://%s.dkr.ecr.sa-east-1.amazonaws.com", var.resources_aws_account)
  chart               = "metrics-server"
  version             = var.metrics_server_version
  repository_username = data.aws_ecr_authorization_token.token.user_name
  repository_password = data.aws_ecr_authorization_token.token.password
  timeout             = 3600
  force_update        = true
  cleanup_on_fail     = true


  set {
    name  = "image.repository"
    value = format("%s.dkr.ecr.sa-east-1.amazonaws.com/metrics-server/metrics-server", var.resources_aws_account)
  }
  set {
    name  = "image.tag"
    value = "v0.7.0"
  }
  set {
    name  = "replicas"
    value = var.metrics_server_replicas
  }
  set {
    name  = "hostNetwork.enabled"
    value = var.metrics_server_hostNetwork_enabled
  }

  set {
    name  = "containerPort"
    value = var.metrics_server_containerPort
  }

  set {
    name  = "nodeSelector.Worker"
    value = "infra"
  }
  set {
    name  = "tolerations[0].key"
    value = "dedicated"
  }
  set {
    name  = "tolerations[0].operator"
    value = "Equal"
  }
  set {
    name  = "tolerations[0].value"
    value = "infra"
  }
  set {
    name  = "tolerations[0].effect"
    value = "NoSchedule"
  }
}

# Source: https://github.com/kubernetes/autoscaler/tree/master/charts/cluster-autoscaler
resource "helm_release" "cluster-autoscaler" {
  depends_on = [
    helm_release.metrics-server
  ]
  name                = "cluster-autoscaler"
  namespace           = "kube-system"
  create_namespace    = "true"
  repository          = format("oci://%s.dkr.ecr.sa-east-1.amazonaws.com", var.resources_aws_account)
  chart               = "cluster-autoscaler"
  timeout             = 3600
  repository_username = data.aws_ecr_authorization_token.token.user_name
  repository_password = data.aws_ecr_authorization_token.token.password
  version             = "9.35.0"

  set {
    name  = "image.repository"
    value = format("%s.dkr.ecr.sa-east-1.amazonaws.com/autoscaling/cluster-autoscaler", var.resources_aws_account)
  }
  set {
    name  = "image.tag"
    value = "v1.29.0"
  }
  set {
    name  = "autoDiscovery.clusterName"
    value = local.cluster_name_env
  }

  set {
    name  = "awsRegion"
    value = var.region
  }

  set {
    name  = "nodeSelector.Worker"
    value = "infra"
  }
  set {
    name  = "tolerations[0].key"
    value = "dedicated"
  }
  set {
    name  = "tolerations[0].operator"
    value = "Equal"
  }
  set {
    name  = "tolerations[0].value"
    value = "infra"
  }
  set {
    name  = "tolerations[0].effect"
    value = "NoSchedule"
  }
}

# Source: https://github.com/kubernetes-sigs/secrets-store-csi-driver/blob/main/charts/secrets-store-csi-driver/values.yaml
resource "helm_release" "secrets-store-csi-driver" {
  name                = "csi-secrets-store"
  repository          = format("oci://%s.dkr.ecr.sa-east-1.amazonaws.com", var.resources_aws_account)
  chart               = "secrets-store-csi-driver"
  version             = "1.4.1"
  namespace           = "kube-system"
  repository_username = data.aws_ecr_authorization_token.token.user_name
  repository_password = data.aws_ecr_authorization_token.token.password
  max_history         = 7
  wait                = false

  set {
    name  = "syncSecret.enabled"
    value = true
  }
  set {
    name  = "linux.image.repository"
    value = format("%s.dkr.ecr.sa-east-1.amazonaws.com/csi-secrets-store/driver", var.resources_aws_account)
  }
  set {
    name  = "linux.image.tag"
    value = "v1.4.1"
  }

  set {
    name  = "linux.crds.image.repository"
    value = format("%s.dkr.ecr.sa-east-1.amazonaws.com/csi-secrets-store/driver-crds", var.resources_aws_account)
  }
  set {
    name  = "linux.crds.image.tag"
    value = "v1.4.1"
  }
  set {
    name  = "linux.registrarImage.repository"
    value = format("%s.dkr.ecr.sa-east-1.amazonaws.com/sig-storage/csi-node-driver-registrar", var.resources_aws_account)
  }
  set {
    name  = "linux.registrarImage.tag"
    value = "v2.8.0"
  }
  set {
    name  = "linux.livenessProbeImage.repository"
    value = format("%s.dkr.ecr.sa-east-1.amazonaws.com/sig-storage/livenessprobe", var.resources_aws_account)
  }
  set {
    name  = "linux.livenessProbeImage.tag"
    value = "v2.10.0"
  }

  set {
    name  = "windows.image.repository"
    value = format("%s.dkr.ecr.sa-east-1.amazonaws.com/csi-secrets-store/driver", var.resources_aws_account)
  }
  set {
    name  = "windows.image.tag"
    value = "v1.4.1"
  }
  set {
    name  = "windows.registrarImage.repository"
    value = format("%s.dkr.ecr.sa-east-1.amazonaws.com/sig-storage/csi-node-driver-registrar", var.resources_aws_account)
  }
  set {
    name  = "windows.registrarImage.tag"
    value = "v2.8.0"
  }
  set {
    name  = "windows.livenessProbeImage.repository"
    value = format("%s.dkr.ecr.sa-east-1.amazonaws.com/sig-storage/livenessprobe", var.resources_aws_account)
  }
  set {
    name  = "windows.livenessProbeImage.tag"
    value = "v2.10.0"
  }

  depends_on = [
    helm_release.metrics-server
  ]
}

#Source: https://github.com/aws/secrets-store-csi-driver-provider-aws/blob/main/charts/secrets-store-csi-driver-provider-aws/values.yaml
resource "helm_release" "secrets-store-csi-driver-provider-aws" {
  name                = "secrets-provider-aws"
  repository          = format("oci://%s.dkr.ecr.sa-east-1.amazonaws.com", var.resources_aws_account)
  chart               = "secrets-store-csi-driver-provider-aws"
  version             = "0.3.5"
  namespace           = "kube-system"
  repository_username = data.aws_ecr_authorization_token.token.user_name
  repository_password = data.aws_ecr_authorization_token.token.password
  force_update        = true
  max_history         = 7
  wait                = false
  set {
    name  = "image.repository"
    value = format("%s.dkr.ecr.sa-east-1.amazonaws.com/aws-secrets-manager/secrets-store-csi-driver-provider-aws", var.resources_aws_account)
  }
  set {
    name  = "image.tag"
    value = "1.0.r2-50-g5b4aca1-2023.06.09.21.19"
  }
  set {
    name  = "tolerations[0].operator"
    value = "Exists"
  }

  depends_on = [
    helm_release.secrets-store-csi-driver
  ]
}

resource "helm_release" "istio-base" {
  name             = "istio-base"
  namespace        = "istio-system"
  create_namespace = "true"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  force_update     = var.istio_ingress_force_update
  version          = var.istio_ingress_version
  timeout          = 3600
  wait             = true

  depends_on = [
    helm_release.metrics-server,
    module.aws-load-balancer-controller
  ]
  count = var.istio_ingress_enabled ? 1 : 0
}

#https://github.com/istio/istio/blob/master/manifests/charts/istio-control/istio-discovery/
resource "helm_release" "istio-discovery" {
  depends_on = [
    helm_release.istio-base
  ]
  name         = "istiod"
  namespace    = "istio-system"
  repository   = "https://istio-release.storage.googleapis.com/charts"
  chart        = "istiod"
  force_update = var.istio_ingress_force_update
  version      = var.istio_ingress_version
  timeout      = 3600

  values = [
    "${file("${path.module}/files/istiod.yaml")}"
  ]

  set {
    name  = "pilot.autoscaleMin"
    value = "2"
  }

  set {
    name  = "pilot.nodeSelector.Worker"
    value = "infra"
  }
  set {
    name  = "pilot.tolerations[0].key"
    value = "dedicated"
  }
  set {
    name  = "pilot.tolerations[0].operator"
    value = "Equal"
  }
  set {
    name  = "pilot.tolerations[0].value"
    value = "infra"
  }
  set {
    name  = "pilot.tolerations[0].effect"
    value = "NoSchedule"
  }

  count = var.istio_ingress_enabled ? 1 : 0
}

# Source: https://github.com/istio/istio/tree/master/manifests/charts/gateway
resource "helm_release" "istio-gateway" {
  name         = "istio-ingress"
  namespace    = "istio-system"
  repository   = "https://istio-release.storage.googleapis.com/charts"
  chart        = "gateway"
  force_update = var.istio_ingress_force_update
  version      = var.istio_ingress_version
  wait         = true
  timeout      = 360

  values = [
    "${templatefile(
      "${path.module}/files/${var.istio_ingress_nlb_proxy_enabled ? "istio-ingress.tftpl" : "istio-ingress-no-proxy.tftpl"}",
      {
        "annotations_tag"                 = "${local.default_tags_istio}"
        "istio_ingress_nlb_proxy_enabled" = "${var.istio_ingress_nlb_proxy_enabled}"
      }
    )}"
  ]

  dynamic "postrender" {
    #https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.4/guide/service/nlb/
    #https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html
    #The AWS LBC provides a mutating webhook for service resources to set the spec.loadBalancerClass 
    # field for service of type LoadBalancer on create. This makes the AWS LBC the default controller for service 
    # of type LoadBalancer.
    for_each = var.istio_ingress_loadbalancerclass != null ? [1] : []
    content {
      binary_path = "${path.module}/post-render/hook.sh"

    }
  }

  set {
    name  = "podDisruptionBudget.minAvailable"
    value = var.istio_ingress_pod_disruption_budget
  }

  set {
    name  = "autoscaling.minReplicas"
    value = var.istio_ingress_replica_count
  }
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

  set {
    name  = "service.loadBalancerSourceRanges"
    value = "{${join(",", var.istio_ingress_loadBalancerSourceRanges)}}"
  }

  set {
    name  = "nodeSelector.Worker"
    value = "infra"
  }
  set {
    name  = "tolerations[0].key"
    value = "dedicated"
  }
  set {
    name  = "tolerations[0].operator"
    value = "Equal"
  }
  set {
    name  = "tolerations[0].value"
    value = "infra"
  }
  set {
    name  = "tolerations[0].effect"
    value = "NoSchedule"
  }


  depends_on = [
    helm_release.istio-discovery,
    module.aws-load-balancer-controller,
    kubectl_manifest.istio_envoy_filter
  ]
  count = var.istio_ingress_enabled ? 1 : 0
}

# Source: https://github.com/kubernetes-sigs/external-dns/tree/master/charts/external-dns
resource "helm_release" "external-dns" {

  name                = "external-dns"
  namespace           = "kube-system"
  repository          = format("oci://%s.dkr.ecr.sa-east-1.amazonaws.com", var.resources_aws_account)
  chart               = "external-dns"
  repository_username = data.aws_ecr_authorization_token.token.user_name
  repository_password = data.aws_ecr_authorization_token.token.password
  version             = var.external_dns_version

  timeout = 3600

  set {
    name  = "image.repository"
    value = format("%s.dkr.ecr.sa-east-1.amazonaws.com/external-dns/external-dns", var.resources_aws_account)
  }
  set {
    name  = "image.tag"
    value = "v0.14.0"
  }
  set {
    name  = "sources"
    value = "{${join(",", var.external_dns_source)}}"
  }

  set {
    name  = "logLevel"
    value = var.external_dns_logLevel
  }

  set {
    name  = "provider"
    value = var.external_dns_provider
  }

  set {
    name  = "domainFilters"
    value = "{${join(",", var.external_dns_domain_filters)}}"
  }

  set {
    name  = "extraArgs"
    value = "{${join(",", var.external_dns_extra_args)}}"
  }

  set {
    name  = "txtOwnerId"
    value = var.eks_cluster_name
  }

  set {
    name  = "nodeSelector.Worker"
    value = "infra"
  }
  set {
    name  = "tolerations[0].key"
    value = "dedicated"
  }
  set {
    name  = "tolerations[0].operator"
    value = "Equal"
  }
  set {
    name  = "tolerations[0].value"
    value = "infra"
  }
  set {
    name  = "tolerations[0].effect"
    value = "NoSchedule"
  }

  depends_on = [
    helm_release.istio-discovery,
    module.aws-load-balancer-controller
  ]

}
