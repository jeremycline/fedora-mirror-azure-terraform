# SPDX-License-Identifier: GPL-3.0-or-later

resource "azurerm_virtual_network" "hub" {
  for_each = var.networks_hub

  name                = "hub-${each.key}"
  location            = each.key
  resource_group_name = var.resource_group_name

  address_space = [each.value]
}

resource "azurerm_virtual_network" "mirror" {
  for_each = var.networks_mirror

  name                = "mirror-backend-${each.key}"
  location            = each.key
  resource_group_name = var.resource_group_name

  address_space = [each.value]
}

resource "azurerm_virtual_network_peering" "hub2mirror" {
  for_each = {
    for pair in setproduct(keys(var.networks_hub), keys(var.networks_mirror)):
    "${pair[0]}-${pair[1]}" => {
      hub    = azurerm_virtual_network.hub[pair[0]]
      mirror = azurerm_virtual_network.mirror[pair[1]]
    }
  }

  name                 = "mirror-${each.key}"
  virtual_network_name = each.value.hub.name
  resource_group_name  = var.resource_group_name

  remote_virtual_network_id    = each.value.mirror.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  # `allow_gateway_transit` must be set to false for vnet Global Peering
  allow_gateway_transit = false
}

resource "azurerm_virtual_network_peering" "mirror2hub" {
  for_each = {
    for pair in setproduct(keys(var.networks_hub), keys(var.networks_mirror)):
    "${pair[0]}-${pair[1]}" => {
      hub    = azurerm_virtual_network.hub[pair[0]]
      mirror = azurerm_virtual_network.mirror[pair[1]]
    }
  }

  name                 = each.key
  virtual_network_name = each.value.mirror.name
  resource_group_name  = var.resource_group_name

  remote_virtual_network_id    = each.value.hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  # `allow_gateway_transit` must be set to false for vnet Global Peering
  allow_gateway_transit = false
}
