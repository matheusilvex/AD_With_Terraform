resource "azurerm_network_security_group" "nsg" {
  name                = "NSG-${var.nsg_prefix}"
  location            = var.rg_location
  resource_group_name = var.rg_name
}

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = var.snet_id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_security_rule" "AllowRDP" {
  name                        = "AllowRDP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = var.publicIPsource
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}