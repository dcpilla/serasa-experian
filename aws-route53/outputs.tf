output "zone_id" {
  description = "Zone ID"
  value       =  module.route_53.zone_id
}

output "zone_name" {
  description = "Name of the hosted zone to contain the records"
  value       =  module.route_53.zone_name
}

output "hostname" {
  description = "Name of the hostname"
  value       = module.route_53.hostname
}

output "record_deleted" {
  value       = module.route_53.record_deleted
}

output "record_created" {
  value       = module.route_53.record_created
}
