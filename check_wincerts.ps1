<# muonato/check_wincerts.ps1 @ GitHub (30-OCT-2025)

Reports expiration date of certificates with friendly name

Usage:
    PS> check_wincerts.ps1 "<Name>[,<Name>] [Warning] [Critical] [Location]"

Parameters:
    1: String of arguments separated by space

    1/1 : String of certificate friendly names separated by comma
    1/2 : Warning threshold (days) in monitoring service check
    1/3 : Critical threshold (days) in monitoring service check
    1/4 : Certificate location [default: "Cert:\LocalMachine\My"]

Examples:
    1. Check two certificates in default store
    PS> check_wincerts.ps1 "MyCert,MyOtherCert"

    2. Opsview / Nagios service check (set warning and critical alert threshold)
    check_nrpe -H $HOSTADDRESS$ -c check_wincerts -a "MyCert,MyOtherCert 60 30"

#>
$Vars = $args.Split(" ")
$Name, $W, $C, $Store = $Vars

$Store = if ($Store -eq $null) {"Cert:\LocalMachine\My"}

$Report = ""
$Status = 0

$Certs = $Name.Split(",")

foreach ($Cert in $Certs) {
    $Target = Get-ChildItem -Path $Store | Where-Object { $_.FriendlyName -eq $Cert }
    $Expiry = "UNKNOWN"
    $Remain = 0

    if ($Target) {
        $Expiry = Get-Date (($Target).NotAfter) -Format d
        $Remain = (New-TimeSpan -Start (Get-Date) -End $Expiry).Days
        $Status = if ($Remain -lt $C) {2} elseif ($Remain -lt $W -and $Status -lt 2) {1} else {$Status}
    }
    $Report += "$Cert`: NotAfter ($Expiry) $Remain days`r`n"
}

Write-Output $Report

exit $Status
