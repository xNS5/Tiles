#!/bin/bash
echo "Beginning QuickTile Initialization"

# Things to note: 
# Adding the quicktiles in with "" on the ends of the string will result in an error
# My path for my alias is ~/Github/CS/scripts/tiles/tiles.sh

tiles=`cat $(dirname "$0")/tiles.txt`

echo "$path"


function getLines(){
  return `adb devices | wc -l`;
}

if [ "$1" == "-h" ]; then
 echo "Usage: ./tiles [-h help]"
 echo "Simply run the shell program and it will handle the rest"
 return
fi


if [ "$1" == "-u" ]; then
   echo "Updating tile layout"
   adb shell "settings get secure sysui_qs_tiles" > $path/tiles.txt
   echo "Completed. Exiting..."
   return
fi


if [ ${#tiles} -eq 0 ]; then
   echo "The Tiles file does not seem to exist."
   read -p "Do you want to create the file? (Y || N) " ans
   shopt -s nocasematch
   getLines
	if [ $ans -eq "Y" ] && [ $?-eq 3 ]; then
         adb shell "settings get secure sysui_qs_tiles" > $path/tiles.txt
         echo "Created text file. Please re-start this program to load quicktiles"
         exit 0
	elif [ $ans -eq "N" ] || [ $ans -eq "Y" ] && [ $? -ne 3]; then
	echo "Device is not connected"
       exit 0
   fi
fi



while :
   do
   getLines
   if [ $? -eq 3 ]; then
      echo "Device Found"
      echo "Device ID: "`adb devices | grep -w "device" | awk '{print $1;}'`
      echo "Device Model: "`adb shell getprop | grep "ro.product.model" | sed 's/^.*: //'`
      echo "Device Carrier: " `adb shell getprop | grep "nfc.fw.dfl_areacode" | sed 's/^.*: //'`
      break
   elif [ $? -gt 3 ]; then
      echo "Multiple Devices Detected. Please disconnect one"
   else
      echo "No Devices Found. Please ensure that your device is connected."

   fi
   sleep 5s
done

adb shell "settings put secure sysui_qs_tiles \"$tiles\""

echo "Completed. Exiting..."
