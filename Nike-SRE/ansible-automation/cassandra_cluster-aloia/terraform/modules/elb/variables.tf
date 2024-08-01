variable "env" {
    type = string
}

variable "project_name" {
    type = string
}

variable "lb_name" {
  type = string
}

variable "lb_internal" {
  default = false
}

variable "lb_type" {
  type    = string
  default = "network"
}

variable "lb_ip_address_type" {
  type    = string
  default = "ipv4"
}

variable "lb_enable_cross_zone_load_balancing" {
  default = true
}

variable "lb_log_enabled" {
  default = true
}

variable "lb_bucket" {
  type = string
}

variable "lb_bucket_prefix" {
  type = string
}

variable "lb_autoscaling_group_name" {
  default = null
}

variable "lb_tags" {
  type = map
  default = {}
}

variable "lb_ssl_arn" {
  default = null
}

variable "lb_security_policy" {
  description = "The security policy if using TLS or HTTPS"
  default = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "lb_ports" {
  type    = map(object({
    name     = string
    protocol = string
    port     = number
  }))
  
  default = {
    "http"  = {
      name      = "http"
      protocol  = "TCP"
      port      = 80
    }
    "https" = {
      name      = "https"
      protocol  = "TLS"
      port      = 443
    }
  }
}

variable "lb_access_logs" {
  description = "An access logs block"
  type        = map(string)
  default     = {}
}
