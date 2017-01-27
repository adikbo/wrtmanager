#!/usr/bin/expect -f

log_file script.log
log_user 0
set timeout 50


set IPaddress [lindex $argv 0]
set PASSWORD [lindex $argv 1]
set SSID [lindex $argv 2]

spawn ssh root@$IPaddress

expect "assword: "

send $PASSWORD\n

expect "#"

send "uci set wireless.@wifi-iface\[0].ssid='$SSID'\r"

expect "#"

send "uci commit\r"

sleep 10

expect "#"

send "exit\r"

send_log "$IPaddress done succesfully\r"

expect eof

