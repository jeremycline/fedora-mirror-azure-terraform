# SPDX-License-Identifier: GPL-3.0-or-later

module "network" {
  source = "../../modules/network"

  resource_group_name = data.azurerm_resource_group.mirror.name
  network_base_v4     = local.network_base_v4
  network_base_v6     = local.network_base_v6
  networks_hub        = local.networks_hub
  networks_mirror     = local.networks_mirror
}
