#aws_account_id          = "575206002933"
service_request         = "RITM2780946"
region                  = "sa-east-1"
env                     = "dev"
efs_enabled             = "true"
project_name            = "eksascenddev"
eks_cluster_name        = "ascend-eks-01"
eks_cluster_version     = "1.25"
resource_business_unit  = "CS"
resource_owner          = "sre.ascend.brazil@br.experian.com"
resource_name           = "workernodes.br.experian.eeca"
resource_app_id         = "10348"
resource_cost_center    = "1800.BR.600.406006"
ad_domain               = "br.experian.local"
# assume_role_arn         = "arn:aws:iam::833564559175:role/BURoleForDevSecOpsCockpitService"
map_server_id           = "d-server-01riktnbfe0092"

vpc_id = "auto"
subnets = "subnet-08f547ce38123439d,subnet-00457d25f48219544,subnet-0bf0e29cc5a705ea0"
# private_subnets = ["subnet-0027a074ce4d60d5d", "subnet-00e2afa58b9010db7", "subnet-0e22aa20e3425cae0"]

# Metrics Server
metrics_server_replicas            = 1
metrics_server_hostNetwork_enabled = true
metrics_server_containerPort       = 4443

# Istio
istio_ingress_enabled      = true
istio_ingress_force_update = false
istio_ingress_annotation = {
  "service.beta.kubernetes.io/aws-load-balancer-ssl-cert"               = "arn:aws:acm:sa-east-1:114282575302:certificate/4d3592be-9a2a-4d36-bda3-64b0fd4a0e6f"
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
  "dev.ascend.br.experian.eeca"
]
external_dns_logLevel = "debug"
external_dns_extra_args = [
  "--aws-zone-type=private",
]

# Nodes Max Size
eks_managed_node_infra_max_size  = "4"
eks_managed_node_small_max_size  = "4"
eks_managed_node_medium_max_size = "4"
eks_managed_node_larger_max_size = "4"
eks_managed_node_spot_max_size   = "4"

eks_managed_node_infra_instance_type  = "c6i.xlarge"
eks_managed_node_small_instance_type  = "m5.xlarge"
eks_managed_node_medium_instance_type = "m5.2xlarge"
eks_managed_node_large_instance_type  = "m5.4xlarge"
eks_managed_node_spot_instance_type   = "m5.xlarge"

# edgecli = "id=a user=a password="
# apigeecli = "id=a user=a password="

#eks_ami_id = "ami-0137a6748cf505fba"
eks_ami_id = "latest"
