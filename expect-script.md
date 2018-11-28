## expect script 

#!/usr/bin/expect
set username "escomm"
set password "P@ssw0rd_escnoc"
set hosts "172.16.10.102"
spawn ssh -p 7489 -o StrictHostKeyChecking=no $username@$hosts
expect "$username@$hosts's password:"
send -- "$password\n"
expect "$"
send -- "sudo rm -rf /var/lib/puppet/ssl && sudo puppet agent --test \n"
expect "$"
send -- "$password\n"
expect "$"
send -- "exit\n"