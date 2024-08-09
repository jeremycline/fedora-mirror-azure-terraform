# SPDX-License-Identifier: GPL-3.0-or-later

resource "azurerm_linux_virtual_machine" "mirror" {
  name                = "mirror-sync"
  location            = var.location
  zone                = 1
  resource_group_name = var.resource_group_name

  size                  = var.vm_size_override != "" ? var.vm_size_override : "Standard_D4ps_v5"
  network_interface_ids = [azurerm_network_interface.mirror.id]

  tags = {
    type        = "mirror"
    type_mirror = "sync"
  }

  admin_username = "bootstrap"
  custom_data    = var.vm_custom_data

  admin_ssh_key {
    username   = "bootstrap"
    public_key = var.ssh_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Debian"
    offer     = "debian-12"
    sku       = "12-arm64"
    version   = "latest"
  }

  lifecycle {
    ignore_changes = [
      admin_ssh_key,
      custom_data,
    ]
  }
}

resource "azurerm_network_interface" "mirror" {
  name                = "mirror-sync"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "v4"
    primary                       = true
    private_ip_address_version    = "IPv4"
    subnet_id                     = azurerm_subnet.mirror.id
    public_ip_address_id          = contains(keys(azurerm_public_ip.mirror), "v4") ? azurerm_public_ip.mirror["v4"].id : null
    private_ip_address_allocation = "Dynamic"
  }

  ip_configuration {
    name                          = "v6"
    private_ip_address_version    = "IPv6"
    subnet_id                     = azurerm_subnet.mirror.id
    public_ip_address_id          = contains(keys(azurerm_public_ip.mirror), "v6") ? azurerm_public_ip.mirror["v6"].id : null
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_managed_disk" "mirror" {
  name                = "mirror-sync_Data"
  location            = var.location
  resource_group_name = var.resource_group_name
  zone                = azurerm_linux_virtual_machine.mirror.zone

  create_option        = "Empty"
  disk_size_gb         = var.disk_size
  storage_account_type = var.disk_type
}

resource "azurerm_virtual_machine_data_disk_attachment" "mirror" {
  managed_disk_id    = azurerm_managed_disk.mirror.id
  virtual_machine_id = azurerm_linux_virtual_machine.mirror.id

  lun     = "10"
  caching = "ReadOnly"
}
