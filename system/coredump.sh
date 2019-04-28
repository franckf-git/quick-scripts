#! /bin/bash
#coredump.sh

if [ "$1" = start ]
then
  echo "* soft core unlimited" | sudo tee -a /etc/security/limits.conf
  echo "/tmp/core-%e-%s-%u-%g-%p-%t" | sudo tee /proc/sys/kernel/core_pattern
    
    for SERVICE in $(ls /var/local/services)
      do
         sudo -u $SERVICE sh -c "sysctl -p"
         sudo -u $SERVICE sh -c "ulimit -c unlimited"
      done

elif [ "$1" = stop ]
then
  sudo sed -i "/* soft core unlimited/d" /etc/security/limits.conf
  echo "core" | sudo tee /proc/sys/kernel/core_pattern
    
    for SERVICE in $(ls /var/local/services)
      do
         sudo -u $SERVICE sh -c "sysctl -p"
         sudo -u $SERVICE sh -c "ulimit -c 0"
      done

else
  echo "Usage: coredump.sh start or stop"

fi