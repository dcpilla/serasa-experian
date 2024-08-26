resource "local_file" "autoscale_up_lambda_rendered" {
  content  = data.template_file.lambda_scale_up.rendered
  filename = format("%s/eks-scale-%s-up.py", path.module, local.cluster_id)

  depends_on = [data.template_file.lambda_scale_up]
}

resource "aws_lambda_function" "eks-scale-up" {
  function_name    = "eks-scale-${local.cluster_id}-up"
  filename         = data.archive_file.eks-scale-up.output_path
  source_code_hash = data.archive_file.eks-scale-up.output_base64sha256
  handler          = "eks-scale-${local.cluster_id}-up.lambda_handler"
  description      = "Autoscale EKS nodes"
  timeout          = 900
  role             = aws_iam_role.BURoleForAutoscale.arn
  runtime          = "python3.8"
  depends_on       = [aws_iam_role_policy_attachment.AttachpolicyForAutoscale, data.archive_file.eks-scale-up, data.aws_eks_cluster.eks]
}

resource "aws_cloudwatch_event_rule" "eks-scale-up_event_rule" {
  name                = "eks-scale-${local.cluster_id}-up"
  description         = "Scale UP ${local.cluster_id}"
  schedule_expression = "cron(${local.cron_up})"
  state               = local.state
  depends_on          = [data.aws_eks_cluster.eks]
}

resource "aws_cloudwatch_event_target" "eks-scale-up" {
  arn        = aws_lambda_function.eks-scale-up.arn
  rule       = aws_cloudwatch_event_rule.eks-scale-up_event_rule.name
  depends_on = [data.aws_eks_cluster.eks]
}

resource "aws_lambda_permission" "eks-scale-up" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.eks-scale-up.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.eks-scale-up_event_rule.arn
  depends_on    = [data.aws_eks_cluster.eks]
}

resource "aws_cloudwatch_log_group" "scaleup" {
  name              = "/aws/lambda/${aws_lambda_function.eks-scale-up.function_name}"
  retention_in_days = 14
  depends_on        = [data.aws_eks_cluster.eks]
}
