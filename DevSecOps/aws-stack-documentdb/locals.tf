locals {
  sg_exists           = data.external.sg-exists.result.sg
  sg_existing_id      = data.external.sg-exists.result.sg_id
  security_group_ids  = local.sg_exists != "exists" ? [aws_security_group.this[0].id] : [local.sg_existing_id]

  subnet_group_exists = data.external.docdb-subnet-exists.result.subnet
  subnet_arn          = local.subnet_group_exists != "exists" ? data.external.docdb-subnet-exists.result.subnet_arn : ""
  cluster_family      = "docdb${substr(var.engine_version, 0, 3)}"

  parameter_group_exists = data.external.docdb-parameter-exists.result.parameter
  default_security_group = "SGFor${title(var.project)}DocDB"

  eec_tags = ({
    "Asset_Category"  = var.category_new
    "Data_Category"   = var.category_data
    "Data_Type"       = var.data_type
    "CostString"      = var.cost_string
    "AppID"           = var.app_id
  })

  tags = "${merge(
    tomap(local.eec_tags),
    tomap({
      Environment = "${var.env_map[var.env]}"
      BU          = "${var.bu}"
      Terraform   = "true"
      Project     = "${var.project}"
    }), "${var.tags}"
  )}"

}
