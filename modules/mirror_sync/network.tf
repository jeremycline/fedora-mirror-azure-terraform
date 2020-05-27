# SPDX-License-Identifier: GPL-3.0-or-later

resource "azurerm_subnet" "mirror" {
  name                 = "mirror"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.network.name
  address_prefixes     = [cidrsubnet(var.network.address_space[0], 4, 0)]
}
