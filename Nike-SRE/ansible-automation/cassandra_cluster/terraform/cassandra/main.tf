resource "aws_placement_group" "ec2_pg" {
  name     = "pg-${local.prefix}"
  strategy = "cluster"
}

module "cassandra_ec2_instances_1a" {
   source                = "../modules/ec2"

   account_id            = var.account_id
   BU                    = var.BU
   subnet_name           = var.subnet["1a"]
   use_placement_group   = true
   env                   = var.env
   placement_group_name  = aws_placement_group.ec2_pg.name
   instance_count        = var.number_of_cassandra_nodes_az_a
   ami                   = var.ami != null ? var.ami : data.aws_ami.amazon-linux-2.id
   instance_type         = var.instance_type
   project_name          = var.project_name
   keypair_name          = var.keypair_name
   security_group_ids    = [aws_security_group.cassandra_sg.id, aws_security_group.ssh.id, aws_security_group.node_exporter_sg.id]
   vpc_id                = data.aws_vpc.selected.id
   iam_instance_profile  = aws_iam_instance_profile.cassandra_iam_instance_profile.id
   tags                  = var.tags
   userdata              = var.userdata
   resource_name         = var.resource_name != null ? var.resource_name : "BRASA1${upper(substr(var.env,0,1))}DBUCS01"
   metadata_options      = var.metadata_options

}

module "cassandra_ec2_instances_1b" {
   source                = "../modules/ec2"

   account_id            = var.account_id
   BU                    = var.BU
   subnet_name           = var.subnet["1b"]
   use_placement_group   = true
   env                   = var.env
   placement_group_name  = aws_placement_group.ec2_pg.name
   instance_count        = var.number_of_cassandra_nodes_az_b
   ami                   = var.ami != null ? var.ami : data.aws_ami.amazon-linux-2.id
   instance_type         = var.instance_type
   project_name          = var.project_name
   keypair_name          = var.keypair_name
   security_group_ids    = [aws_security_group.cassandra_sg.id, aws_security_group.ssh.id, aws_security_group.node_exporter_sg.id]
   vpc_id                = data.aws_vpc.selected.id
   iam_instance_profile  = aws_iam_instance_profile.cassandra_iam_instance_profile.id
   tags                  = var.tags
   userdata              = var.userdata
   resource_name         = var.resource_name != null ? var.resource_name : "BRASA1${upper(substr(var.env,0,1))}DBUCS01"
   metadata_options      = var.metadata_options
}

#module "cassandra_ec2_instances_1c" {
#   source                = "../modules/ec2"
#
#   account_id            = var.account_id
#   BU                    = var.BU
#   subnet_name           = var.subnet["1c"]
#   use_placement_group   = true
#   env                   = var.env
#   placement_group_name  = aws_placement_group.ec2_pg.name
#   instance_count        = var.number_of_cassandra_nodes_az_c
#   ami                   = var.ami != null ? var.ami : data.aws_ami.amazon-linux-2.id
#   instance_type         = var.instance_type
#   project_name          = var.project_name
#   keypair_name          = var.keypair_name
#   security_group_ids    = [aws_security_group.cassandra_sg.id, aws_security_group.ssh.id, aws_security_group.node_exporter_sg.id]
#   vpc_id                = data.aws_vpc.selected.id
#   iam_instance_profile  = aws_iam_instance_profile.cassandra_iam_instance_profile.id
#   tags                  = var.tags
#   userdata              = var.userdata
#   resource_name         = var.resource_name != null ? var.resource_name : "BRASA1${upper(substr(var.env,0,1))}DBUCS01"
#   metadata_options      = var.metadata_options
#}

resource "aws_iam_role_policy" "ec2_read_tags_only" {
    name = "BUPolicyForEC2ReadTagsOnlyIam"
    role = aws_iam_role.cassandra_iam_role.id
    policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
         {
             "Action": [
                 "ec2:DescribeInstances",
                 "ec2:DescribeTags"
             ],
             "Resource": "*",
             "Effect": "Allow"
         }
       ]
    })
}

resource "aws_iam_role_policy" "list_account_information" {
    name = "BUPolicyForListAccountInformation"
    role = aws_iam_role.cassandra_iam_role.id
    policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
          {
              "Action": [
                  "iam:ListAccountAliases"
              ],
              "Resource": "*",
              "Effect": "Allow"
          },
          {
             "Action": [
                  "sts:GetCallerIdentity"
              ],
              "Resource": "*",
              "Effect": "Allow"
         }
      ]
    })
}

resource "aws_iam_role" "cassandra_iam_role" {
    name        = "BURoleForCassandraCluster"
    description = "cassandra cluster role for EC2."

    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

    permissions_boundary = "arn:aws:iam::${var.account_id}:policy/BUAdminBasePolicy"

    tags = {
        Environment       = var.env
        Project           = var.project_name
        Terraform-managed = true
    }
}

resource "aws_iam_role_policy_attachment" "cassandra_iam_role_policy_attachment_ASSM" {
    role       = aws_iam_role.cassandra_iam_role.id
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_instance_profile" "cassandra_iam_instance_profile" {
    role = aws_iam_role.cassandra_iam_role.id
    name = "cassandra-cluster_iam_instance_profile"
}
