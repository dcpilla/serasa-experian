#aws_account_id          = "992382670558"
service_request         = "RITM3348877"
region                  = "us-east-1"
env                     = "dev"
efs_enabled             = "true"
project_name            = "consentment"
eks_cluster_name        = "consent"
eks_cluster_version     = "1.27"
resource_business_unit  = "EITS"
resource_owner          = "nikesre@br.experian.com"
resource_name           = "eks_consent_dev"
resource_app_id         = "17553"
resource_cost_center    = "1800.BR.685.501000"
ad_domain               = "br.experian.local"
#assume_role_arn         = "arn:aws:iam::992382670558:role/BURoleForDevSecOpsCockpitService"
map_server_id           = "d-server-01riktnbfe0092"

vpc_id = "auto"
subnets = "auto"

# Metrics Server
metrics_server_replicas            = 1
metrics_server_hostNetwork_enabled = true
metrics_server_containerPort       = 4443

# Istio
istio_ingress_enabled      = true
istio_ingress_force_update = false
istio_ingress_annotation = {
  "service.beta.kubernetes.io/aws-load-balancer-ssl-cert"               = "arn:aws:acm:us-east-1:992382670558:certificate/54a0eba5-e842-4fc7-a43a-b4c477c10e36"
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
  "consent-dev.us.experian.eeca"
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

eks_ami_id = "latest"
