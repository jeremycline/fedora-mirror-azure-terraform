# SPDX-License-Identifier: GPL-3.0-or-later

variable "resource_group_name" {
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

variable "vm_users" {
  type = list(string)
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

  # Required but unused ssh key
  ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+UjOzSe0wFUJwGdsli6TMbWoJG8NvERr93Gf9mG0T6beqRfUM1r0Jz3jU3edan/GQphKnlZQOkELmL0bodzfJgRKKrj8/IGY81+aQwySMzw+ARGYDkpQm9e+gpb/jbJNBiyGw7tqfhYM7JUIuAbc1pOzEbjjXoVCwQGE6gebKaf+3TObA3pWkkKGWJ5XZbwdbThXCxrj2s4Hnuyn7WnV4wIk25hkgyjkbLDA+qKfehtw/w9Vp4lRHwPk9wvxo0K9VE6ROks6n6VNibB38K64OUE4ZfbHavBXVtXHnqnSVUkSENzC++SIHf5q553hw31YPm8uGQiHT4levuKK4WFcJ"
}
