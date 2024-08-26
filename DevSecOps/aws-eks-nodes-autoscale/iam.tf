resource "aws_iam_policy" "BUPolicyForAutoscaleEKS" {
  name        = "BUPolicyForAutoscaleEKS"
  description = "Enable and disable AutoScale EKS"
  tags = local.tags
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "1",
        "Action": [
          "eks:ListNodegroups",
          "eks:UpdateNodegroupConfig",
          "eks:DescribeNodeGroup",
          "eks:DescribeCluster",
          "eks:TagResource",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "sqs:*",
          "lambda:*",
          "xray:*",
          "cloudWatch:*",
          "ec2:RunInstances",
          "ec2:TerminateInstances",
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:DescribeInstances",
          "ec2:CreateTags",
          "ec2:DeleteTags",
          "ec2:ModifyInstanceAttribute",
          "s3:*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  })

  depends_on = [data.aws_eks_cluster.eks]
}

resource "aws_iam_role" "BURoleForAutoscale" {
  name        = "BURoleForAutoscale"
  description = "Autoscale NodeGroups EKS"
  tags = local.tags

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "AttachpolicyForAutoscale" {
  role       = aws_iam_role.BURoleForAutoscale.name
  policy_arn = aws_iam_policy.BUPolicyForAutoscaleEKS.arn
}
