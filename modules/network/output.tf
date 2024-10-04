# SPDX-License-Identifier: GPL-3.0-or-later

output "networks_hub" {
  value = azurerm_virtual_network.hub
}

output "networks_mirror" {
  value = azurerm_virtual_network.mirror
}

output "lb_mirror_global_fqdn" {
  value = azurerm_public_ip.mirror_global["v6"].fqdn
}

output "lb_mirror_global_ip" {
  value = {
    for key, value in azurerm_public_ip.mirror_global :
    key => value.ip_address
  }
}

output "lb_mirror_global_pool_ids" {
  value = {
    for key, value in azurerm_lb_backend_address_pool.mirror_global :
    key => value.id
  }
}
