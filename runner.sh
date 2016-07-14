#!/bin/bash

echo "running builder"
echo "==============="
sh blocklistbuilder.sh
echo "==============="

echo "copying over file"
cp ./adblock.conf /etc/dnsmasq.d/

echo "restarting dnsmasq"
service dnsmasq restart

echo "done!"
