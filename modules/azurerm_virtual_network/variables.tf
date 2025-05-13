variable vnet_name{
    type = string
    description  = "ao final, colocar como -PRD ou -DEV"
}

variable snet_name{
    type = string
    description  = "ao final, colocar como -PRD ou -DEV"
}

variable rg_name{
    type = string
}

variable location{
    type = string
    default = "eastus2"
}

variable dnsServer{
    type = list(string)
}