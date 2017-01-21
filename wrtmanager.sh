#!/bin/bash

# zmienne
ipki='lista.txt'
ssidfile=`ssidfile 2>/dev/null` || ssidfile=/tmp/tempssid$$
passfile=`passfile 2>/dev/null` || passfile=/tmp/temppass$$
rootfile=`rootfile 2>/dev/null` || rootfile=/tmp/temproot$$
currfile=`currfile 2>/dev/null` || currfile=/tmp/tempcurr$$

# trapy do sprzątania po przerwaniu wywołania
trap "rm -f $ssidfile" 0 1 2 5 15
trap "rm -f $passfile" 0 1 2 5 15
trap "rm -f $rootfile" 0 1 2 5 15
trap "rm -f $currfile" 0 1 2 5 15

#hasło do urządzeń
dialog      --title "Enter current root Password" \
            --backtitle "WRTManager" \
            --passwordbox "Enter root password" 8 40 2> $currfile
clear

curr=`cat $currfile`
rm -f $currfile #sprzątamy od razu po przepisaniu zmiennej


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
	    dialog      --title "Change SSID" \
			--backtitle "WRTManager" \
			--inputbox "Enter new SSID" 8 40 2> $ssidfile
	    ssid=`cat $ssidfile` #zawartość pliku do zmiennej
	    rm -f $ssidfile # sprzątamy plik przed wywołaniem skryptu
		#dla każdej lini w pliku $ipki wywołujemy skrypt ze zmiennymi $ip oraz $curr do zmiennej ip wpisujemy zawartość kolejnych niepustych linii
	    while read ip; do
			./ssid.sh $ip $curr $ssid
	    done < $ipki
            ;;
#zmiana hasła WiFi
        2)
	     dialog      --title "WiFi password change" \
                        --backtitle "WRTManager" \
                        --inputbox "Enter SSID which password You can change" 8 40 2> $ssidfile
             ssid=`cat $ssidfile` #zawartość pliku do zmiennej
             rm -f $ssidfile # sprzątamy plik przed wywołaniem skryptu
             dialog      --title "Change WiFi Password" \
                        --backtitle "WRTManager" \
                        --passwordbox "Enter new password" 8 40 2> $passfile #passwordbox pozwala przechwycić znaki wpisywane z klawiatury bez wyświetlania ich na ekranie
             pass=`cat $passfile`
             rm -f $passfile
             while read ip; do
                        ./psk.sh $ip $curr $ssid $pass
             done < $ipki

            ;;
#zmiana hasła roota
        3)
            dialog      --title "Change root Password" \
                        --backtitle "WRTManager" \
                        --passwordbox "Enter new root password" 8 40 2> $rootfile
            root=`cat $rootfile`
	    rm -f $rootfile
            while read ip; do
                        ./test.sh $ip $curr $root
            done < $ipki
	    ;;
esac

clear
