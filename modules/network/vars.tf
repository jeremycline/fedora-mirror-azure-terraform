# SPDX-License-Identifier: GPL-3.0-or-later

variable "resource_group_name" {
  type = string
}

variable "network_base_v4" {
  type = string
}

variable "network_base_v6" {
  type = string
}

variable "networks_hub" {
  type = map(number)
}

variable "networks_mirror" {
  type = map(number)
}

variable "ip_configurations" {
  type    = set(string)
  default = ["v6"]
}

variable "set_domain_name_label" {
  type    = bool
  default = false
}
