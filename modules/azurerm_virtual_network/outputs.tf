output "vnet_id" {
  value       = azurerm_virtual_network.virtual_network.id
}

output "snet_id"{
  value = azurerm_subnet.subnet_network.id
}