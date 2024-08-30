# SPDX-License-Identifier: GPL-3.0-or-later

module "mirror_backend" {
  source = "../../modules/mirror_backend"

  for_each = local.networks_mirror

  resource_group_name        = data.azurerm_resource_group.mirror.name
  location                   = each.key
  network                    = module.network.networks_mirror[each.key]
  lb_mirror_global_pool_ids  = module.network.lb_mirror_global_pool_ids
  disk_size                  = 2048
  ssh_key                    = local.ssh_key
  vm_custom_data             = module.cloudconfig.config
  trafficmanager_profile_ids = local.trafficmanager_profile_ids
  ip_configurations          = ["v4", "v6"]
}
