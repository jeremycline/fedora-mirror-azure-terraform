# SPDX-License-Identifier: GPL-3.0-or-later

module "mirror_backend" {
  source = "../../modules/mirror_backend"

  for_each = local.networks_mirror

  resource_group_name                = data.azurerm_resource_group.mirror.name
  location                           = each.key
  network                            = module.network.networks_mirror[each.key]
  disk_size                          = 1024
  ssh_key                            = var.ssh_key
  trafficmanager_resource_group_name = local.trafficmanager_resource_group_name
  trafficmanager_profile_names       = local.trafficmanager_profile_names
}
