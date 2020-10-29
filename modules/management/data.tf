# SPDX-License-Identifier: GPL-3.0-or-later

data "azurerm_resource_group" "group" {
  name = var.resource_group_name
}
