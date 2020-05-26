# SPDX-License-Identifier: GPL-3.0-or-later

module "network" {
  source = "../../modules/network"

  resource_group_name = data.azurerm_resource_group.mirror.name
  networks_hub        = local.networks_hub
  networks_mirror     = local.networks_mirror
}
