# SPDX-License-Identifier: GPL-3.0-or-later

output "vm_jump_public_ip" {
  value = azurerm_public_ip.jump.ip_address
}
