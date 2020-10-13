# SPDX-License-Identifier: GPL-3.0-or-later

variable "ssh_key" {
  type    = string
}

locals {
  resource_group_name = "debian-mirror-v2-prod"

  network_base_v4 = "10.213.0.0/16"
  network_base_v6 = "fd81:632b:2465:300::/52"

  networks_hub = {
    "westus2" = 0
  }

  networks_mirror = {
    "westeurope" = 4
    "westus2"    = 5
  }

  location_management = "westus2"
  location_sync       = "westus2"

  trafficmanager_resource_group_name = "debian-mirror"
  trafficmanager_profile_names       = ["debian-archive", "debian-archive-staging"]
}
