#!/bin/bash
# Things to note: 
# Adding the quicktiles in with "" on the ends of the string will result in an error

numLines="$(adb devices | wc -l)"
tiles=`cat ./tiles.txt`

if [ "$1" == "-h" ]; then
 echo "Usage:"
 echo "./tiles [-h help][-u update]"
 echo "Simply run the shell program and it will handle the rest"
 exit 0
fi

if [ "$1" == "-u" ]; then
   echo "Updating tile layout"
   if [[ ! -f "./tiles.txt" ]]; then
      touch ./tiles.txt
   fi
   adb shell "settings get secure sysui_qs_tiles" > ./tiles.txt
   echo "Completed. Exiting..."
   exit 0
fi

echo "Beginning QuickTile Initialization"


if [[ ! -f "./tiles.txt" ]]; then
   echo "The Tiles file does not seem to exist."
   read -p "Do you want to create the file? (Y || N) " ans
   shopt -s nocasematch
	if [ $ans == "Y" ] && [ $numLines -eq 3 ]; then
         adb shell "settings get secure sysui_qs_tiles" > ./tiles.txt
         echo "Created text file. Please re-start this program to load quicktiles"
         exit 0
   elif [ $ans ==  "N" ] || [ $numLines -ne 3 ]; then
	   echo "Device is not connected"
       exit 0
   fi
fi

while :
   do
   if [ $numLines  -eq 3 ]; then
      echo "Device Found"
      echo "Device ID: "`adb devices | grep -w "device" | awk '{print $1;}'`
      echo "Device Model: "`adb shell getprop | grep "ro.product.model" | sed 's/^.*: //'`
      echo "Device Carrier: " `adb shell getprop | grep "nfc.fw.dfl_areacode" | sed 's/^.*: //'`
      break
   elif [ $numLines -gt 3 ]; then
      echo "Multiple Devices Detected. Please disconnect one"
   else
      echo "No Devices Found. Please ensure that your device is connected."
   fi
   sleep 5s
done

adb shell "settings put secure sysui_qs_tiles \"$tiles\""

echo "Completed. Exiting..."
