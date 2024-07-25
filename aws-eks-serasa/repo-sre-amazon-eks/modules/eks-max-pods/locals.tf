locals {

  instance_max_ipv4  = ((data.aws_ec2_instance_type.instance.maximum_network_interfaces - 1) * 
                        (data.aws_ec2_instance_type.instance.maximum_ipv4_addresses_per_interface - 1) + 2)
  
  instance_max_pods  = data.aws_ec2_instance_type.instance.default_vcpus > 30 ? min(local.instance_max_ipv4, 250) : min(local.instance_max_ipv4, 110)

}
