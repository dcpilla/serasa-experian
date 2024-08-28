terraform {
  required_providers {
    kafka = {
      source  = "Mongey/kafka"
      version = "~> 0.4.3"
    }
  }
  required_version = ">= 0.13"
  experiments      = [module_variable_optional_attrs]
}