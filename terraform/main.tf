variable "ibmcloud_api_key" {}
variable "region" {}
variable "ibmcloud_timeout" { default = 900 }
variable "resourcePrefix" { default = "simple-tekton-toolchain" }
variable "resource_group_name" { default = "" }
variable "tags" { default = ["terraform"] }

terraform {
  required_version = ">= 0.14"

  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
    }
  }
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
  generation       = 2
  ibmcloud_timeout = var.ibmcloud_timeout
}

# a resource group
resource "ibm_resource_group" "group" {
  count = var.resource_group_name != "" ? 0 : 1
  name  = "${var.resourcePrefix}-group"
  tags  = var.tags
}

data "ibm_resource_group" "group" {
  count = var.resource_group_name != "" ? 1 : 0
  name  = var.resource_group_name
}

locals {
  resource_group_id = var.resource_group_name != "" ? data.ibm_resource_group.group.0.id : ibm_resource_group.group.0.id
  resource_group_name = var.resource_group_name != "" ? data.ibm_resource_group.group.0.name : ibm_resource_group.group.0.name
}
