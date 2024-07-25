aws_account_id          = "720643395463"
service_request         = "RITM3215426"
region                  = "sa-east-1"
env                     = "dev"
efs_enabled             = "true"
project_name            = "CorpServicesDEV"
eks_cluster_name        = "cp-eks-01"
eks_cluster_version     = "1.25"
resource_business_unit  = "ES"
resource_owner          = "SharedServicesSolution@br.experian.com"
resource_name           = "eks-corpservices-dev"
resource_app_id         = "11435"
resource_cost_center    = "1800.BR.134.602000"
#assume_role_arn         = "arn:aws:iam::720643395463:role/BURoleForDevSecOpsCockpitService"
map_server_id           = "d-server-01riktnbfe0092"

# Metrics Server
metrics_server_replicas            = 1
metrics_server_hostNetwork_enabled = true
metrics_server_containerPort       = 4443

# Istio
istio_ingress_enabled      = true
istio_ingress_force_update = false
istio_ingress_annotation = {
  "service.beta.kubernetes.io/aws-load-balancer-ssl-cert"               = "arn:aws:acm:sa-east-1:720643395463:certificate/d02e7907-7b1d-41fd-83c7-d0962b83a744"
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
  "corpservices-dev.br.experian.eeca"
]
external_dns_logLevel = "debug"
external_dns_extra_args = [
  "--aws-zone-type=private",
]

# Nodes Max Size
eks_managed_node_infra_max_size  = "3"
eks_managed_node_small_max_size  = "3"
eks_managed_node_medium_max_size = "1"
eks_managed_node_larger_max_size = "1"
eks_managed_node_spot_max_size   = "1"

eks_managed_node_infra_instance_type  = "c5a.xlarge"
eks_managed_node_small_instance_type  = "c5a.xlarge"
eks_managed_node_medium_instance_type = "c5a.large"
eks_managed_node_large_instance_type  = "c5a.large"
eks_managed_node_spot_instance_type   = "c5a.large"

eks_ami_id = "latest"
subnets = "auto"