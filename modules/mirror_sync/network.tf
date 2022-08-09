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

resource "azurerm_network_security_group" "mirror" {
  name                = "mirror-sync"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowHttp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 80
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowSsh"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 22
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "mirror" {
  subnet_id                 = azurerm_subnet.mirror.id
  network_security_group_id = azurerm_network_security_group.mirror.id
}
