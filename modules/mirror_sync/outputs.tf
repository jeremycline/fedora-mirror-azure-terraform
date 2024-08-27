# SPDX-License-Identifier: GPL-3.0-or-later

output "vm_public_fqdn" {
  value = azurerm_public_ip.mirror["v6"].fqdn
}

output "vm_public_ip" {
  value = {
    for key, value in azurerm_public_ip.mirror :
    key => value.ip_address
  }
}
