# SPDX-License-Identifier: GPL-3.0-or-later

locals {
  resource_group_name = "debian-mirror-v3-staging"

  vm_users = [
    "waldi",
  ]

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

  trafficmanager_profile_ids = [
    "/subscriptions/f84e5905-7ce0-4716-9d3a-ddd48f487cf4/resourceGroups/debian-mirror/providers/Microsoft.Network/trafficManagerProfiles/debian-archive-staging",
  ]

  # Required but unused ssh key
  ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+UjOzSe0wFUJwGdsli6TMbWoJG8NvERr93Gf9mG0T6beqRfUM1r0Jz3jU3edan/GQphKnlZQOkELmL0bodzfJgRKKrj8/IGY81+aQwySMzw+ARGYDkpQm9e+gpb/jbJNBiyGw7tqfhYM7JUIuAbc1pOzEbjjXoVCwQGE6gebKaf+3TObA3pWkkKGWJ5XZbwdbThXCxrj2s4Hnuyn7WnV4wIk25hkgyjkbLDA+qKfehtw/w9Vp4lRHwPk9wvxo0K9VE6ROks6n6VNibB38K64OUE4ZfbHavBXVtXHnqnSVUkSENzC++SIHf5q553hw31YPm8uGQiHT4levuKK4WFcJ"
}
