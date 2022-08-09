# SPDX-License-Identifier: GPL-3.0-or-later

resource "azurerm_traffic_manager_azure_endpoint" "mirror" {
  for_each = var.trafficmanager_profile_ids

  name       = "${var.resource_group_name}-${var.location}"
  profile_id = each.value

  target_resource_id = azurerm_public_ip.v4.id
  weight             = 100

  enabled = false

  lifecycle {
    ignore_changes = [
      enabled,
    ]
  }
}
