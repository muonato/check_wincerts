# check_wincerts
Certificate expiration date monitoring for NSClient++ ( https://nsclient.org/ )

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
