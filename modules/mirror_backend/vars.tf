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

variable "disk_type" {
  type    = string
  default = "StandardSSD_LRS"
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
