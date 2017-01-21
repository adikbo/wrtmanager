#!/bin/bash

ipki='lista.txt'

ssidfile=`ssidfile 2>/dev/null` || ssidfile=/tmp/tempssid$$
passfile=`passfile 2>/dev/null` || passfile=/tmp/temppass$$
rootfile=`rootfile 2>/dev/null` || rootfile=/tmp/temproot$$
currfile=`currfile 2>/dev/null` || currfile=/tmp/tempcurr$$

trap "rm -f $ssidfile" 0 1 2 5 15
trap "rm -f $passfile" 0 1 2 5 15
trap "rm -f $rootfile" 0 1 2 5 15
trap "rm -f $currfile" 0 1 2 5 15

dialog      --title "Enter current root Password" \
            --backtitle "WRTManager" \
            --passwordbox "Enter root password" 8 40 2> $currfile
clear


HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=4
BACKTITLE="WRTManager"
TITLE="Menu"
MENU="Choose one of the following tasks:"

OPTIONS=(1 "Change SSID"
         2 "Change WiFi Password"
         3 "Change root Passowrd")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
	    dialog      --title "Change SSID" \
			--backtitle "WRTManager" \
			--inputbox "Enter new SSID" 8 40 2> $ssidfile
		curr=`cat $currfile`
	    	ssid=`cat $ssidfile`
		while read ip; do
			./test.sh $ip $curr
		done < $ipki
            ;;
        2)
            dialog      --title "Change WiFi Password" \
                        --backtitle "WRTManager" \
                        --passwordbox "Enter new password" 8 40 2> $passfile

            ;;
        3)
            dialog      --title "Change root Password" \
                        --backtitle "WRTManager" \
                        --passwordbox "Enter new root password" 8 40 2> $rootfile
	    ;;
esac

clear

#cat $tempfile
#cat $passfile
rm -f $ssidfile
rm -f $passfile
rm -f $rootfile
rm -f $currfile
