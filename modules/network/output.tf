# SPDX-License-Identifier: GPL-3.0-or-later

output "networks_hub" {
  value = azurerm_virtual_network.hub
}

output "networks_mirror" {
  value = azurerm_virtual_network.mirror
}
