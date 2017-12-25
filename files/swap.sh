#!/bin/bash

set -e

### SETUP SWAP ###
# Add 2G swap
dd if=/dev/zero of=/swapfile bs=256M count=8
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile   none    swap    sw    0   0" >> /etc/fstab
sync; echo 1 > /proc/sys/vm/drop_caches
