# SPDX-License-Identifier: GPL-3.0-or-later

variable "resource_group_name" {
  type = string
}

variable "ssh_key" {
  type = string
}

locals {
  networks_hub = {
    "westeurope" = "10.211.0.0/24"
  }

  networks_mirror = {
    "westeurope" = "10.211.4.0/24"
    "westus2"    = "10.211.5.0/24"
  }

  location_sync = "westeurope"
}
