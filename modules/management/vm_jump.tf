# SPDX-License-Identifier: GPL-3.0-or-later

resource "azurerm_linux_virtual_machine" "jump" {
  name                = "management-jump"
  location            = var.location
  zone                = 1
  resource_group_name = var.resource_group_name

  size                  = var.vm_size_override != "" ? var.vm_size_override : "Standard_D2pls_v5"
  network_interface_ids = [azurerm_network_interface.jump.id]

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

  lifecycle {
    ignore_changes = [
      admin_ssh_key,
      custom_data,
      os_disk[0].storage_account_type,
    ]
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
    private_ip_address_allocation = "Dynamic"
  }

  ip_configuration {
    name                          = "v6"
    private_ip_address_version    = "IPv6"
    subnet_id                     = azurerm_subnet.management.id
    public_ip_address_id          = azurerm_public_ip.jump.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_security_group" "jump" {
  name                = "management-jump"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowSsh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "jump" {
  network_interface_id      = azurerm_network_interface.jump.id
  network_security_group_id = azurerm_network_security_group.jump.id
}
