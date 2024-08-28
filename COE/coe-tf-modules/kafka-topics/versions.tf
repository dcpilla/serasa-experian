terraform {
  required_providers {
    kafka = {
      source  = "Mongey/kafka"
      version = "~> 0.4.2"
    }
  }
  required_version = ">= 0.14"
}