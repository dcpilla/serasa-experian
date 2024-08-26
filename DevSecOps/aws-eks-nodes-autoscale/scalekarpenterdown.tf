resource "local_file" "autoscale_karpenter_down_lambda_rendered" {
  content    = data.template_file.lambda_scale_karpenter_down.rendered
  filename = format("%s/eks-scale-%s-karpenter-down.py", path.module, local.cluster_id)

  depends_on = [data.template_file.lambda_scale_karpenter_down]
}

resource "aws_lambda_function" "eks-scale-karpenter-down" {
  function_name    = "eks-scale-${local.cluster_id}-karpenter-down"
  filename         = data.archive_file.eks-scale-karpenter-down.output_path
  source_code_hash = data.archive_file.eks-scale-karpenter-down.output_base64sha256
  handler          = "eks-scale-${local.cluster_id}-karpenter-down.lambda_handler"
  description      = "Autoscale Karpenter Down EKS nodes"
  timeout          = 30
  role             = aws_iam_role.BURoleForAutoscale.arn
  runtime          = "python3.8"
  depends_on       = [aws_iam_role_policy_attachment.AttachpolicyForAutoscale, data.archive_file.eks-scale-karpenter-down, data.aws_eks_cluster.eks]
}

resource "aws_cloudwatch_event_rule" "eks-scale-karpenter-down_event_rule" {
  name                = "eks-scale-${local.cluster_id}-karpenter-down"
  description         = "Scale Karpenter Down ${local.cluster_id}"
  schedule_expression = "cron(${local.cron_karpenter_down})"
  state               = local.state
  depends_on          = [data.aws_eks_cluster.eks]
}

resource "aws_cloudwatch_event_target" "eks-scale-karpenter-down" {
  arn = aws_lambda_function.eks-scale-karpenter-down.arn
  rule = aws_cloudwatch_event_rule.eks-scale-karpenter-down_event_rule.name
}

resource "aws_lambda_permission" "eks-scale-karpenter-down" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.eks-scale-karpenter-down.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.eks-scale-karpenter-down_event_rule.arn
  depends_on    = [data.aws_eks_cluster.eks]
}

resource "aws_cloudwatch_log_group" "scalekarpenterdown" {
  name              = "/aws/lambda/${aws_lambda_function.eks-scale-karpenter-down.function_name}"
  retention_in_days = 14
  depends_on        = [data.aws_eks_cluster.eks]
}
