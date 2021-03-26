variable "apikey" {}
variable "region" {}
variable "ibmcloud_timeout" { default = 900 }
variable "resource-prefix" { default = "simple-tekton-toolchain" }
variable "resource-group" { default = "" }
variable "tags" { default = ["terraform"] }

terraform {
  required_version = ">= 0.13"

  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
    }
  }
}

provider "ibm" {
  ibmcloud_api_key = var.apikey
  region           = var.region
  generation       = 2
  ibmcloud_timeout = var.ibmcloud_timeout
}

# a resource group
resource "ibm_resource_group" "group" {
  count = var.resource-group != "" ? 0 : 1
  name  = "${var.resource-prefix}-group"
  tags  = var.tags
}

data "ibm_resource_group" "group" {
  count = var.resource-group != "" ? 1 : 0
  name  = var.resource-group
}

locals {
  resource_group_id = var.resource-group != "" ? data.ibm_resource_group.group.0.id : ibm_resource_group.group.0.id
  resource_group_name = var.resource-group != "" ? data.ibm_resource_group.group.0.name : ibm_resource_group.group.0.name
}
