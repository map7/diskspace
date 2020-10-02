#!/bin/sh
#
#

echo "--------------------------------------------------------------------------------"
echo "Install diskspace"
echo "--------------------------------------------------------------------------------"
echo
echo "Just run this once, hit Ctrl+c now if you've already ran this"
read

cp diskspace.sh /usr/local/sbin
cp config.sh.sample /etc/diskspace_config.sh
echo '*/5 * * * * root /usr/local/sbin/diskspace.sh' >> /etc/crontab
