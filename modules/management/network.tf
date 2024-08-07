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
  name                = "management-jump"
  location            = var.location
  zones               = azurerm_public_ip_prefix.devel.zones
  resource_group_name = var.resource_group_name

  sku                     = "Standard"
  allocation_method       = "Static"
  ip_version              = "IPv6"
  public_ip_prefix_id     = azurerm_public_ip_prefix.devel.id
  idle_timeout_in_minutes = 30

  lifecycle {
    ignore_changes = [
      domain_name_label,
    ]
  }
}

resource "azurerm_public_ip_prefix" "devel" {
  name                = "management"
  location            = var.location
  zones               = [1, 2, 3]
  resource_group_name = var.resource_group_name

  ip_version    = "IPv6"
  prefix_length = 124
}
