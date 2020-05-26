# SPDX-License-Identifier: GPL-3.0-or-later

variable "resource_group_name" {
  type = string
}

variable "networks_hub" {
  type = map(string)
}

variable "networks_mirror" {
  type = map(string)
}
