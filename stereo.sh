#! /bin/bash
#
# ftp function reference : 
#http://blogbysud.blogspot.com/2006/11/following-code-snippet-can-be-embedded.html

### rough capture function
mkdir /tmp/stereo
cd /tmp/stereo

streamer -c /dev/video1 -t6 -o outa0.jpeg && streamer -c /dev/video2 -t6 -o outb0.jpeg
convert -delay 20 outa[0-5].jpeg -delay 10 outb[0-5].jpeg mov.gif
rm *.jpeg


### rough ftp function 
function ftpfile {
# failure or success flag
#
FLAG=0 # assume success
# Start the actual ftp of the file
RETUR=$(ftp -n <>${LOGFILE}
open $SERVER
user $USERNAME $PASSWORD
ascii
put file.txt
bye
EOF
)

# End of the actual ftp process
if [ "$RETUR" != "" ]
then
FLAG=1
fi
return $FLAG
#
}
# END FTP FUNCTION
# call function to ftp file
ftpfile $file
FLAG=$?
if [ "$FLAG" -eq "0" ]
then
echo "------> File transfer completed"
else
echo "------x File transfer failed"
fi 
