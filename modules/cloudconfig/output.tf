# SPDX-License-Identifier: GPL-3.0-or-later

output "config" {
  value = data.template_cloudinit_config.config.rendered
}
