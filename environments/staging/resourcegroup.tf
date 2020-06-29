# SPDX-License-Identifier: GPL-3.0-or-later

data "azurerm_resource_group" "mirror" {
  name = local.resource_group_name
}
