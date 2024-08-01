terraform {
  backend "s3" {
    key = "sa-east-1/elasticache/negativescache-pf-redis-v2/terraform.tfstate"
  }
}

provider "aws" {
  region  = "sa-east-1"
  profile = "dsprod"

  default_tags {
    tags = local.common_tags
  }
}

locals {
  common_tags = {
    "Asset_Category" = "Production"
    "AppID"          = "19558"
    "CostString"     = "1800.BR.100.404506"
    "CreateBy"       = "Terraform"
    "service"        = "redis" 
    "cost-map-by-layer" =	"DcF_layer_gold_by_type"
    "cost_map_segregated_dataset_all_services" = "DcF_negativos"
    "cost_map_segregated_dataset" = "Redis_DcF_negativos"
    "layer"          = "gold"
    "Name"           = "negativescache-pf-redis-v2"
    "Asset_Category"	= "Productive data"
    "cost-map-nike-layer" =	"Redis_DcF_gold"
    "Data_Category"  = "Negative"
    "Data_Type"      = "PP/LP"
    "Environment"    = "prod"
    "map-migrated"   = "d-server-02n52mmgua5hr6"
    "Squad"          = "Kratos"
    "cost-map-nike-team" = "DcF"
    "Project"        = "nike"
    "Service"        = "latam_nike"
    "wiz_cig"        = "true"
  }
}

# module "negativescache-pf-redis-v2" {
#   source = "git::https://code.experian.local/scm/nikesre/terraform-elasticache.git?ref=v1.4.3"

#   env                     = local.common_tags.Environment
#   replication_group_id    = "negativescache-pf-redis-v2"
#   cluster_mode_enabled    = false
#   multi_az_enabled        = true
#   subnet_ids              = ["subnet-05299cb9dc9141075","subnet-045273b50eefbe23c","subnet-0702c5cd6296c292b"]
#   num_node_groups         = 1
#   replicas_per_node_group = 1
#   transit_encryption_enabled = true
#   node_type               = "cache.t4g.micro"
#   automatic_failover_enabled = "true"

#   ingress_rules = [
#     {
#       description = "Allow default redis port to VPC aws-landing-zone-VPC"
#       cidr_ipv4   = "100.65.0.0/16" # Sample
#       ip_protocol = "TCP"
#       from_port   = 6379
#       to_port     = 6379
#     },
#     {
#       description = "Allow default redis port to VPC aws-landing-zone-VPC"
#       cidr_ipv4   = "10.99.27.0/24" # Sample
#       ip_protocol = "TCP"
#       from_port   = 6379
#       to_port     = 6379
#     },
#     {
#       description = "Allow default redis port to VPC aws-landing-zone-VPC"
#       cidr_ipv4   = "100.64.0.0/16" # Sample
#       ip_protocol = "TCP"
#       from_port   = 6379
#       to_port     = 6379
#     }    
#   ]

#   egress_rules = [
#     {
#       cidr_ipv4   = "0.0.0.0/0"
#       ip_protocol = "-1"
#     }
#   ]
# }
