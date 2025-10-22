# SPDX-License-Identifier: GPL-3.0-or-later

resource "azurerm_linux_virtual_machine" "mirror" {
  count = 2

  name                = "mirror-backend-${var.location}-${count.index}"
  location            = var.location
  zone                = count.index + 1
  resource_group_name = var.resource_group_name

  size                  = var.vm_size_override != "" ? var.vm_size_override : "Standard_D2ps_v5"
  network_interface_ids = [azurerm_network_interface.mirror[count.index].id]

  tags = {
    type        = "mirror"
    type_mirror = "backend"
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

  source_image_id = "/communityGalleries/Fedora-5e266ba4-2250-406d-adad-5d73860d958f/images/Fedora-Cloud-42-Arm64/versions/latest"

  lifecycle {
    ignore_changes = [
      admin_ssh_key,
      custom_data,
    ]
  }
}

resource "azurerm_network_interface" "mirror" {
  count = 2

  name                = "mirror-backend-${var.location}-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "v4"
    primary                       = true
    private_ip_address_version    = "IPv4"
    subnet_id                     = azurerm_subnet.mirror.id
    private_ip_address_allocation = "Dynamic"
  }

  ip_configuration {
    name                          = "v6"
    private_ip_address_version    = "IPv6"
    subnet_id                     = azurerm_subnet.mirror.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Associate VMs with Application Gateway backend pool
resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "mirror" {
  count = 2

  network_interface_id    = azurerm_network_interface.mirror[count.index].id
  ip_configuration_name   = "mirror-ipconfig-${count.index}"
  backend_address_pool_id = one(azurerm_application_gateway.mirror.backend_address_pool).id
}

resource "azurerm_managed_disk" "mirror" {
  count = 2

  name                = "mirror-backend-${var.location}-${count.index}_Data"
  location            = var.location
  zone                = azurerm_linux_virtual_machine.mirror[count.index].zone
  resource_group_name = var.resource_group_name

  create_option        = "Empty"
  disk_size_gb         = var.disk_size
  storage_account_type = "PremiumV2_LRS"
}

resource "azurerm_virtual_machine_data_disk_attachment" "mirror" {
  count = 2

  managed_disk_id    = azurerm_managed_disk.mirror[count.index].id
  virtual_machine_id = azurerm_linux_virtual_machine.mirror[count.index].id

  lun     = "10"
  caching = "None"
}
