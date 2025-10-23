# SPDX-License-Identifier: GPL-3.0-or-later

locals {
  subscription_id     = "8ddde9ba-f5e7-4a4f-a9a1-64181b250697"
  resource_group_name = "fedora-mirror-v1-staging"

  vm_users = [
    "jcline",
  ]

  network_base_v4 = "10.212.0.0/16"
  network_base_v6 = "fe00:632b:2465:200::/52"

  networks_hub = {
    "westus2" = 0
  }

  networks_mirror = {
    "eastus2" = 4
    "westus2"    = 5
  }

  location_management = "westus2"
  location_sync       = "westus2"

  trafficmanager_profile_ids = [
    "/subscriptions/8ddde9ba-f5e7-4a4f-a9a1-64181b250697/resourceGroups/fedora-mirror/providers/Microsoft.Network/trafficManagerProfiles/fedora-archive-staging",
  ]

  # Required but unused ssh key
  ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDOm05Ms4RxPGHrSqXu1UvO/f/b8BOSRlZYYGqhaVIrjk1ObR7OC67HRMPxi4y+ILwRve87OQ2jpmM4E16RB/fNpPjnsBLPI1zYDnhRwAzPVRbubxA5DW/W9WbKR62UqRKrzxg68a2yeFnkmVJS0g3I+6V9YTZtlL61nytRiZnA+327sE0nSAh9GPqZkDFPy1PeS8mqjqO6Y5ATSjfSopdqnZ5O0cUXu8dMvZpnVSwKN74Kgd0DGFk9GTEWtse9/xY8HXPmru8mbZnEfuYMKR5xaBBEluDpFHwzyOdI5DocaOREUZCxU+7AY7eeeKszpujOQgChwT+pQxvfmL7XpOqf"
}
