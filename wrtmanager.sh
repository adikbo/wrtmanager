#!/bin/bash

# zmienne
ipki='lista.txt'
log='script.log'

#hasło do urządzeń
curr=$(dialog        --title "Enter current root Password" \
	             --backtitle "WRTManager" \
                     --passwordbox "Enter root password" \
		     8 40 2>&1 > /dev/tty)
clear

#edycja listy urządzeń
temp="/tmp/lista.tmp"
lista="lista.txt"
dialog			--editbox "$lista" 40 125 2> "$temp"
rm $lista
mv $temp $lista
rm $log

clear
count_dev=$(cat $ipki | wc -l)

# Główne menu programu

OPTIONS=(1 "Change SSID"
         2 "Change WiFi Password"
         3 "Change root Passowrd")

CHOICE=$(dialog --clear \
                --backtitle "WRTManager" \
                --title "MENU" \
                --menu "Choose one of the tasks:" \
                15 40 4 \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear

#Główna pętla programu
case $CHOICE in
#zmiana SSID
        1)
	    ssid=$(dialog       --title "Change SSID" \
		                --backtitle "WRTManager" \
			        --inputbox "Enter new SSID" \
                    		8 40 2>&1 > /dev/tty)
	    while read ip; do
			./ssid.sh $ip $curr $ssid
	    done < $ipki
            ;;
#zmiana hasła WiFi
        2)
	     ssid=$(dialog          --title "WiFi password change" \
                                    --backtitle "WRTManager" \
                                    --inputbox "Enter SSID which password You want to be changed" \
                    		    8 40 2>&1 > /dev/tty)
             pass=$(dialog          --title "Change WiFi Password" \
                                    --backtitle "WRTManager" \
                                    --passwordbox "Enter new password" \
                                    8 40 2>&1 > /dev/tty)
             while read ip; do
                        ./psk.sh $ip $curr $ssid $pass
             done < $ipki

            ;;
#zmiana hasła roota
        3)
            root=$(dialog           --title "Change root Password" \
                                    --backtitle "WRTManager" \
                                    --passwordbox "Enter new root password" \
                    		    8 40 2>&1 > /dev/tty)

            while read ip; do
                        ./root.sh $ip $curr $root
            done < $ipki
	    ;;
esac
count_suc=$(cat $log | wc -l)
clear

dialog 					--title "Summary" \
					--backtitle "WRTManager" \
					--msgbox "Successfully delivered commands to $count_suc of $count_dev devices" \
					8 40 2>&1

clear
rm $log
