#!/usr/bin/expect -f

set ROOT_PASSWD [lindex $argv 0];

set timeout 10
spawn mysql_secure_installation

expect "Press y|Y for Yes, any other key for No: "
send -- "y"
expect "Please enter 0 = LOW, 1 = MEDIUM and 2 = STRONG: "
send -- "2"
expect "New password: "
send -- "$ROOT_PASSWD"
expect "Re-enter new password: "
send -- "$ROOT_PASSWD"
expect "Do you wish to continue with the password provided?(Press y|Y for Yes, any other key for No) : "
send -- "y"
expect "Remove anonymous users? (Press y|Y for Yes, any other key for No) : "
send -- "y"
expect "Disallow root login remotely? (Press y|Y for Yes, any other key for No) : "
send -- "y"
expect "Remove test database and access to it? (Press y|Y for Yes, any other key for No) : "
send -- "y"
expect "Reload privilege tables now? (Press y|Y for Yes, any other key for No) : "
send -- "y"

