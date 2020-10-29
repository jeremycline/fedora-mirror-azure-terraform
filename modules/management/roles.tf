# SPDX-License-Identifier: GPL-3.0-or-later

resource "azurerm_role_assignment" "monitor" {
  scope                = data.azurerm_resource_group.group.id
  role_definition_name = "Reader"
  principal_id         = azurerm_linux_virtual_machine.monitor.identity[0].principal_id
}
