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