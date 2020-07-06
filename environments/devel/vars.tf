# SPDX-License-Identifier: GPL-3.0-or-later

variable "resource_group_name" {
  type = string
}

variable "ssh_key" {
  type = string
}

variable "trafficmanager_resource_group_name" {
  type    = string
  default = ""
}

variable "trafficmanager_profile_names" {
  type    = set(string)
  default = []
}

locals {
  network_base_v4 = "10.211.0.0/16"
  network_base_v6 = "fd81:632b:2465:100::/52"

  networks_hub = {
    "westeurope" = 0
  }

  networks_mirror = {
    "westeurope" = 4
    "westus2"    = 5
  }

  location_management = "westeurope"
  location_sync       = "westeurope"
}
