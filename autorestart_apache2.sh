#! /bin/sh

apachestatus=$(systemctl status apache2.service | grep Active | cut -d" " -f5)

echo $apachestatus

if [ $apachestatus = "active" ]
  then
    echo "tout va bien"
  else
    echo "on redemarre"
    systemctl restart apache2.service
fi
