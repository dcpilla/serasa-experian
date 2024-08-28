#aws_account_id          = "353091569218"
service_request         = "RITM3401561"
region                  = "us-east-1"
env                     = "dev"
efs_enabled             = "true"
project_name            = "datahub"
eks_cluster_name        = "datahub"
eks_cluster_version     = "1.28"
resource_business_unit  = "EITS"
resource_owner          = "nikesre@br.experian.com"
resource_name           = "eks_datahub_dev"
resource_app_id         = "16997"
resource_cost_center    = "1800.BR.134.602018"
ad_domain               = "br.experian.local"
# assume_role_arn         = "arn:aws:iam::353091569218:role/BURoleForDevSecOpsCockpitService"
map_server_id           = "d-server-01riktnbfe0092"

vpc_id = "vpc-0e11f34a1ef788727"
subnets = "auto"
eks_ami_id = "latest"
repo_version = "feature/containerd-proxy"
karpenter = "disabled"

# Metrics Server
metrics_server_replicas            = 1
metrics_server_hostNetwork_enabled = true
metrics_server_containerPort       = 4443

# Istio
istio_ingress_enabled      = true
istio_ingress_force_update = false
istio_ingress_annotation = {
  "service.beta.kubernetes.io/aws-load-balancer-ssl-cert"               = "arn:aws:acm:us-east-1:353091569218:certificate/48adce79-9878-4866-bc5d-a90b97e29ec2"
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
  "datahub-dev.us.experian.eeca"
]
external_dns_logLevel = "debug"
external_dns_extra_args = [
  "--aws-zone-type=private",
]

# Nodes Max Size
eks_managed_node_infra_max_size  = "1"
eks_managed_node_small_max_size  = "1"
eks_managed_node_medium_max_size = "1"
eks_managed_node_larger_max_size = "1"
eks_managed_node_spot_max_size   = "1"

eks_managed_node_infra_instance_type  = "t3.large"
eks_managed_node_small_instance_type  = "t3.large"
eks_managed_node_medium_instance_type = "t3.large"
eks_managed_node_large_instance_type  = "t3.large"
eks_managed_node_spot_instance_type   = "t3.large"