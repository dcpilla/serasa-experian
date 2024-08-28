env                    = "dev"
project_name           = "mlcoe"
eks_cluster_name       = "mlops-eks-k12"
eks_cluster_version    = "1.21"
ami_bottlerocket       = "auto"
resource_business_unit = "Datalab"
resource_owner         = "mlops.sre@br.experian.com"
resource_name          = "BRASA1DHYU01"
rapid7_tag             = "Server LATAM - MLOPS CoE SERASA EXPERIAN"
ad_group               = "12345"
ad_domain              = "br.experian"
centrify_unix_role     = "12456"
node_groups_multi_az   = true
node_groups_regions    = ["sa-east-1a", "sa-east-1b", "sa-east-1c"]

# Metrics Server
metrics_server_version             = "3.8.0"
metrics_server_replicas            = 1
metrics_server_hostNetwork_enabled = true
metrics_server_containerPort       = 4443

# Istio
istio_ingress_enabled = false


# External DNS
external_dns_version  = "1.7.1"
external_dns_provider = "aws"
external_dns_source = [
  "ingress",
  "istio-gateway",
  "istio-virtualservice",
]
external_dns_domain_filters = [
  "dev-mlops.br.experian.eeca"
]
external_dns_logLevel = "debug"
external_dns_extra_args = [
  "--aws-zone-type=private",
]

# Prometheus
prometheus_enabled = false

