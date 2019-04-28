#!/bin/bash

wicca(){
  local lp=2551443
  local now=$(date -u +"%s")
  local newmoon=592500
  local phase=$((($now - $newmoon) % $lp))
  local phase_number=$((((phase / 86400) + 1)*100000))

  local calendar=$(date -u +"%m%d")

  if   [ $phase_number -lt 184566 ];  then phase_icon="○ marbat"  # new
  elif [ $phase_number -lt 553699 ];  then phase_icon="❩"  # waxing crescent
  elif [ $phase_number -lt 922831 ];  then phase_icon="◗"  # first quarter
  elif [ $phase_number -lt 1291963 ]; then phase_icon="◑"  # first quarter
  elif [ $phase_number -lt 1661096 ]; then phase_icon="● esbat"  # full
  elif [ $phase_number -lt 2030228 ]; then phase_icon="◐"  # waning gibbous
  elif [ $phase_number -lt 2399361 ]; then phase_icon="◖"  # last quarter
  elif [ $phase_number -lt 2768493 ]; then phase_icon="❨"  # waning crescent
  else
    phase_icon="○ marbat"  # new
  fi

  if   [ $calendar = 1221 ]; then sabbat="Yule"
  elif [ $calendar = 0202 ]; then sabbat="Imbolc"
  elif [ $calendar = 0321 ]; then sabbat="Ostara"
  elif [ $calendar = 0501 ]; then sabbat="Beltane"
  elif [ $calendar = 0621 ]; then sabbat="Litha"
  elif [ $calendar = 0801 ]; then sabbat="Lammas"
  elif [ $calendar = 0921 ]; then sabbat="Mabon"
  elif [ $calendar = 1031 ]; then sabbat="Samhain"
  else
    sabbat=" "
  fi

  echo $phase_icon $sabbat
}

wicca