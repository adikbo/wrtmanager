#!/usr/bin/expect -f

<<<<<<< HEAD


set ipki [open lista.txt r]

stty -echo
send_user -- "Please enter the password for the root user of the devices: "
expect_user -re "(.*)\n"
send_user "\n"
stty echo
set pass $expect_out(1,string)


while {[gets $ipki ip] != -1} {

spawn ssh root@$ip
=======
spawn ssh root@192.168.1.1
>>>>>>> parent of 970ca6f... hasło podawane na początku jako zmienna pass

expect "password: "

send "ad10bxcv3\r"

expect "# "

send "uname -a\r"

expect "# "

send "exit\r"

expect eof

}

close $ipki

