# SPDX-License-Identifier: GPL-3.0-or-later

resource "azurerm_public_ip" "v4" {
  name                = "mirror-sync_v4"
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Static"
  ip_version        = "IPv4"

  lifecycle {
    ignore_changes = [
      domain_name_label,
    ]
  }
}

resource "azurerm_public_ip" "v6" {
  name                = "mirror-sync_v6"
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Dynamic"
  ip_version        = "IPv6"

  lifecycle {
    ignore_changes = [
      domain_name_label,
    ]
  }
}

resource "azurerm_lb" "mirror" {
  name                = "mirror-sync"
  location            = var.location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = "v4"
    public_ip_address_id = azurerm_public_ip.v4.id
  }

  frontend_ip_configuration {
    name                 = "v6"
    public_ip_address_id = azurerm_public_ip.v6.id
  }
}

resource "azurerm_lb_nat_rule" "http_v4" {
  name                = "http_v4"
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.mirror.id

  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "v4"
}

resource "azurerm_lb_nat_rule" "http_v6" {
  name                = "http_v6"
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.mirror.id

  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "v6"
}

resource "azurerm_lb_nat_rule" "ssh_v4" {
  name                = "ssh_v4"
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.mirror.id

  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = "v4"
}

resource "azurerm_lb_nat_rule" "ssh_v6" {
  name                = "ssh_v6"
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.mirror.id

  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = "v6"
}
