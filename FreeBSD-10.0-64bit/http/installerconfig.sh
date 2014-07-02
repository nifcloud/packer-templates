PARTITIONS=da0
DISTRIBUTIONS="base.txz kernel.txz games.txz lib32.txz"

#!/bin/sh
cat >> /etc/rc.conf <<EOF
keymap="jp.106.kbd"
ifconfig_vmx0="DHCP"
ifconfig_vmx1="DHCP"
sshd_enable="YES"
# Set dumpdev to "AUTO" to enable crash dumps, "NO" to disable
dumpdev="AUTO"
EOF

# SSH config
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
echo "PermitRootLogin without-password" >> /etc/ssh/sshd_config
echo "UseDNS no" >> /etc/ssh/sshd_config

/bin/mkdir -m 700 /root/.ssh
/bin/cat >> /root/.ssh/authorized_keys << PUBLIC_KEY
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDUexi38qspDGWiM6EhTdEUdMUYpgnBQFnf05+rbGf4d8Zs6X23Xnxyjg0EhsG23ICzDHdHrZkz13ZEQW4gF0EamfRBHevIY3WYhHy+UQqxPn3PHDue99SQCepqz2UnhnoFxUNZ6wiL176YIV/PUqxNyaX7ZLIDNb0ujNSqMQarh6lMV0q5OL+JO3kLO0EJr8jprGZuBsq1c27GiuV/fmL+1/cxVeQZdRXhkkYB5eJOC5hMHuPqLmLHbqp5juIEenNOwMMZScdH7Rf6KIGtzEDGX4VisBEz1tshfC32wYYSMCK96ExpB9tS6PXQUKUQ52qmlYTb4KcLJ5M5YMAmYvX9 niftycloud
PUBLIC_KEY
/bin/chmod 600 /root/.ssh/authorized_keys

chsh -s sh
