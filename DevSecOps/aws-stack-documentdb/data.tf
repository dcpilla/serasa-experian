data "aws_vpc" "selected" {
  tags = {
    AWS_Solutions = "LandingZoneStackSet"
  }
}

data "aws_subnets" "available" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  tags = {
    Network = "Private"
  }
}

data "external" "sg-exists" {
  program = ["/tmp/venv/bin/python3.10", "${path.module}/utils/helpers/check_sg_exists.py"]

  query   = {
    sg_name   = local.default_security_group
    accountid = var.aws_account_id
    buname    = var.bu
    region    = var.region
  }
}

data "external" "docdb-subnet-exists" {
  program = ["/tmp/venv/bin/python3.10", "${path.module}/utils/helpers/check_docdb_subnet_groups.py"]

  query   = {
    subnet_name = "subnet-group-${var.cluster_name}"
    accountid   = var.aws_account_id
    buname      = var.bu
    region      = var.region
  }
}

data "external" "docdb-parameter-exists" {
  program = ["/tmp/venv/bin/python3.10", "${path.module}/utils/helpers/check_docdb_parameter_groups.py"]

  query   = {
    parameter_name = "parameter-group-${var.cluster_name}"
    accountid      = var.aws_account_id
    buname         = var.bu
    region         = var.region
  }
}
