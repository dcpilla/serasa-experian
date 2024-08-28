# This is a PUBLIC SSH RSA used in new EC2 instances, the private rsa is stored in a safe place.
resource "aws_key_pair" "mlcoe" {
  key_name   = var.key_pair_name
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHlZ2krwtWqcDx+uQg1JN0zAYZdqZe3MYK0+jqs6WfZBfia/o80LLqrasryTTEJsvtKeX0n0fiYiYAD4CXGZcN5tqRrYkniVFileqhClUuJUmjuhuSDyVDrbG75cUHFJzPJzFSXr69AMilW+U60s0eOVElaAPTgguutSb+ToXeKt4FBKteFYlpn6uvTSbI6baJ75uT7KxXiR0gYoRucW+FLp4d5i8xPJNdTtUZ2TQfp5P4zH5cPx7oWRiKqZ8duyU35jIi2S9AVkw7xSMeDfcZ1Zy45TecxCIMfXn2yi5TdqvC+qS9bHPP14VvXtfioTISTT7cHR1MAmRD8D+zSPKX mlcoe"

  tags  = local.default_tags
  count = var.key_pair_create ? 1 : 0
}
