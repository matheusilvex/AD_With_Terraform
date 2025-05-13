[CmdletBinding()]

param 
( 
    [Parameter(ValuefromPipeline=$true,Mandatory=$true)] [string]$Domain_DNSName,
    [Parameter(ValuefromPipeline=$true,Mandatory=$true)] [String]$SafeModeAdministratorPassword
)

$SMAP = ConvertTo-SecureString -AsPlainText $SafeModeAdministratorPassword -Force

Install-windowsfeature -name AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName $Domain_DNSName -NoRebootOnCompletion:$false -Force:$true -SafeModeAdministratorPassword $SMAP