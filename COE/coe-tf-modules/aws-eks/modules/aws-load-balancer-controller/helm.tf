resource "helm_release" "aws-load-balancer-controller" {
  name                = "aws-load-balancer-controller"
  repository          = format("oci://%s.dkr.ecr.sa-east-1.amazonaws.com", var.resources_aws_account)
  chart               = "aws-load-balancer-controller"
  version             = var.helm_version
  namespace           = var.eks_namespace
  repository_username = data.aws_ecr_authorization_token.token.user_name
  repository_password = data.aws_ecr_authorization_token.token.password
  force_update        = true
  create_namespace    = true
  max_history         = 7
  wait                = false
  values = [
    "${templatefile(
      "${path.module}/templates/aws-load-balancer-values.tftpl",
      {
        "repository_url"     = "${format("%s.dkr.ecr.sa-east-1.amazonaws.com/eks/aws-load-balancer-controller", var.resources_aws_account)}"
        "image_tag"          = "v2.7.1 "
        "local_cluster_name" = "${local.cluster_name_env}"
        "role"               = "${aws_iam_role.BURoleForAwsLoadbalanceController.arn}"
        "env"                = "${var.env}"
        "coststring"         = "${var.coststring}"
        "appid"              = "${var.appid}"
      }
    )}"
  ]
  depends_on = [
    aws_iam_role.BURoleForAwsLoadbalanceController
  ]
}


