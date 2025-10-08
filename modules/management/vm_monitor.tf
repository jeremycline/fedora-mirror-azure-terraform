# SPDX-License-Identifier: GPL-3.0-or-later

resource "azurerm_linux_virtual_machine" "monitor" {
  name                = "management-monitor"
  location            = var.location
  zone                = 1
  resource_group_name = var.resource_group_name

  size                  = var.vm_size_override != "" ? var.vm_size_override : "Standard_D2pls_v5"
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

  source_image_id = "/communityGalleries/Fedora-5e266ba4-2250-406d-adad-5d73860d958f/images/Fedora-Cloud-43-Arm64/versions/latest"

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

  ip_configuration {
    name                          = "v6"
    private_ip_address_version    = "IPv6"
    subnet_id                     = azurerm_subnet.management.id
    public_ip_address_id          = azurerm_public_ip.monitor.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_managed_disk" "monitor" {
  name                = "management-monitor_Data"
  location            = var.location
  zone                = 1
  resource_group_name = var.resource_group_name

  create_option        = "Empty"
  disk_size_gb         = var.disk_size_monitor
  storage_account_type = "PremiumV2_LRS"
}

resource "azurerm_virtual_machine_data_disk_attachment" "monitor" {
  managed_disk_id    = azurerm_managed_disk.monitor.id
  virtual_machine_id = azurerm_linux_virtual_machine.monitor.id

  lun     = "10"
  caching = "None"
}

resource "azurerm_network_security_group" "monitor" {
  name                = "management-monitor"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowHttps"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "monitor" {
  network_interface_id      = azurerm_network_interface.monitor.id
  network_security_group_id = azurerm_network_security_group.monitor.id
}
