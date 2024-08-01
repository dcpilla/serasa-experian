module "cassandra_elb" {
   source                = "../modules/elb"

   project_name          = var.project_name
   env                   = var.env

   lb_name               = var.project_name
   lb_ssl_arn            = var.lb_ssl_arn
   lb_internal           = var.lb_internal
   lb_bucket             = var.lb_bucket
   lb_bucket_prefix      = var.lb_bucket_prefix
   lb_log_enabled        = var.lb_log_enabled

   lb_ports              = var.lb_ports

   lb_access_logs        = {
                             enabled = "true"
                           }

}
