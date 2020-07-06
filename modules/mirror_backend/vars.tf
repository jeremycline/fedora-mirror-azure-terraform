# SPDX-License-Identifier: GPL-3.0-or-later

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "network" {
}

variable "disk_size" {
  type = number
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

variable "vm_size_override" {
  type    = string
  default = ""
}
