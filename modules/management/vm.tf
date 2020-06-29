# SPDX-License-Identifier: GPL-3.0-or-later

resource "azurerm_linux_virtual_machine" "jump" {
  name                = "management-jump"
  location            = var.location
  resource_group_name = var.resource_group_name

  size                  = var.vm_size_override != "" ? var.vm_size_override : "Standard_B1ms"
  network_interface_ids = [
    azurerm_network_interface.jump.id,
  ]

  admin_username = "bootstrap"

  admin_ssh_key {
    username   = "bootstrap"
    public_key = var.ssh_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Debian"
    offer     = "debian-10"
    sku       = "10-gen2"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "jump" {
  name                = "management-jump"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "v4"
    primary                       = true
    private_ip_address_version    = "IPv4"
    subnet_id                     = azurerm_subnet.management.id
    public_ip_address_id          = azurerm_public_ip.jump.id
    private_ip_address_allocation = "Dynamic"
  }
}
