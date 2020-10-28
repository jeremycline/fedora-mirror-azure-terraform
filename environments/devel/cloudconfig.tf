# SPDX-License-Identifier: GPL-3.0-or-later

module "cloudconfig" {
  source = "../../modules/cloudconfig"

  users = var.vm_users
}
