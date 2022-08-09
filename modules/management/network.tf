# SPDX-License-Identifier: GPL-3.0-or-later

resource "azurerm_subnet" "management" {
  name                 = "management"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.network.name

  address_prefixes = [
    for i in var.network.address_space :
    cidrsubnet(i, 4, 1)
  ]
}

resource "azurerm_public_ip" "jump" {
  for_each = toset(["v4", "v6"])

  name                = "management-jump_${each.value}"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku               = "Standard"
  allocation_method = "Static"
  ip_version        = "IP${each.value}"

  lifecycle {
    ignore_changes = [
      name,
      domain_name_label,
    ]
  }
}

moved {
  from = azurerm_public_ip.jump
  to   = azurerm_public_ip.jump["v4"]
}
