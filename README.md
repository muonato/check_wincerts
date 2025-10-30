# check_wincerts
Certificate expiration date monitoring for NSClient++ ( https://nsclient.org/ )

## Overview
Monitoring plugin script reads Windows object parameter '*NotAfter*' for certificate(s) name matched with object parameter '*FriendlyName*'.

Plugin script exit code corresponds with the highest severity (or the least days until expiration) of any given certificate.

## Usage
```
PS> check_wincerts.ps1 "<Name>[,<Name>] <Warning> <Critical> [Location]"

Parameters:
    1: String of arguments separated by space

    Name    : Certificate friendly names separated by comma
    Warning : Threshold (days) for monitoring 'warning' alert
    Critical: Threshold (days) for monitoring 'critical' alert
    Location: Certificate store, default: "Cert:\LocalMachine\My"
```
## Examples
1. Check two certificates in default store
```
PS> check_wincerts.ps1 "MyCert,MyOtherCert"
```

2. Opsview / Nagios service check (set warning alert to 60 days and critical alert to 30 days)
```
check_nrpe -H $HOSTADDRESS$ -c check_wincerts -a "MyCert,MyOtherCert 60 30"
```

## Configuration
1. Add check_wincerts command and path to script in your NSClient++ custom configuration file
```
[/settings/external scripts]
allow arguments = true
allow nasty characters = true

[/settings/external scripts/scripts]
check_wincerts = cmd /c echo scripts\custom\check_wincerts.ps1 "$ARG1$"; exit($lastexitcode) | pwsh.exe -command -
```
2. Add reference to your custom configuration file in NSClient++ main configuration
```
[/includes]
myconfig=myconfig.ini
```
3. Nagios / Opsview service check configuration
```
check_nrpe -H $HOSTADDRESS$ -c check_wincerts -a "MyCert,MyOtherCert 60 30"
```
4. Restart service NSClient++ on your host
