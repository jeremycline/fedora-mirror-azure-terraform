# SPDX-License-Identifier: GPL-3.0-or-later

resource "azurerm_public_ip" "v4" {
  name                = "mirror-backend-${var.location}_v4"
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Dynamic"
  ip_version        = "IPv4"

  lifecycle {
    ignore_changes = [
      domain_name_label,
    ]
  }
}

resource "azurerm_public_ip" "v6" {
  name                = "mirror-backend-${var.location}_v6"
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
  name                = "mirror-backend-${var.location}"
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

resource "azurerm_lb_backend_address_pool" "v4" {
  name                = "v4"
  loadbalancer_id     = azurerm_lb.mirror.id
  resource_group_name = var.resource_group_name
}

resource "azurerm_lb_backend_address_pool" "v6" {
  name                = "v6"
  loadbalancer_id     = azurerm_lb.mirror.id
  resource_group_name = var.resource_group_name
}

resource "azurerm_lb_rule" "http_v4" {
  name                = "http_v4"
  loadbalancer_id     = azurerm_lb.mirror.id
  resource_group_name = var.resource_group_name

  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 8080
  frontend_ip_configuration_name = "v4"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.v4.id
}

resource "azurerm_lb_rule" "http_v6" {
  name                = "http_v6"
  loadbalancer_id     = azurerm_lb.mirror.id
  resource_group_name = var.resource_group_name

  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 8080
  frontend_ip_configuration_name = "v6"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.v6.id
}

resource "azurerm_lb_rule" "rsync_v4" {
  name                = "rsync_v4"
  loadbalancer_id     = azurerm_lb.mirror.id
  resource_group_name = var.resource_group_name

  protocol                       = "Tcp"
  frontend_port                  = 873
  backend_port                   = 873
  frontend_ip_configuration_name = "v4"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.v4.id
}

resource "azurerm_lb_rule" "rsync_v6" {
  name                = "rsync_v6"
  loadbalancer_id     = azurerm_lb.mirror.id
  resource_group_name = var.resource_group_name

  protocol                       = "Tcp"
  frontend_port                  = 873
  backend_port                   = 873
  frontend_ip_configuration_name = "v6"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.v6.id
}
