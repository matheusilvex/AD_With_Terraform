variable rg_name {
  type        = string
  description = "Nome do Resource Group, seguindo taxonomia, RG-nomeRG-PRD/DEV"
}

variable rg_location{
    type = string
    default = "eastus2"
    description = "Localização do RG."
}