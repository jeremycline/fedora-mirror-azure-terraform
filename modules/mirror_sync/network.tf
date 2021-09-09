# SPDX-License-Identifier: GPL-3.0-or-later

resource "azurerm_subnet" "mirror" {
  name                 = "mirror"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.network.name

  address_prefixes = [
    for i in var.network.address_space :
    cidrsubnet(i, 4, 0)
  ]
}
