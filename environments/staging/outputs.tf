# SPDX-License-Identifier: GPL-3.0-or-later

output "vm_jump_public_ip" {
  value = module.management.vm_jump_public_ip
}

output "vm_monitor_public_ip" {
  value = module.management.vm_monitor_public_ip
}

output "vm_sync_public_ip" {
  value = module.mirror_sync.vm_public_ip
}
