# SPDX-License-Identifier: GPL-3.0-or-later

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"

    content = templatefile("${path.module}/cloudconfig.tpl", {
      users = var.users,

      keys = {
        for user in var.users :
        user => split("\n", data.http.keys[user].body)
      }
    })
  }
}
