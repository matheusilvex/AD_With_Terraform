resource "azurerm_public_ip" "public_IP" {
  name                = "${var.vm_prefix}-pip"
  location            = var.rg_location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "net_interface" {
  name                = "${var.vm_prefix}-nic"
  location            = var.rg_location
  resource_group_name = var.rg_name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.vnet_snet-id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_IP.id
  }
}

resource "azurerm_windows_virtual_machine" "windows_vm" {
  name                = "${var.vm_prefix}-vm"
  resource_group_name = var.rg_name
  location            = var.rg_location
  size                = "Standard_B2ms"
  admin_username      = var.admin_name
  admin_password      = var.admin_pass
  network_interface_ids = [
    azurerm_network_interface.net_interface.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "autoShutdown" {
    depends_on = [azurerm_windows_virtual_machine.windows_vm]
    virtual_machine_id = azurerm_windows_virtual_machine.windows_vm.id
    location           = var.rg_location
    enabled            = var.enableAutoShutdown

    daily_recurrence_time = "1900"
    timezone              = "E. South America Standard Time"
    notification_settings {
        enabled         = false
    }
}