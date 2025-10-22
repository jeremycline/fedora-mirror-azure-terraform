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

locals {
  backend_address_pool_name      = "${var.network.name}-backend-pool"
  frontend_port_name             = "${var.network.name}-http-port"
  frontend_ip_configuration_name = "${var.network.name}-public-ip"
  http_setting_name              = "${var.network.name}-http-setting"
  listener_name                  = "${var.network.name}-http-listener"
  request_routing_rule_name      = "${var.network.name}-http-rule"
  probe_name                     = "${var.network.name}-health-probe"
}

resource "azurerm_application_gateway" "mirror" {
  name                = "mirror-appgateway-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appgateway-ip-config-${var.location}"
    subnet_id = azurerm_subnet.appgateway.id
  }

  frontend_port {
    name = "${local.frontend_port_name}"
    port = 80
  }

  dynamic "frontend_ip_configuration" {
    for_each = var.ip_configurations

    content {
      name                 = "${local.frontend_ip_configuration_name}-${frontend_ip_configuration.value}"
      public_ip_address_id = azurerm_public_ip.mirror[frontend_ip_configuration.value].id
    }
  }

  dynamic "http_listener" {
    for_each = var.ip_configurations

    content {
      name                           = "${local.listener_name}-${http_listener.value}"
      frontend_ip_configuration_name = "${local.frontend_ip_configuration_name}-${http_listener.value}"
      frontend_port_name             = local.frontend_port_name
      protocol                       = "Http"
    }
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 8080
    protocol              = "Http"
    request_timeout       = 60
    probe_name            = local.probe_name
  }

  # Request routing rules for both IP versions
  dynamic "request_routing_rule" {
    for_each = var.ip_configurations

    content {
      name                       = "${local.request_routing_rule_name}-${request_routing_rule.value}"
      rule_type                  = "Basic"
      http_listener_name         = "${local.listener_name}-${request_routing_rule.value}"
      backend_address_pool_name  = local.backend_address_pool_name
      backend_http_settings_name = local.http_setting_name
      priority                   = request_routing_rule.value == "v4" ? 100 : 101
    }
  }

  probe {
    name                                      = local.probe_name
    protocol                                  = "Http"
    path                                      = "/health"
    host                                      = "127.0.0.1"
    interval                                  = 30
    timeout                                   = 30
    unhealthy_threshold                       = 3
    pick_host_name_from_backend_http_settings = false
  }
}

#locals {
#  appgw_frontend_ip_keys = [
#    for i in azurerm_application_gateway.mirror.frontend_ip_configuration :
#    i.name
#  ]
#  appgw_frontend_ip = zipmap(local.appgw_frontend_ip_keys, azurerm_application_gateway.mirror.frontend_ip_configuration)
#}
#
#resource "azurerm_lb_backend_address_pool_address" "mirror_global" {
#  for_each = var.lb_mirror_global_pool_ids
#
#  name                                = "${var.location}_${each.key}"
#  backend_address_pool_id             = each.value
#  backend_address_ip_configuration_id = local.appgw_frontend_ip[each.key].id
#}
