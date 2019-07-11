cd vpn


$PSDefaultParameterValues['*:Encoding'] = 'utf8'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
 
if ( -not (Test-Path .\keys.tf -PathType Leaf) ) { 
 copy .\keys.tf.sample .\keys.tf
}


if ( -not (Test-Path .\terraform.exe -PathType Leaf) ) { 
 wget "https://releases.hashicorp.com/terraform/0.12.3/terraform_0.12.3_windows_amd64.zip" -outfile terraform_0.12.3_windows_amd64.zip
 Expand-Archive -Path .\terraform_0.12.3_windows_amd64.zip -DestinationPath .\
}


if ( -not (Test-Path .\Shadowsocks.exe -PathType Leaf) ) { 
 wget "https://github.com/shadowsocks/shadowsocks-windows/releases/download/4.1.6/Shadowsocks-4.1.6.zip" -outfile Shadowsocks-4.1.6.zip
 Expand-Archive -Path .\Shadowsocks-4.1.6.zip -DestinationPath .\
}



$random = (  -join( (0..9) | Get-Random -count 10 ) )
gc vpn_setup.sh.tpl | %{ $_ -replace 'test123', "PASS$random" } > vpn_setup.sh


.\terraform.exe init
.\terraform.exe apply -auto-approve
Write-Output "port = 443"
Write-Output "password = PASS$random"

$ip = (.\terraform.exe output ip)
gc gui-config.json.tpl | %{ $_ -replace 'serveriphere', $ip } > gui-config.json.tmp
gc gui-config.json.tmp | %{ $_ -replace 'passwordhere', "PASS$random" } > gui-config.json

start-process .\Shadowsocks.exe

$host.enternestedprompt()