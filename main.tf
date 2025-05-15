provider "azurerm" {
    features {
        virtual_machine{
            skip_shutdown_and_force_delete = true
            delete_os_disk_on_deletion = true
    }
        resource_group{
            prevent_deletion_if_contains_resources = false
        }
    }
    subscription_id = var.subscription
}

module "resource_group"{
    source = "./modules/azurerm_resource_group"
    rg_name = var.resource_group
    rg_location = var.location
}

module "virtual_network"{
    depends_on = [module.resource_group]
    source = "./modules/azurerm_virtual_network"
    location = module.resource_group.resource_group_location
    rg_name = module.resource_group.resource_group_name
    vnet_name = var.vnet_name
    snet_name = var.snet_name
    dnsServer = ["10.0.1.4", "168.63.129.16"]
}

module "windows_vm"{
    depends_on = [module.virtual_network]
    source = "./modules/azurerm_windows_virtual_machine"
    count = var.vm_count #Numero de VM que vai criar
    rg_name = module.resource_group.resource_group_name
    rg_location = module.resource_group.resource_group_location
    vm_prefix = "VM-MABS-${count.index}"
    vnet_snet-id = module.virtual_network.snet_id
    admin_name = var.vm_admin_user
    admin_pass= var.vm_admin_pass
    
}

module "nsg"{
    depends_on = [module.virtual_network]
    source = "./modules/azurerm_network_security_group"
    rg_name = module.resource_group.resource_group_name
    rg_location = module.resource_group.resource_group_location
    nsg_prefix = module.resource_group.resource_group_name
    snet_id = module.virtual_network.snet_id
    publicIPsource = data.external.myPublicIP.result["ip"]
}

data "external" "myPublicIP"{
    program = ["pwsh", "-Command", "curl 'http://myexternalip.com/json'"]
}

#Install Active Directory on the DC0 VM
resource "azurerm_virtual_machine_extension" "install_ad" {
    depends_on = [module.windows_vm]
    name                 = "install_ad-ds"
# resource_group_name  = azurerm_resource_group.main.name
    virtual_machine_id   = module.windows_vm[0].vmID
    publisher            = "Microsoft.Compute"
    type                 = "CustomScriptExtension"
    type_handler_version = "1.9"

    protected_settings = <<SETTINGS
    {    
        "commandToExecute": "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.ADDS.rendered)}')) | Out-File -filepath createAD.ps1\" && powershell -ExecutionPolicy Unrestricted -File createAD.ps1 -Domain_DNSName ${data.template_file.ADDS.vars.Domain_DNSName} -SafeModeAdministratorPassword ${data.template_file.ADDS.vars.SafeModeAdministratorPassword}"
    }
    SETTINGS
}

#Variable input for the ADDS.ps1 script
data "template_file" "ADDS" {
    template = "${file("createAD.ps1")}"
    vars = {
        Domain_DNSName          = "${var.Domain_DNSName}"
        SafeModeAdministratorPassword = "${var.SafeModeAdministratorPassword}"
  }
}

##Comandos Utilizado em caso se tiver mais de uma VM e adicionar no AD.
resource "azurerm_virtual_machine_extension" "join_domain" {
    depends_on = [azurerm_virtual_machine_extension.install_ad]
    count                = length(module.windows_vm) > 1 ? length(module.windows_vm) - 1 : 0
    name                 = "join_domain"
    virtual_machine_id   = module.windows_vm[count.index + 1].vmID
    #resource_group_name  = module.resource_group.resource_group_name
    publisher            = "Microsoft.Compute"
    type                 = "CustomScriptExtension"
    type_handler_version = "1.9"

    protected_settings = <<SETTINGS
    {
        "commandToExecute": "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.ADDS-Join.rendered)}')) | Out-File -filepath joinDomain.ps1\" && powershell -ExecutionPolicy Unrestricted -File joinDomain.ps1 -Domain_DNSName ${data.template_file.ADDS.vars.Domain_DNSName} -AdminUser ${data.template_file.ADDS-Join.vars.DomainAdminUser} -AdminPassword ${data.template_file.ADDS-Join.vars.DomainAdminPassword}"
    }
    SETTINGS
}

#Variable input for the ADDS.ps1 script
data "template_file" "ADDS-Join" {
    template = "${file("join_domain.ps1")}"
    vars = {
        Domain_DNSName          = "${var.Domain_DNSName}"
        DomainAdminUser         = "${var.DomainAdminUser}"
        DomainAdminPassword = "${var.SafeModeAdministratorPassword}"
  }
}
