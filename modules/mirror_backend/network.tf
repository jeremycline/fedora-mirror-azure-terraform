# SPDX-License-Identifier: GPL-3.0-or-later

resource "azurerm_subnet" "mirror" {
  name                 = "mirror"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.network.name

  default_outbound_access_enabled = false

  address_prefixes = [
    for i in var.network.address_space :
    cidrsubnet(i, 4, 0)
  ]
}

resource "azurerm_subnet" "appgateway" {
  name                 = "appgateway"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.network.name

  default_outbound_access_enabled = false

  address_prefixes = [
    for i in var.network.address_space :
    cidrsubnet(i, 4, 1)
  ]
}


resource "azurerm_network_security_group" "mirror" {
  name                = "mirror-backend-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowHttpBackend"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 8080
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "appgateway" {
  name                = "appgateway-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowGatewayManager"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "65200-65535"
    source_address_prefix      = "GatewayManager"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "mirror" {
  subnet_id                 = azurerm_subnet.mirror.id
  network_security_group_id = azurerm_network_security_group.mirror.id
}

resource "azurerm_subnet_network_security_group_association" "appgateway" {
  subnet_id                 = azurerm_subnet.appgateway.id
  network_security_group_id = azurerm_network_security_group.appgateway.id
}
