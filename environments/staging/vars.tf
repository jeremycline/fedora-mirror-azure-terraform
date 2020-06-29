# SPDX-License-Identifier: GPL-3.0-or-later

variable "ssh_key" {
  type    = string
}

locals {
  resource_group_name = "debian-mirror-v2-staging"

  network_base_v4 = "10.212.0.0/16"
  network_base_v6 = "fd81:632b:2465:200::/52"

  networks_hub = {
    "westus2" = 0
  }

  networks_mirror = {
    "westeurope" = 4
    "westus2"    = 5
  }

  location_management = "westus2"
  location_sync       = "westus2"
}
