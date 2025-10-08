# SPDX-License-Identifier: GPL-3.0-or-later

data "http" "keys" {
  for_each = {
    for i in var.users :
    i => 1
  }

  url = "https://forge.fedoraproject.org/${each.key}.keys"
}
