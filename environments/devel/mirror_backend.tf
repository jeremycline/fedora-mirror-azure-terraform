# SPDX-License-Identifier: GPL-3.0-or-later

module "mirror_backend" {
  source = "../../modules/mirror_backend"

  for_each = local.networks_mirror

  resource_group_name        = data.azurerm_resource_group.mirror.name
  location                   = each.key
  network                    = module.network.networks_mirror[each.key]
  disk_size                  = 128
  ssh_key                    = local.ssh_key
  vm_custom_data             = module.cloudconfig.config
  trafficmanager_profile_ids = var.trafficmanager_profile_ids
}
