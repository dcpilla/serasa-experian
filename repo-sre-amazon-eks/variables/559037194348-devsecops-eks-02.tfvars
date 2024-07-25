#aws_account_id          = "559037194348"
service_request         = "RITM3421702"
region                  = "sa-east-1"
env                     = "sandbox"
efs_enabled             = "true"
project_name            = "catalog"
eks_cluster_name        = "devsecops-eks-02"
eks_cluster_version     = "1.28"
resource_business_unit  = "ES"
resource_owner          = "devsecops-paas-brazil@br.experian.com"
resource_name           = "ekssndinstance02"
resource_app_id         = "18024"
resource_cost_center    = "1800.BR.134.603012"
ad_domain               = "br.experian.local"
# assume_role_arn         = "arn:aws:iam::559037194348:role/BURoleForDevSecOpsCockpitService"
map_server_id           = "d-server-01riktnbfe0092"

vpc_id = "auto"
subnets = "auto"
eks_ami_id = "latest"
repo_version = "v1.7.4"
karpenter = "disabled"
nodegroup_names_style = "simple"

# Metrics Server
metrics_server_replicas            = 1
metrics_server_hostNetwork_enabled = true
metrics_server_containerPort       = 4443

# Istio
istio_ingress_enabled      = true
istio_ingress_force_update = false
istio_ingress_annotation = {
  "service.beta.kubernetes.io/aws-load-balancer-ssl-cert"               = "arn:aws:acm:sa-east-1:559037194348:certificate/43da5954-69fc-417e-9dbf-ed4a3eba6e30"
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
  "sandbox-devsecops-paas.br.experian.eeca"
]
external_dns_logLevel = "debug"
external_dns_extra_args = [
  "--aws-zone-type=private",
]

# Nodes Max Size
eks_managed_node_infra_max_size  = "2"
eks_managed_node_small_max_size  = "2"
eks_managed_node_medium_max_size = "1"
eks_managed_node_larger_max_size = "1"
eks_managed_node_spot_max_size   = "1"

eks_managed_node_infra_instance_type  = "c6i.2xlarge"
eks_managed_node_small_instance_type  = "t3.xlarge"
eks_managed_node_medium_instance_type = "t3.xlarge"
eks_managed_node_large_instance_type  = "t3.2xlarge"
eks_managed_node_spot_instance_type   = "t3.large"