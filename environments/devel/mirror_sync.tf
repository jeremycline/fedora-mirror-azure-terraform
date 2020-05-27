# SPDX-License-Identifier: GPL-3.0-or-later

module "mirror_sync" {
  source = "../../modules/mirror_sync"

  resource_group_name = data.azurerm_resource_group.mirror.name
  location            = local.location_sync
  network             = module.network.networks_hub[local.location_sync]
  disk_size           = 128
  ssh_key             = var.ssh_key
}
