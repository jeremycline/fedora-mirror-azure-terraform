# SPDX-License-Identifier: GPL-3.0-or-later

resource "azurerm_public_ip" "mirror" {
  for_each = var.ip_configurations

  name                = "mirror-sync_${each.value}"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku                     = "Standard"
  allocation_method       = "Static"
  ip_version              = "IP${each.value}"
  idle_timeout_in_minutes = 30
  domain_name_label       = var.domain_name_label
}


moved {
  from = azurerm_public_ip.v4
  to   = azurerm_public_ip.mirror["v4"]
}

moved {
  from = azurerm_public_ip.v6
  to   = azurerm_public_ip.mirror["v6"]
}

resource "azurerm_lb" "mirror" {
  name                = "mirror-sync"
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

resource "azurerm_lb_nat_rule" "http" {
  for_each = var.ip_configurations

  name                = "http_${each.value}"
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.mirror.id

  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = each.value
}

moved {
  from = azurerm_lb_nat_rule.http_v4
  to   = azurerm_lb_nat_rule.http["v4"]
}

moved {
  from = azurerm_lb_nat_rule.http_v6
  to   = azurerm_lb_nat_rule.http["v6"]
}

resource "azurerm_lb_nat_rule" "ssh" {
  for_each = var.ip_configurations

  name                = "ssh_${each.value}"
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.mirror.id

  protocol                       = "Tcp"
  frontend_port                  = 22
  backend_port                   = 22
  frontend_ip_configuration_name = each.value
}

moved {
  from = azurerm_lb_nat_rule.ssh_v4
  to   = azurerm_lb_nat_rule.ssh["v4"]
}

moved {
  from = azurerm_lb_nat_rule.ssh_v6
  to   = azurerm_lb_nat_rule.ssh["v6"]
}
