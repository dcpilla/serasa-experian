locals {
  kms_eks   = try(aws_kms_key.eks_secret[0].arn, data.aws_kms_alias.kms_eks.target_key_arn)
  kms_alias = var.kms_alias == "" ? "alias/aws/rds" : var.kms_alias
}

data "aws_kms_alias" "kms_eks" {
  name = local.kms_alias
}
resource "aws_kms_key" "eks_secret" {
  description             = "MLOPS-EKS"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  tags = merge({
    "typeUse" = "eks"
  }, local.default_tags_eks)
  policy = <<EOF
{
    "Id": "mlops-eks-policy-1",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
                    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/BUAdministratorAccessRole"
                ]
            },
            "Action": "kms:*",
            "Resource": "*"
        }
    ]
}
EOF
  count  = var.kms_alias == "" ? 1 : 0
}

# The EEC AMIs are encrypted, as such, we need to grant the Auto Scaling Service Link Role access to use the KMS key so it can decrypt the root volume for usage.
resource "aws_kms_grant" "eec_kms_asg_grant" {
  name              = "eec-ami-asg-grant"
  key_id            = local.eec_kms_key[data.aws_region.current.name]
  grantee_principal = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
  operations        = ["Encrypt", "Decrypt", "ReEncryptFrom", "ReEncryptTo", "GenerateDataKey", "GenerateDataKeyWithoutPlaintext", "DescribeKey", "CreateGrant"]
  count             = var.kms_alias == "" ? 1 : 0
}

locals {
  eec_kms_key = {
    "us-east-1"      = "arn:aws:kms:us-east-1:363353661606:key/923dfe86-1e45-4ff3-a75c-f8e95e7944b0"
    "us-west-2"      = "arn:aws:kms:us-west-2:363353661606:key/6a611956-f586-47da-bb67-6d305a15fc74"
    "ap-south-1"     = "arn:aws:kms:ap-south-1:363353661606:key/b7b93891-314f-4e00-8359-4f51d0a0cd09"
    "ap-southeast-1" = "arn:aws:kms:ap-southeast-1:363353661606:key/edc1a20a-de45-423c-b06e-ce7485ae3aec"
    "ap-southeast-2" = "arn:aws:kms:ap-southeast-2:363353661606:key/ea938280-bcdd-40d5-9302-ced83f9dd4f0"
    "ap-northeast-1" = "arn:aws:kms:ap-northeast-1:363353661606:key/4fedb0a1-71e3-4a84-962d-177093b72386"
    "eu-central-1"   = "arn:aws:kms:eu-central-1:363353661606:key/00424fe0-fe05-4999-9e1c-f73674b8f2fd"
    "eu-west-1"      = "arn:aws:kms:eu-west-1:363353661606:key/34b027d4-f2c9-4622-b7e1-7043648fb9b1"
    "eu-west-2"      = "arn:aws:kms:eu-west-2:363353661606:key/4e9611e2-dd2a-4b8c-b79d-1b7602d5155f"
    "sa-east-1"      = "arn:aws:kms:sa-east-1:363353661606:key/52ef2dd4-4fb4-4e7d-8683-930d90b9e636"

  }
}
