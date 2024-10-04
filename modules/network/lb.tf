# SPDX-License-Identifier: GPL-3.0-or-later

resource "azurerm_public_ip" "mirror_global" {
  for_each = var.ip_configurations

  name                = "mirror-backend_global_${each.value}"
  location            = "East US 2"
  resource_group_name = var.resource_group_name

  sku                     = "Standard"
  sku_tier                = "Global"
  allocation_method       = "Static"
  ip_version              = "IP${each.value}"
  idle_timeout_in_minutes = 30
  domain_name_label       = var.set_domain_name_label ? "${var.resource_group_name}-mirror" : null
}

resource "azurerm_lb" "mirror_global" {
  name                = "mirror-backend_global"
  location            = "East US 2"
  resource_group_name = var.resource_group_name

  sku      = "Standard"
  sku_tier = "Global"

  dynamic "frontend_ip_configuration" {
    for_each = var.ip_configurations

    content {
      name                 = frontend_ip_configuration.value
      public_ip_address_id = azurerm_public_ip.mirror_global[frontend_ip_configuration.value].id
    }
  }
}

resource "azurerm_lb_backend_address_pool" "mirror_global" {
  for_each = var.ip_configurations

  name            = each.value
  loadbalancer_id = azurerm_lb.mirror_global.id
}

resource "azurerm_lb_rule" "mirror_global_http" {
  for_each = var.ip_configurations

  name            = "http_${each.value}"
  loadbalancer_id = azurerm_lb.mirror_global.id

  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = each.value
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.mirror_global[each.value].id]
}
