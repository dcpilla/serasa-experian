#Cassandra Security Group
resource "aws_security_group" "ssh" {
  name = "${local.prefix}-ssh"
  description = "Security group for ssh access"
  vpc_id = data.aws_vpc.selected.id
  tags = {
    Terraform-managed = true
    Project = "${var.project_name}"
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  # Allow all SSH External
  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["10.96.0.0/15"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["10.0.0.0/8"]
  }

}

resource "aws_security_group" "node_exporter_sg" {
  name = "${local.prefix}-ne"
  description = "Security group for Node Exporter"
  vpc_id = data.aws_vpc.selected.id
  tags = {
    Terraform-managed = true
    Environment = "${var.env}"
    Project = "${var.project_name}"
  }

    egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

    ingress {
    from_port = 9100
    to_port = 9100
    protocol = "TCP"
    self  = true
    cidr_blocks = ["10.0.0.0/8"]
  }

    ingress {
    from_port = 9100
    to_port = 9100
    protocol = "TCP"
    self  = true
    cidr_blocks = ["100.64.0.0/16"]
  }

    ingress {
    from_port = 9101
    to_port = 9101
    protocol = "TCP"
    self  = true
    cidr_blocks = ["10.0.0.0/8"]
  }

    ingress {
    from_port = 9101
    to_port = 9101
    protocol = "TCP"
    self  = true
    cidr_blocks = ["100.64.0.0/16"]
  }

}

resource "aws_security_group" "cassandra_sg" {
  name = "${local.prefix}-sg"
  description = "Security group for Cassandra"
  vpc_id = data.aws_vpc.selected.id
  tags = {
    Terraform-managed = true
    Environment = "${var.env}"
    Project = "${var.project_name}"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  # Cassandra inter-node cluster communication
  ingress {
    from_port = 7000
    to_port = 7000
    protocol = "TCP"
    self  = true
    cidr_blocks = ["10.0.0.0/8"]
  }

  # Cassandra SSL inter-node cluster communication
  ingress {
    from_port = 7001
    to_port = 7001
    protocol = "TCP"
    self  = true
    cidr_blocks = ["10.0.0.0/8"]
  }

  # Cassandra JMX monitoring port
  ingress {
    from_port = 7199
    to_port = 7199
    protocol = "TCP"
    self  = true
    cidr_blocks = ["10.0.0.0/8"]
  }

  # Cassandra exporter monitoring port
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "TCP"
    self  = true
    cidr_blocks = ["10.0.0.0/8"]
  }

  # Cassandra client port
  ingress {
    from_port = 9042
    to_port = 9042
    protocol = "TCP"
    self  = true
    cidr_blocks = ["10.0.0.0/8"]
    
  }

  # Cassandra client port
  ingress {
    from_port = 9042
    to_port = 9042
    protocol = "TCP"
    self  = true
    cidr_blocks = ["100.64.0.0/16"]
  }
}
