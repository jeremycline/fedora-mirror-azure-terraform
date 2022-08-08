# SPDX-License-Identifier: GPL-3.0-or-later

data "azurerm_traffic_manager_profile" "mirror" {
  for_each = var.trafficmanager_profile_names

  name                = each.value
  resource_group_name = var.trafficmanager_resource_group_name
}

resource "azurerm_traffic_manager_azure_endpoint" "mirror" {
  for_each = var.trafficmanager_profile_names

  name       = "${var.resource_group_name}-${var.location}"
  profile_id = data.azurerm_traffic_manager_profile.mirror[each.value].id

  target_resource_id = azurerm_public_ip.v4.id
  weight             = 100

  enabled = false

  lifecycle {
    ignore_changes = [
      enabled,
    ]
  }
}
