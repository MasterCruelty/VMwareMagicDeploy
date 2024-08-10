# Parameters
$iloIp = "x.x.x.x"
$iloUser = "Administrator"
$iloPassword = "password"
$isoPath = "\\path\to\your\esxi.iso"

# Create a variable with credentials
$securePassword = ConvertTo-SecureString $iloPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($iloUser, $securePassword)

# Install Ilo module(if it's not already installed)
Install-Module -Name HPEiLOCmdlets -Force -AllowClobber

# Connect to Ilo
Connect-HPEiLO -Server $iloIp -Credential $credential

# Mount ESXi ISO
Set-HPEiLOVirtualMedia -Server $iloIp -ImageURL $isoPath -BootOnNextReset $true

# Restart server
Restart-HPEiLOServer -Server $iloIp

# Monitor installation process
# You can add command here to monitor the process and send notifications.
# TODO: review if at restart of Ilo, it starts directly from the cd rom or not.
