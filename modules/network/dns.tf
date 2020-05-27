# SPDX-License-Identifier: GPL-3.0-or-later

resource "azurerm_private_dns_zone" "mirror" {
  name                = "${var.resource_group_name}.azure.debian.test"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "hub" {
  for_each = var.networks_hub

  name                = "mirror-hub-${each.key}"
  resource_group_name = var.resource_group_name

  private_dns_zone_name = azurerm_private_dns_zone.mirror.name
  virtual_network_id    = azurerm_virtual_network.hub[each.key].id

  registration_enabled = true
}

resource "azurerm_private_dns_zone_virtual_network_link" "mirror" {
  for_each = var.networks_mirror

  name                = "mirror-backend-${each.key}"
  resource_group_name = var.resource_group_name

  private_dns_zone_name = azurerm_private_dns_zone.mirror.name
  virtual_network_id    = azurerm_virtual_network.mirror[each.key].id

  registration_enabled = true
}
