#cloud-config
# SPDX-License-Identifier: GPL-3.0-or-later

users:
%{ for user in users ~}
- name: ${ user }
  shell: /bin/bash
  sudo:
  - ALL=(ALL) NOPASSWD:ALL
  groups:
  - adm
  ssh_authorized_keys:
%{ for key in keys[user] ~}
  - ${ key }
%{ endfor ~}
%{ endfor ~}
