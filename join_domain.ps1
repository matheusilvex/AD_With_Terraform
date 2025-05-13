param (
    [string]$Domain_DNSName,
    [string]$AdminUser,
    [string]$AdminPassword
)

$User = "$Domain_DNSName\$AdminUser"
$Password = ConvertTo-SecureString $AdminPassword -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential($User, $Password)

Add-Computer -DomainName $Domain_DNSName -Credential $Credential -Restart -Force