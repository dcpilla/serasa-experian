data "aws_eks_cluster" "eks" {
  name = var.cluster_name
}

data "aws_eks_node_groups" "node_groups" {
  cluster_name = var.cluster_name
  depends_on = [data.aws_eks_cluster.eks]
}

data "aws_eks_node_group" "eks_nodes" {
  for_each = data.aws_eks_node_groups.node_groups.names

  cluster_name    = var.cluster_name
  node_group_name = each.value

  depends_on = [data.aws_eks_node_groups.node_groups]
}

data "template_file" "lambda_scale_up" {
  template = "${file("${path.module}/templates/eks-scale-up.py")}"

  vars = {
    cluster_name = var.cluster_name
    bucket_id    = var.bucket
    obj_key      = "${var.bucket_folder}/nodes.json"
  }
  depends_on = [data.aws_eks_cluster.eks]
}

data "template_file" "lambda_scale_down" {
  template = "${file("${path.module}/templates/eks-scale-down.py")}"

  vars = {
    cluster_name = var.cluster_name
    bucket_id    = var.bucket
    obj_key      = "${var.bucket_folder}/nodes.json"
  }
  depends_on = [data.aws_eks_cluster.eks]
}

data "template_file" "lambda_scale_karpenter_down" {
  template = "${file("${path.module}/templates/eks-scale-karpenter-down.py")}"

  vars = {
    cluster_name = var.cluster_name
  }
  depends_on = [data.aws_eks_cluster.eks]
}


data "archive_file" "eks-scale-up" {
  type        = "zip"
  source_file = format("%s/%s", path.module, local_file.autoscale_up_lambda_rendered.filename)
  output_path = format("%s/eks-scale-up.zip", path.module)

  depends_on = [local_file.autoscale_up_lambda_rendered, data.aws_eks_cluster.eks]
}

data "archive_file" "eks-scale-down" {
  type        = "zip"
  source_file = format("%s/%s", path.module, local_file.autoscale_down_lambda_rendered.filename)
  output_path = format("%s/eks-scale-down.zip", path.module)

  depends_on = [local_file.autoscale_down_lambda_rendered, data.aws_eks_cluster.eks]
}

data "archive_file" "eks-scale-karpenter-down" {
  type        = "zip"
  source_file = format("%s/%s", path.module, local_file.autoscale_karpenter_down_lambda_rendered.filename)
  output_path = format("%s/eks-scale-karpenter-down.zip", path.module)

  depends_on = [local_file.autoscale_karpenter_down_lambda_rendered, data.aws_eks_cluster.eks]
}
