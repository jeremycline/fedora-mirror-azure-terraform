# SPDX-License-Identifier: GPL-3.0-or-later

module "management" {
  source = "../../modules/management"

  resource_group_name = data.azurerm_resource_group.mirror.name
  location            = local.location_management
  network             = module.network.networks_hub[local.location_management]
  ssh_key             = local.ssh_key
  vm_custom_data      = module.cloudconfig.config
  vm_size_override    = "Standard_B1s"
}
