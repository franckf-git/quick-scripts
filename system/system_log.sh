#!/bin/bash
#enregistre date, connectés et uptime
#+ dans un fichier log
{
date +%d-%m-%y\ %H:%M:%S
who | awk '{print $1}'
uptime -p
}> journal.log
exit 0