# SPDX-License-Identifier: GPL-3.0-or-later

resource "azurerm_availability_set" "mirror" {
  name                = "mirror-backend-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name

  managed                      = true
  platform_update_domain_count = 3
  platform_fault_domain_count  = 2

  lifecycle {
    ignore_changes = [
      platform_update_domain_count,
      platform_fault_domain_count,
    ]
  }
}

resource "azurerm_linux_virtual_machine" "mirror" {
  count = 2

  name                = "mirror-backend-${var.location}-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name

  size                  = var.vm_size_override != "" ? var.vm_size_override : "Standard_D2ds_v4"
  availability_set_id   = azurerm_availability_set.mirror.id
  network_interface_ids = [
    azurerm_network_interface.mirror[count.index].id,
  ]

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

resource "azurerm_network_interface_backend_address_pool_association" "mirror_v4" {
  count = 2

  network_interface_id    = azurerm_network_interface.mirror[count.index].id
  ip_configuration_name   = "v4"
  backend_address_pool_id = azurerm_lb_backend_address_pool.v4.id
}

resource "azurerm_network_interface_backend_address_pool_association" "mirror_v6" {
  count = 2

  network_interface_id    = azurerm_network_interface.mirror[count.index].id
  ip_configuration_name   = "v6"
  backend_address_pool_id = azurerm_lb_backend_address_pool.v6.id

  # v4 needs to be attached before v6
  depends_on = [azurerm_network_interface_backend_address_pool_association.mirror_v4]
}

resource "azurerm_managed_disk" "mirror" {
  count = 2

  name                = "mirror-backend-${var.location}-${count.index}_Data"
  location            = var.location
  resource_group_name = var.resource_group_name

  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.disk_size
}

resource "azurerm_virtual_machine_data_disk_attachment" "mirror" {
  count = 2

  managed_disk_id    = azurerm_managed_disk.mirror[count.index].id
  virtual_machine_id = azurerm_linux_virtual_machine.mirror[count.index].id

  lun     = "10"
  caching = "ReadOnly"
}
