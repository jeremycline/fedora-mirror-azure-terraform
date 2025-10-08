# SPDX-License-Identifier: GPL-3.0-or-later

resource "random_string" "domain" {
  length  = 16
  upper   = false
  special = false
}

resource "azurerm_public_ip" "mirror" {
  for_each = var.ip_configurations

  name                = "mirror-backend-${var.location}_${each.value}"
  location            = var.location
  zones               = [1, 2, 3]
  resource_group_name = var.resource_group_name

  sku               = "Standard"
  allocation_method = "Static"
  ip_version        = "IP${each.value}"
  domain_name_label = "fedora-mirror-${random_string.domain.result}"
}

resource "azurerm_lb" "mirror" {
  name                = "mirror-backend-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku = "Standard"

  dynamic "frontend_ip_configuration" {
    for_each = var.ip_configurations

    content {
      name                 = frontend_ip_configuration.value
      public_ip_address_id = azurerm_public_ip.mirror[frontend_ip_configuration.value].id
    }
  }
}

resource "azurerm_lb_backend_address_pool" "mirror" {
  for_each = var.ip_configurations

  name            = each.value
  loadbalancer_id = azurerm_lb.mirror.id
}

resource "azurerm_lb_rule" "http" {
  for_each = var.ip_configurations

  name            = "http_${each.value}"
  loadbalancer_id = azurerm_lb.mirror.id

  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 8080
  frontend_ip_configuration_name = each.value
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.mirror[each.value].id]
  probe_id                       = azurerm_lb_probe.http.id
}

resource "azurerm_lb_probe" "http" {
  name            = "http"
  loadbalancer_id = azurerm_lb.mirror.id

  protocol     = "Http"
  port         = 80
  request_path = "/health"
}

locals {
  lb_mirror_frontend_ip_keys = [
    for i in azurerm_lb.mirror.frontend_ip_configuration :
    i.name
  ]
  lb_mirror_frontend_ip = zipmap(local.lb_mirror_frontend_ip_keys, azurerm_lb.mirror.frontend_ip_configuration)
}

resource "azurerm_lb_backend_address_pool_address" "mirror_global" {
  for_each = var.lb_mirror_global_pool_ids

  name                                = "${var.location}_${each.key}"
  backend_address_pool_id             = each.value
  backend_address_ip_configuration_id = local.lb_mirror_frontend_ip[each.key].id
}
