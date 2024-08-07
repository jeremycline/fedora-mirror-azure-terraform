# SPDX-License-Identifier: GPL-3.0-or-later

module "mirror_sync" {
  source = "../../modules/mirror_sync"

  resource_group_name = data.azurerm_resource_group.mirror.name
  location            = local.location_sync
  network             = module.network.networks_hub[local.location_sync]
  disk_size           = 32
  ssh_key             = local.ssh_key
  vm_custom_data      = module.cloudconfig.config
  vm_size_override    = "Standard_D2pls_v5"
}
