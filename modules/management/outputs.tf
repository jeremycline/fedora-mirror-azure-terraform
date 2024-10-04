# SPDX-License-Identifier: GPL-3.0-or-later

output "vm_jump_public_fqdn" {
  value = azurerm_public_ip.jump.fqdn
}

output "vm_jump_public_ip" {
  value = azurerm_public_ip.jump.ip_address
}

output "vm_monitor_public_fqdn" {
  value = azurerm_public_ip.monitor.fqdn
}

output "vm_monitor_public_ip" {
  value = azurerm_public_ip.monitor.ip_address
}
