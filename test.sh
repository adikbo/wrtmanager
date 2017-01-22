#!/usr/bin/expect -f

set timeout 50


set IPaddress [lindex $argv 0]
set PASSWORD [lindex $argv 1]

spawn ssh root@$IPaddress


expect "password: "

send $PASSWORD\n

expect "# "

send "uname -a\r"

expect "# "

send "exit\r"

expect eof
