#!/bin/bash

destinationIP="127.0.0.1"

outlist='./adblock.conf'
tempoutlist="$outlist.tmp"

echo "Getting yoyo ad list..." 
curl -s -d mimetype=plaintext -d hostformat=unixhosts http://pgl.yoyo.org/adservers/serverlist.php? | sort > $tempoutlist

echo "Getting winhelp2002 ad list..." 
curl -s http://winhelp2002.mvps.org/hosts.txt | grep -v "#" | grep -v "127.0.0.1" | sed '/^$/d' | sed 's/\ /\\ /g' | awk '{print $2}' | sort >> $tempoutlist

echo "Getting adaway ad list..." 
curl -s https://adaway.org/hosts.txt | grep -v "#" | grep -v "::1" | sed '/^$/d' | sed 's/\ /\\ /g' | awk '{print $2}' | grep -v '^\\' | grep -v '\\$' | sort >> $tempoutlist

echo "Getting hosts-file ad list..." 
curl -s http://hosts-file.net/.%5Cad_servers.txt | grep -v "#" | grep -v "::1" | sed '/^$/d' | sed 's/\ /\\ /g' | awk '{print $2}' | grep -v '^\\' | grep -v '\\$' | sort >> $tempoutlist

echo "Getting malwaredomainlist ad list..." 
curl -s http://www.malwaredomainlist.com/hostslist/hosts.txt | grep -v "#" | sed '/^$/d' | sed 's/\ /\\ /g' | awk '{print $3}' | grep -v '^\\' | grep -v '\\$' | sort >> $tempoutlist

echo "Getting adblock.gjtech ad list..." 
curl -s http://adblock.gjtech.net/?format=unix-hosts | grep -v "#" | sed '/^$/d' | sed 's/\ /\\ /g' | awk '{print $2}' | grep -v '^\\' | grep -v '\\$' | sort >> $tempoutlist

echo "Getting someone who cares ad list..." 
curl -s http://someonewhocares.org/hosts/hosts | grep -v "#" | sed '/^$/d' | sed 's/\ /\\ /g' | grep -v '^\\' | grep -v '\\$' | awk '{print $2}' | grep -v '^\\' | grep -v '\\$' | sort >> $tempoutlist

echo "Getting Mother of All Ad Blocks list..." 
curl -A 'Mozilla/5.0 (X11; Linux x86_64; rv:30.0) Gecko/20100101 Firefox/30.0' -e http://forum.xda-developers.com/ http://adblock.mahakala.is/ | grep -v "#" | awk '{print $2}' | sort >> $tempoutlist

echo "Getting custom block list"
curl -s https://raw.githubusercontent.com/MartinIngesen/blocklistbuilder/master/customblocklist.txt | sort >> $tempoutlist

echo "writing adblock file"
cat $tempoutlist | grep -v "ikea.com" | sed $'s/\r$//' | sort -u | sed '/^$/d' | awk -v "IP=$destinationIP" '{sub(/\r$/,""); print "address=/"$0"/"IP}' > $outlist


