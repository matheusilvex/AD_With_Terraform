# Terraform - Infraestrutura com Domain Controller no Azure

Este projeto utiliza **Terraform com módulos** para provisionar uma infraestrutura completa no Microsoft Azure, incluindo:

- Uma ou mais Máquinas Virtuais (VMs)
- Regras de NSG (Network Security Group) com liberação de IPs
- Um Domain Controller (DC)
- Junção automática das VMs ao domínio

## 🚀 Funcionalidades

- **Criação dinâmica de VMs** com base em variáveis de entrada
- **NSG com liberação automática de IPs** das VMs
- **Provisionamento de Domain Controller (AD DS)** em uma VM dedicada
- **Adição automática das VMs ao domínio Active Directory**

## 🧰 Pré-requisitos

- Terraform >= 1.3.x
- Conta no Azure com permissões para criar recursos
- Azure CLI autenticado (`az login`)
- SSH key ou senha para as VMs

📌 Observações
A junção ao domínio é feita via script de provisionamento remoto (usando WinRM)

Certifique-se de que as VMs estão na mesma rede/sub-rede do Domain Controller

Regras de firewall e NSG devem permitir as portas necessárias para comunicação AD/WinRM