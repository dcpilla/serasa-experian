resource "local_file" "autoscale_down_lambda_rendered" {
  content    = data.template_file.lambda_scale_down.rendered
  filename = format("%s/eks-scale-%s-down.py", path.module, local.cluster_id)

  depends_on = [data.template_file.lambda_scale_down]
}

resource "aws_lambda_function" "eks-scale-down" {
  function_name    = "eks-scale-${local.cluster_id}-down"
  filename         = data.archive_file.eks-scale-down.output_path
  source_code_hash = data.archive_file.eks-scale-down.output_base64sha256
  handler          = "eks-scale-${local.cluster_id}-down.lambda_handler"
  description      = "Autoscale Down EKS nodes"
  timeout          = 900
  role             = aws_iam_role.BURoleForAutoscale.arn
  runtime          = "python3.8"
  depends_on       = [aws_iam_role_policy_attachment.AttachpolicyForAutoscale, data.archive_file.eks-scale-down, data.aws_eks_cluster.eks]
}

resource "aws_cloudwatch_event_rule" "eks-scale-down_event_rule" {
  name                = "eks-scale-${local.cluster_id}-down"
  description         = "Scale Down ${local.cluster_id}"
  schedule_expression = "cron(${local.cron_down})"
  state               = local.state
  depends_on          = [data.aws_eks_cluster.eks]
}

resource "aws_cloudwatch_event_target" "eks-scale-down" {
  arn = aws_lambda_function.eks-scale-down.arn
  rule = aws_cloudwatch_event_rule.eks-scale-down_event_rule.name
}

resource "aws_lambda_permission" "eks-scale-down" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.eks-scale-down.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.eks-scale-down_event_rule.arn
  depends_on    = [data.aws_eks_cluster.eks]
}

resource "aws_cloudwatch_log_group" "scaledown" {
  name              = "/aws/lambda/${aws_lambda_function.eks-scale-down.function_name}"
  retention_in_days = 14
  depends_on        = [data.aws_eks_cluster.eks]
}
