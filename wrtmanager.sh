#!/bin/bash

# zmienne
ipki='lista.txt'

#hasło do urządzeń
curr=$(dialog        --title "Enter current root Password" \
	             --backtitle "WRTManager" \
                     --passwordbox "Enter root password" \
		     8 40 2>&1 > /dev/tty)
clear

# Główne menu programu
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
                                    --inputbox "Enter SSID which password You can change" \
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

clear
