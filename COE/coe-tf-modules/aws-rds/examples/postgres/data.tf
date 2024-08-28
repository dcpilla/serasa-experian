data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["aws-landing-zone-VPC"]
  }
}
