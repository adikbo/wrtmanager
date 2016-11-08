#!/usr/bin/expect -f


stty --echo
send_user -- "Please enter the password for the root: "
expect_user -re "(.*)\n"
send_user "\n"
stty echo
set pass $expect_out(1,string)


while {[gets $ipki ip] != -1} {

spawn ssh root@$ip

expect "password: "

expect "# "

send "uname -a\r"

expect "# "

send "exit\r"

expect eof

}

close $ipki

