# SPDX-License-Identifier: GPL-3.0-or-later

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "network" {
}

variable "ip_configurations" {
  type    = set(string)
  default = ["v6"]
}

variable "disk_size" {
  type = number
}

variable "ssh_key" {
  type = string
}

variable "trafficmanager_profile_ids" {
  type    = set(string)
  default = []
}

variable "vm_custom_data" {
  type = string
}

variable "vm_size_override" {
  type    = string
  default = ""
}
