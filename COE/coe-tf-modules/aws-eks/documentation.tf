locals {
  documention = <<EOF

  # EKS ${var.env} Documentation

  Documentation related to this project

  ## Cluster Information

  |Name|URL/ID|OBS|
  |---|---|---|
  |AWS Account |${data.aws_caller_identity.current.account_id}|Auth OKTA|
  |Cluster Name|${local.cluster_name_env}|Auth AWS ROLE|
  |K8S Version|${var.eks_cluster_version}| |
  |Cluster AZ Enabled|${var.node_groups_multi_az}|${join(", ", var.node_groups_regions)}|
  |Cluster AMI|${lookup(local.ami_eks, var.ami_bottlerocket, null) == null ? var.ami_bottlerocket : local.ami_eks[var.ami_bottlerocket]}| |
  |Cluster Network|${join(", ", var.eks_cluster_node_ipclass == 100 ? data.aws_subnets.internal_pods.ids : data.aws_subnets.experian.ids)}| Network Class ${var.eks_cluster_node_ipclass}|
  |Grafana|${var.external_dns_domain_filters[0]}|Auth Internal|

  ## Node groups
  |Name|Instance Type|OBS|
  |---|---|---|
  EOF

  path_doc_file = "${var.path_documentation_file}/docs/${var.env}.md"
}
resource "local_file" "environment" {
  content  = format("%s %s\n%s", local.documention, replace(join(", ", local.node_groups_to_documentation), ", ", "\n"), var.documention)
  filename = local.path_doc_file
}
