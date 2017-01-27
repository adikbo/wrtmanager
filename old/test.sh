#!/usr/bin/expect -f

log_user 1
set timeout 50


set IPaddress [lindex $argv 0]
set PASSWORD [lindex $argv 1]
set new_pass [lindex $argv 2]

spawn ssh root@$IPaddress

expect "assword: "

send $PASSWORD\n

expect "#"

send "passwd\n"
expect "assword:"
sleep 1
send $new_pass\n
expect "assword:"
sleep 1
send $new_pass\n

sleep 10
expect "#"

send "exit\r"

log_user 1

expect eof
