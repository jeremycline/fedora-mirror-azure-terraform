# SPDX-License-Identifier: GPL-3.0-or-later

resource "azurerm_linux_virtual_machine" "monitor" {
  name                = "management-monitor"
  location            = var.location
  resource_group_name = var.resource_group_name

  size                  = var.vm_size_override != "" ? var.vm_size_override : "Standard_B1ms"
  network_interface_ids = [azurerm_network_interface.monitor.id]

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
    offer     = "debian-10"
    sku       = "10-gen2"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      admin_ssh_key,
      custom_data,
      os_disk[0].storage_account_type,
    ]
  }
}

resource "azurerm_network_interface" "monitor" {
  name                = "management-monitor"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "v4"
    primary                       = true
    private_ip_address_version    = "IPv4"
    subnet_id                     = azurerm_subnet.management.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_managed_disk" "monitor" {
  name                = "management-monitor_Data"
  location            = var.location
  resource_group_name = var.resource_group_name

  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.disk_size_monitor
}

resource "azurerm_virtual_machine_data_disk_attachment" "monitor" {
  managed_disk_id    = azurerm_managed_disk.monitor.id
  virtual_machine_id = azurerm_linux_virtual_machine.monitor.id

  lun     = "10"
  caching = "ReadWrite"
}
