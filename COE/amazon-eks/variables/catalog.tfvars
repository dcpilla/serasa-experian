#aws_account_id          = "@@AWS_ACCOUNT_ID@@"
service_request         = "@@NUMBER_RITM@@"
region                  = "@@AWS_REGION@@"
env                     = "@@ENV@@"
efs_enabled             = "@@EFS_ENABLED@@"
project_name            = "@@PROJECT_NAME@@"
eks_cluster_name        = "@@EKS_CLUSTER_NAME@@"
eks_cluster_version     = "@@EKS_CLUSTER_VERSION@@"
resource_business_unit  = "@@RESOURCE_BUSINESS_UNIT@@"
resource_owner          = "@@RESOURCE_OWNER@@"
resource_name           = "@@RESOURCE_NAME@@"
resource_app_id         = "@@RESOURCE_APP_ID@@"
resource_cost_center    = "@@RESOURCE_COST_CENTER@@"
ad_domain               = "@@ADDOMAIN@@"
assume_role_arn         = "arn:aws:iam::@@AWS_ACCOUNT_ID@@:role/BURoleForDevSecOpsCockpitService"
map_server_id           = "d-server-01riktnbfe0092"

vpc_id = "@@VPC_ID@@"
subnets = "@@SUBNETS@@"
eks_ami_id = "@@EKS_AMI_ID@@"
repo_version = "__REPO_VERSION__"
karpenter = "@@KARPENTER@@"
nodegroup_names_prefix = "@@NODEGROUP_NAMES_PREFIX@@"
use_proxy = "@@USE_PROXY@@"
dockerhub_cache_prefix = "@@DOCKER_HUB_CACHE_PREFIX@@"

# Metrics Server
metrics_server_replicas            = 1
metrics_server_hostNetwork_enabled = true
metrics_server_containerPort       = 4443

# Istio
istio_ingress_enabled      = true
istio_ingress_force_update = false
istio_ingress_annotation = {
  "service.beta.kubernetes.io/aws-load-balancer-ssl-cert"               = "@@ACM@@"
  "service.beta.kubernetes.io/aws-load-balancer-backend-protocol"       = "http"
  "service.beta.kubernetes.io/aws-load-balancer-type"                   = "nlb"
  "service.beta.kubernetes.io/aws-load-balancer-ssl-ports"              = "443"
  "service.beta.kubernetes.io/aws-load-balancer-internal"               = true
  "service.beta.kubernetes.io/aws-load-balancer-ssl-negotiation-policy" = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  "service.beta.kubernetes.io/aws-load-balancer-proxy-protocol"         = "*"
  "service.beta.kubernetes.io/aws-load-balancer-access-log-enabled"     = true
  "service.beta.kubernetes.io/aws-load-balancer-access-log-s3-bucket-prefix"        = "logs-istio-nlb"
  "service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled"  = true
  "service.beta.kubernetes.io/aws-load-balancer-subnets"                            = "auto_private"
}

istio_ingress_ports = [
  {
    "name"       = "status-port"
    "port"       = "15021"
    "protocol"   = "TCP"
    "targetPort" = "15021"
  },
  {
    "name"       = "http2"
    "port"       = "80"
    "protocol"   = "TCP"
    "targetPort" = "80"
  },
  {
    "name"       = "https"
    "port"       = "443"
    "protocol"   = "TCP"
    "targetPort" = "8080"
  }
]
istio_ingress_loadBalancerSourceRanges = [
  "10.0.0.0/8"
]

# External DNS
external_dns_provider = "aws"
external_dns_source = [
  "ingress",
  "istio-gateway",
  "istio-virtualservice",
]
external_dns_domain_filters = [
  "@@DOMAIN_NAME@@"
]
external_dns_logLevel = "debug"
external_dns_extra_args = [
  "--aws-zone-type=private",
]

# Nodes Max Size
eks_managed_node_infra_max_size  = "@@NODE_INFRA_MAX_SIZE@@"
eks_managed_node_small_max_size  = "@@NODE_SMALL_MAX_SIZE@@"
eks_managed_node_medium_max_size = "@@NODE_MEDIUM_MAX_SIZE@@"
eks_managed_node_larger_max_size = "@@NODE_LARGER_MAX_SIZE@@"
eks_managed_node_spot_max_size   = "@@NODE_SPOT_MAX_SIZE@@"

eks_managed_node_infra_instance_type  = "@@NODE_INFRA_INSTANCE_TYPE@@"
eks_managed_node_small_instance_type  = "@@NODE_SMALL_INSTANCE_TYPE@@"
eks_managed_node_medium_instance_type = "@@NODE_MEDIUM_INSTANCE_TYPE@@"
eks_managed_node_large_instance_type  = "@@NODE_LARGER_INSTANCE_TYPE@@"
eks_managed_node_spot_instance_type   = "@@NODE_SPOT_INSTANCE_TYPE@@"
