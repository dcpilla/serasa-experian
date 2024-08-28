aws_account_id          = "833564559175"
service_request         = "RITM3226760"
region                  = "sa-east-1"
env                     = "prod"
efs_enabled             = "true"
project_name            = "opf-eks"
eks_cluster_name        = "opf-eks-01"
eks_cluster_version     = "1.27"
resource_business_unit  = "CS"
resource_owner          = "sre.openfinance.brazil@br.experian.com"
resource_name           = "workernodes.br.experian.eeca"
resource_app_id         = "17076"
resource_cost_center    = "1800.BR.600.403129"
#assume_role_arn         = "arn:aws:iam::833564559175:role/BURoleForDevSecOpsCockpitService"
map_server_id           = "d-server-01riktnbfe0092"

# Metrics Server
metrics_server_replicas            = 1
metrics_server_hostNetwork_enabled = true
metrics_server_containerPort       = 4443

# Istio
istio_ingress_enabled      = true
istio_ingress_force_update = false
istio_ingress_annotation = {
  "service.beta.kubernetes.io/aws-load-balancer-ssl-cert"               = "arn:aws:acm:sa-east-1:833564559175:certificate/b006301f-19c0-4afa-a6c9-6be4232915ca"
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
  "openfinance.br.experian.eeca"
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
eks_managed_node_small_instance_type  = "t3.large"
eks_managed_node_medium_instance_type = "t3.xlarge"
eks_managed_node_large_instance_type  = "c5.18xlarge"
eks_managed_node_spot_instance_type   = "c5.9xlarge"

eks_ami_id = "latest"
subnets = "subnet-04a653aee72abfc99,subnet-03afd5a84316d9047,subnet-0c83dbfa176f825ec"