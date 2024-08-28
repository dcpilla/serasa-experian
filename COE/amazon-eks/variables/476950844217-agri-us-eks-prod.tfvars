#aws_account_id          = "476950844217"
service_request         = "RITM3497052"
region                  = "us-east-1"
env                     = "prod"
efs_enabled             = "true"
project_name            = "agribusiness-us"
eks_cluster_name        = "agri-us-eks"
eks_cluster_version     = "1.27"
resource_business_unit  = "agribusiness"
resource_owner          = "agribusiness.sre@br.experian.com"
resource_name           = "BR-agribusiness-Architecture"
resource_app_id         = "17264"
resource_cost_center    = "1805.BR.659.402058"
ad_domain               = "ena.us.experian.local"
# assume_role_arn         = "arn:aws:iam::476950844217:role/BURoleForDevSecOpsCockpitService"
map_server_id           = "d-server-01riktnbfe0092"

vpc_id = "auto"
subnets = "auto"
eks_ami_id = "latest"
repo_version = "v1.9-11-g6b49dd6"
karpenter = "disabled"
nodegroup_names_prefix = "combined"
use_proxy = "10.28.246.14:9595"
dockerhub_cache_prefix = "off"

# Metrics Server
metrics_server_replicas            = 1
metrics_server_hostNetwork_enabled = true
metrics_server_containerPort       = 4443

# Istio
istio_ingress_enabled      = true
istio_ingress_force_update = false
istio_ingress_annotation = {
  "service.beta.kubernetes.io/aws-load-balancer-ssl-cert"               = "arn:aws:acm:us-east-1:476950844217:certificate/2aeb753f-fedf-459d-a05c-97b6c13a1282"
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
  "agribusiness-brain.us.experian.eeca"
]
external_dns_logLevel = "debug"
external_dns_extra_args = [
  "--aws-zone-type=private",
]

# Nodes Max Size
eks_managed_node_infra_max_size  = "2"
eks_managed_node_small_max_size  = "2"
eks_managed_node_medium_max_size = "2"
eks_managed_node_larger_max_size = "2"
eks_managed_node_spot_max_size   = "2"

eks_managed_node_infra_instance_type  = "c6i.2xlarge"
eks_managed_node_small_instance_type  = "m5.xlarge"
eks_managed_node_medium_instance_type = "m5.2xlarge"
eks_managed_node_large_instance_type  = "m5.4xlarge"
eks_managed_node_spot_instance_type   = "m5.large"