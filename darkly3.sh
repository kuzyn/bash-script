#! /bin/bash
# 
# "Darkly" - v0.8 - 2010-08-04
# Script de capture webcam
# jcdenton
#
# Pour une rotation continue, placé dans le crontab. Le script s'arrête automatiquement à 18h.
#
# Scripts de référence par danpaluska (http://gist.github.com/danpaluska)
# 

##########
#Variables
DATE=`date +%d-%m-%Y`			#date (pour les noms de fichiers)
COMPTEUR="1"				#compteur (pour les noms de photos)

########
# Script

cd /tmp
rm -rf darkly*
#clear
#echo "************"

#Création du repertoire de la journée
#echo "Nouvelle journée, nouveau répertoire"
mkdir darkly${DATE}
cd darkly${DATE}
#echo "************"

#capture des images
while [ `date +%H` -lt 20 ];	#Tant que "%H" < 18, fait...
	do
		streamer -d -w1 -p2 -r1 -t4 -c /dev/video0 -s 320x240 -b4 -o darklyRAW0.jpeg &>> /tmp/darklyCAP.log
		rm -f *RAW0* *RAW1* *RAW2*
		sleep 1 
		convert 'darklyRAW3.jpeg[200%]' ${COMPTEUR}.jpg && rm 'darklyRAW3.jpeg'
#		echo -n "Capture #${COMPTEUR} ("`date +%T`") || "
		let COMPTEUR+=1 
		sleep 5
	done

#quand "%H" > 18, on passe à la génération vidéo
echo "Trop tard pour continuer à capturer"
echo "Tentative de génération de la video du ${DATE}"
echo "Les images deviennent un vidéo..."
ffmpeg -r 10 -sameq -i %d.jpg ~/${DATE}.mp4 &>> /dev/null
echo "************"
echo "Vidéo du ${DATE} généré dans répertoire /home/fatherfucker/Darkly/ "
echo "************"
sleep 3
echo "Bonne nuit"
echo
sleep 10
exit 0
