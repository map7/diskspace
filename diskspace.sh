#!/bin/sh
#
# /usr/local/sbin/diskspace.sh
#
# check if any filesystems are reaching full
# ignore filesystems like  tmpfs  devfs and cdrom
# only consider the local file systems (not mount points)  hence df -l  option
# check each filesysetm in excess of XX%    (ie:  -ge 90)
# store the results into and ongoing /var/log/fs_report.log
# email IT contact when any fielsystem exceeds that DISKSPACE_THRESHOLD.
#
# run this as a crontab job each night.
# Pre-requisites:   #touch /var/log/fs_report.log
#                   mail application
#

# Variables refer to config.sh.sample
. /etc/diskspace_config.sh

echo "$DISKSPACE_RECIPIENT"

## special exception for /dev/sda4 which MYTHTV runs to 99% all the time to keep all possible tv shows
## -h  is in multiples of 1024   (-H is in multiples of 1000) 
df -lh | grep -vE "^Filesystem|tmpfs|devfs|cdrom|$DISKSPACE_DEVICE_EXCEPTION" | awk '{ print $5 " " $1 }' | while read output;
do
echo $output
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  partition=$(echo $output | awk '{ print $2 }' )
  if [ $usep -ge $DISKSPACE_THRESHOLD ]; then
      msg="Running out of space \"$partition ($usep%)\" on $(hostname) as on $(date)"
      
       echo $msg
       echo $msg >> /var/log/fs_report.log
       echo $msg |
       mail -s "$(hostname) Alert: Almost out of disk space. $partition Used: $usep% (detected by /usr/local/bin/diskspace.sh) DISKSPACE_THRESHOLD: $DISKSPACE_THRESHOLD %" "$DISKSPACE_RECIPIENT"
  fi
done
