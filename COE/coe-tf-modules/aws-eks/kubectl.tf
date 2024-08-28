provider "kubectl" {
  apply_retry_count      = 5
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  load_config_file       = false

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

################################################################################
# VPC-CNI Custom Networking ENIConfig
################################################################################

resource "kubectl_manifest" "eni_config" {
  for_each = local.availability_zone_subnets

  yaml_body = yamlencode({
    apiVersion = "crd.k8s.amazonaws.com/v1alpha1"
    kind       = "ENIConfig"
    metadata = {
      name = each.key
    }
    spec = {
      securityGroups = [
        aws_security_group.eks_managed_node_group_secondary_additional.id,
        module.eks.node_security_group_id,
      ]
      subnet = each.value
    }
  })

}

################################################################################
# AWS-AUTH Create Group to ReadOnlyAccess
################################################################################

resource "kubectl_manifest" "cluster_role_readonly" {
  yaml_body = <<YAML
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: readonly
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
- apiGroups: [""]
  resources: ["pods/log"]
  verbs: ["get", "watch", "list"]
  YAML
}

resource "kubectl_manifest" "cluster_role_binding_readonly" {
  yaml_body = <<YAML
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: readonly
subjects:
- kind: Group
  name: "readonly"
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: readonly
  apiGroup: rbac.authorization.k8s.io
YAML
}

################################################################################
# Istio enable communication using PROXY protocol
# The usage of EnvoyFilter to enable PROXY protocol on the ingress gateways has 
#  been replaced by the gatewayTopology field in ProxyConfig. 
# This block will be removed in future version
################################################################################
resource "kubectl_manifest" "istio_envoy_filter" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: EnvoyFilter
metadata:
  name: proxy-protocol
  namespace: istio-system
spec:
  workloadSelector:
    labels:
      istio: ingress
      istio-version: "1.18"
  configPatches:
    - applyTo: LISTENER
      patch:
        operation: MERGE
        value:
          listener_filters:
            - name: envoy.listener.proxy_protocol
            - name: envoy.listener.tls_inspector
YAML
  count     = var.istio_ingress_nlb_proxy_enabled ? 1 : 0
}
