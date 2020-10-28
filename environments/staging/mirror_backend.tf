# SPDX-License-Identifier: GPL-3.0-or-later

module "mirror_backend" {
  source = "../../modules/mirror_backend"

  for_each = local.networks_mirror

  resource_group_name                = data.azurerm_resource_group.mirror.name
  location                           = each.key
  network                            = module.network.networks_mirror[each.key]
  disk_size                          = 16
  ssh_key                            = local.ssh_key
  vm_custom_data                     = module.cloudconfig.config
  vm_size_override                   = "Standard_B1s"
  trafficmanager_resource_group_name = local.trafficmanager_resource_group_name
  trafficmanager_profile_names       = local.trafficmanager_profile_names
}
