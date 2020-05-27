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
