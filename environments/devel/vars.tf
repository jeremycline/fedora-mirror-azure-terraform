# SPDX-License-Identifier: GPL-3.0-or-later

variable "subscription_id" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "trafficmanager_profile_ids" {
  type    = set(string)
  default = []
}

variable "vm_users" {
  type = list(string)
}

locals {
  network_base_v4 = "10.211.0.0/16"
  network_base_v6 = "fe00:632b:2465:100::/52"

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
  ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDOm05Ms4RxPGHrSqXu1UvO/f/b8BOSRlZYYGqhaVIrjk1ObR7OC67HRMPxi4y+ILwRve87OQ2jpmM4E16RB/fNpPjnsBLPI1zYDnhRwAzPVRbubxA5DW/W9WbKR62UqRKrzxg68a2yeFnkmVJS0g3I+6V9YTZtlL61nytRiZnA+327sE0nSAh9GPqZkDFPy1PeS8mqjqO6Y5ATSjfSopdqnZ5O0cUXu8dMvZpnVSwKN74Kgd0DGFk9GTEWtse9/xY8HXPmru8mbZnEfuYMKR5xaBBEluDpFHwzyOdI5DocaOREUZCxU+7AY7eeeKszpujOQgChwT+pQxvfmL7XpOqf"
}
