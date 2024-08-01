#aws_account_id          = "@@AWS_ACCOUNT_ID@@"
service_request         = "{{number_ritm}}"
region                  = "{{account_region}}"
env                     = "{{account_environment}}"
efs_enabled             = "{{efs_enabled}}"
project_name            = "{{project_name}}"
eks_cluster_name        = "{{eks_name}}"
eks_cluster_version     = "{{eks_version}}"
resource_business_unit  = "{{account_bu}}"
resource_owner          = "{{resource_owner}}"
resource_name           = "{{resource_anme}}"
resource_app_id         = "{{account_apid}}"
resource_cost_center    = "{{account_ccosting}}"
ad_domain               = "{{addomain}}"
assume_role_arn         = "arn:aws:iam::{{account_id}}:role/BURoleForDevSecOpsCockpitService"
map_server_id           = "d-server-01riktnbfe0092"

vpc_id = "{{vpc_id}}"
subnets = "{{subnets}}"

# Metrics Server
metrics_server_replicas            = 1
metrics_server_hostNetwork_enabled = true
metrics_server_containerPort       = 4443

# Istio
istio_ingress_enabled      = true
istio_ingress_force_update = false
istio_ingress_annotation = {
  "service.beta.kubernetes.io/aws-load-balancer-ssl-cert"               = "{{acm}}"
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
  "{{domain_name}}"
]
external_dns_logLevel = "debug"
external_dns_extra_args = [
  "--aws-zone-type=private",
]

# Nodes Max Size
eks_managed_node_infra_max_size  = "{{node_infra_max_size}}"
eks_managed_node_small_max_size  = "{{node_small_max_size}}"
eks_managed_node_medium_max_size = "{{node_medium_max_size}}"
eks_managed_node_larger_max_size = "{{node_larger_max_size}}"
eks_managed_node_spot_max_size   = "{{node_spot_max_size}}"

eks_managed_node_infra_instance_type  = "{{node_infra_instance_type}}"
eks_managed_node_small_instance_type  = "{{node_small_instance_type}}"
eks_managed_node_medium_instance_type = "{{node_medium_instance_type}}"
eks_managed_node_large_instance_type  = "{{node_larger_instance_type}}"
eks_managed_node_spot_instance_type   = "{{node_spot_instance_type}}"

eks_ami_id = "{{eks_ami_id}}"
