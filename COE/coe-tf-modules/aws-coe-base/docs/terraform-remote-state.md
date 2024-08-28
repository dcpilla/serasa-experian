# terraform-remote-state

Retrieves state data from a Terraform backend. This allows you to use the root-level outputs of one or more Terraform configurations as input data for another configuration.

## Example of use 


Create the `data.tf`.

```
data "terraform_remote_state" "aws_base_state" {
  backend = "s3"

  config = {
    bucket  = "serasaexperian-da-odin-${var.env}-tf"
    key     = "aws-base/tf.state"
    region  = "sa-east-1"
    encrypt = true
  }
}
```

Retrieving values from remote s3 state

```
resource "aws_s3_bucket" "example_bucket" {

  bucket = "serasaexperian-${var.project_name}-${var.env}-${var.application_name}"

}

resource "aws_s3_bucket_logging" "example_bucket_log" {
  bucket = aws_s3_bucket.example_bucket.id

  target_bucket = data.terraform_remote_state.aws_base_state.outputs.s3_default_logs
  target_prefix = "logs-${var.application_name}/"
}

```
