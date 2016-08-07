#!/bin/bash
#
#kickstart
cd /home/motherfucker/Bureau
kill -9 `ps -e|awk '{ print $1 " "$4 }'|grep streamer |awk '{ print $1 }'`
sleep 1
./darkly2.sh
exit 0
