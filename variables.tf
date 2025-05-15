variable "Domain_DNSName" {
  description = "FQDN for the Active Directory forest root domain"
  type        = string
  default     = "matheus.local"
  sensitive   = false
}

variable "SafeModeAdministratorPassword" {
    description = "Password for AD Safe Mode recovery"
    type        = string
    default     = "6chh+*O9mP)l7"
    sensitive   = true
}

variable "DomainAdminUser"{
  description = "Usuario Admin User"
  type = string
  default = "admt"
  sensitive = true
}

variable "subscription"{
  description = "ID da Assinatura"
  type = string
}

variable "location"{
  type = string
}

variable "resource_group"{
  type = string
}

variable "vnet_name"{
  type = string
}

variable "snet_name"{
  type = string
}

variable vm_count{
  type = number
}

variable vm_admin_pass{
  type = string
}

variable vm_admin_user{
  type = string
}