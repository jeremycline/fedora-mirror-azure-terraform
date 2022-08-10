# SPDX-License-Identifier: GPL-3.0-or-later

output "vm_jump_public_ip" {
  value = [for k, v in azurerm_public_ip.jump : v.ip_address]
}
