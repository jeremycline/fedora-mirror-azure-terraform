# SPDX-License-Identifier: GPL-3.0-or-later

resource "azurerm_traffic_manager_endpoint" "mirror" {
  for_each = var.trafficmanager_profile_names

  name                = "${var.resource_group_name}-${var.location}"
  resource_group_name = var.trafficmanager_resource_group_name
  profile_name        = each.value

  type               = "azureEndpoints"
  target_resource_id = azurerm_public_ip.v4.id

  endpoint_status = "Disabled"

  lifecycle {
    ignore_changes = [
      endpoint_status,
    ]
  }
}
