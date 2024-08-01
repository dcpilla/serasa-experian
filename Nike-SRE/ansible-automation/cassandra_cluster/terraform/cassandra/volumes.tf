# VOLUMES ATTACH
module "ssd_attach_volume_1a" {
  source = "../modules/ssd_attach"

  az                    = "${var.aws_region}a"
  ebs_instance_count    = "${var.number_of_cassandra_nodes_az_a}"
  disk_size             = "${var.disk_size}"
  disk_type             = "${var.disk_type}"
  iops                  = "${var.iops}"
  throughput            = "${var.throughput}"
  env                   = "${var.env}"
  project_name          = "${var.project_name}"
}

module "ssd_attach_volume_1b" {
  source = "../modules/ssd_attach"
  
  az                    = "${var.aws_region}b"
  ebs_instance_count    = "${var.number_of_cassandra_nodes_az_b}"
  disk_size             = "${var.disk_size}"
  disk_type             = "${var.disk_type}"
  iops                  = "${var.iops}"
  throughput            = "${var.throughput}"
  env                   = "${var.env}"
  project_name          = "${var.project_name}"
}

#module "ssd_attach_volume_1c" {
#  source = "../modules/ssd_attach"
#  
#  az                    = "${var.aws_region}c"
#  ebs_instance_count    = "${var.number_of_cassandra_nodes_az_c}"
#  disk_size             = "${var.disk_size}"
#  disk_type             = "${var.disk_type}"
#  iops                  = "${var.iops}"
#  throughput            = "${var.throughput}"
#  env                   = "${var.env}"
#  project_name          = "${var.project_name}"
#}

# VOLUMES
module "ssd_volume_1a" {
  source = "../modules/ssd"

  ebs_instance_count    = "${var.number_of_cassandra_nodes_az_a}"
  instances             = "${module.cassandra_ec2_instances_1a.instance_ids}"
  volume_ids            = module.ssd_attach_volume_1a.volume_ids
}

module "ssd_volume_1b" {
  source = "../modules/ssd"
  
  ebs_instance_count    = "${var.number_of_cassandra_nodes_az_b}"
  instances             = "${module.cassandra_ec2_instances_1b.instance_ids}"
  volume_ids            = module.ssd_attach_volume_1b.volume_ids
}

#module "ssd_volume_1c" {
#  source = "../modules/ssd"
#  
#  ebs_instance_count    = "${var.number_of_cassandra_nodes_az_c}"
#  instances             = "${module.cassandra_ec2_instances_1c.instance_ids}"
#  volume_ids            = module.ssd_attach_volume_1c.volume_ids
#}
