locals {
  env = terraform.workspace == "default" ? "dev" : terraform.workspace
  cidrs = [
    for item in data.aws_vpc.selected.cidr_block_associations :
    item.cidr_block
  ]

  default_tags = merge({
    ManagedBy   = "Terraform"
    Application = var.application_name
    Project     = var.project_name
    Environment = var.env
    BU          = var.bu_name
  }, var.tags)
  
  eec_kms = {
    us-east-1      = "arn:aws:kms:us-east-1:363353661606:key/923dfe86-1e45-4ff3-a75c-f8e95e7944b0",
    us-west-2      = "arn:aws:kms:us-west-2:363353661606:key/6a611956-f586-47da-bb67-6d305a15fc74",
    ap-south-1     = "arn:aws:kms:ap-south-1:363353661606:key/b7b93891-314f-4e00-8359-4f51d0a0cd09",
    ap-southeast-1 = "arn:aws:kms:ap-southeast-1:363353661606:key/edc1a20a-de45-423c-b06e-ce7485ae3aec",
    ap-southeast-2 = "arn:aws:kms:ap-southeast-2:363353661606:key/ea938280-bcdd-40d5-9302-ced83f9dd4f0",
    ap-northeast-1 = "arn:aws:kms:ap-northeast-1:363353661606:key/4fedb0a1-71e3-4a84-962d-177093b72386",
    eu-central-1   = "arn:aws:kms:eu-central-1:363353661606:key/00424fe0-fe05-4999-9e1c-f73674b8f2fd",
    eu-west-1      = "arn:aws:kms:eu-west-1:363353661606:key/34b027d4-f2c9-4622-b7e1-7043648fb9b1",
    eu-west-2      = "arn:aws:kms:eu-west-2:363353661606:key/4e9611e2-dd2a-4b8c-b79d-1b7602d5155f",
    sa-east-1      = "arn:aws:kms:sa-east-1:363353661606:key/52ef2dd4-4fb4-4e7d-8683-930d90b9e636"
  }

  ### Additional policy for Developers
  policy_statment = [
    for k, v in var.additional_Developers_policy : {
      "Sid" : k,
      "Effect" : "Allow",
      "Action" : [
        for action in v["action"] :
        "${action}"
      ],
      "Resource" : [
        for resource in v["resource"] :
        "${resource}"
      ]
    }
  ]

  aditional_policy = {
    "Version" : "2012-10-17",
    "Statement" : flatten([local.policy_statment])
  }

}
