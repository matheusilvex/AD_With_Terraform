output "public_ip"{
  value = azurerm_public_ip.public_IP.ip_address
}

output "private_ip"{
  value = azurerm_network_interface.net_interface.private_ip_address
}

output "nameVM"{
  value = azurerm_windows_virtual_machine.windows_vm.name
}

output "vmID"{
  value = azurerm_windows_virtual_machine.windows_vm.id
}
