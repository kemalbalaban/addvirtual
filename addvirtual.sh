#!/usr/bin/env bash

echo "Hello bro :)"

read -p "Enter your hostname [e.g.: example.test]: " hostname
hostname=${hostname:-example.test}

read -p "Enter your project path [e.g.: /Users/$USER/Sites/...]: " projectpath
projectpath=${projectpath:-"/Users/$USER/Sites/"}


read -p "Error and access log path: [e.g.: /Users/$USER/Sites/logs/]" logpath
logpath=${logpath:-/Users/$USER/Sites/logs/}

read -p "That's true, you can write host file and vhost config file ? [yes/no]: " itistrue

VAR2="yes"
if [ "$itistrue" = "$VAR2" ]
then
   echo "
## $hostname ##
<VirtualHost $hostname:80>
    ServerAdmin webmaster@$hostname
    DocumentRoot \"$projectpath\"
    ServerName $hostname
    ServerAlias www.$hostname
    <Directory \"$projectpath\">
        AllowOverride All
        Order Allow,Deny
        Allow from All
    </Directory>
    ErrorLog \"$logpath$hostname-error_log\"
    CustomLog \"$logpath$hostname-access_log\" common
</VirtualHost>
## $hostname ##" >> /usr/local/etc/httpd/extra/httpd-vhosts.conf
echo
echo "httpd-vhosts file in successfully writen"
echo  "
## $hostname start ##
127.0.0.1 $hostname
## $hostname end ##
" | sudo tee -a /etc/hosts
sudo brew services restart httpd
else
echo "Cancelled process because your choice \"NO\""
fi
