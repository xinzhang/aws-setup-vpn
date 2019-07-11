cd vpn

Get-Process shadowsocks | stop-process
.\terraform.exe destroy -auto-approve

$host.enternestedprompt()