resource "aws_servicecatalog_provisioned_product" "route53Domain" {
  name                     = "route53-${var.project_name}-${var.sub_domain}"
  product_id               = var.product_id
  provisioning_artifact_id = var.provisioning_artifact_id

  provisioning_parameters {
    key   = "ParentDomain"
    value = "br.experian.eeca"
  }

  provisioning_parameters {
    key   = "SubDomain"
    value = var.sub_domain
  }

  provisioning_parameters {
    key   = "VPCId"
    value = data.aws_vpc.selected.id
  }

  count = var.sub_domain != "null" ? 1 : 0
}
