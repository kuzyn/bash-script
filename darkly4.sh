#! /bin/bash
# 
# "Darkly" - v0.9 - 2010-09-11
# Script de capture/timelapse pour webcam
# samcousin at gmail com
#
# Requiert ffmpeg, streamer et imagemagik.
#
# Utiliser avec crontab et "kickstart.sh" : l'utilisation d'un petit script de démarrage 
# est necessaire avec cron (???) De plus, ce petit script s'assure que streamer est bien fermé avant de lancer "darkly".
# Dans sa configuration actuelle, crontab lance le script "kickstart.sh" à toute les minutes entre 9-17h.
#
# Scripts de référence par danpaluska (http://gist.github.com/danpaluska)
# 

##########
#Variables
VID=/home/motherfucker/darkly		#répertoire où sera déposé le video
SEC=9					#nombre de secondes (+ ~3) entre les clichés
WDIR=/tmp				#working directory
HGENERATE=175940			#heure à laquelle on veut arrêter et générer le video (format hhmmss)

DATE=`date +%d-%m-%Y`			#date pour les noms de fichiers
COMPTEUR=0				#compteur pour les noms de photos
FRAME=0					#compteur pour le nombre de photos prisent (arrête à 5 : voir ligne 82)
STREAMER=`ps -e|awk '{ print $1 " "$4 }'|grep streamer |awk '{ print $1 }'`	#trouve le PID de "streamer"
##########
#Fonctions
#

# Créé les répertoires de travail
function	repertoire()

		{
cd $WDIR
if [ -d darkly${DATE} ]; then
						# Si le directory "dd-mm-yyyy" existe, alors...
		cd darkly${DATE}
		let COMPTEUR=(`ls|tr -d "dark_*.jpg"|sort -g|tail -n1`) 	#ligne pour résumer la capture
		let COMPTEUR+=1 					#Pour ne pas "overwritter" la dernière capture
else					
		rm -rf dark*			#On commence par faire le ménage de la veille...		
		mkdir darkly${DATE}
		mkdir ${VID}		
		cd darkly${DATE}
fi	
		}


# Fonction de capture : streamer prend un cliché, imagik (convert) le converti et l'aggrandit puis les jpegs sont effacés.
# Les noms finaux des jpgs viennent du compteur car ffmpeg à besoin de nom sequantiels pour généré le video
function	capture()		
				
		{	
			cd $WDIR/darkly${DATE}
			streamer -t4 -r1 -o darklyRAW0.jpeg
			convert darklyRAW3.jpeg -resize 400% dark_${COMPTEUR}.jpg
			rm -f *.jpeg
			let COMPTEUR+=1		
		}

#Génère le fichier video mp4 avec ffmpeg (10fps, même grandeur, input = tri dans l'ordre les jpg).
function	generate()	

		{
		until [ -f ${VID}/$DATE.mp4 ]; do	# tant que le fichier $DATE.mp4 n'existe pas fait 
			cd $WDIR/darkly${DATE}			
			ffmpeg -r 10 -sameq -i dark_%d.jpg ${VID}/${DATE}.mp4
		done		
		}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
########
# Script
#
# Le script commence ici et rappelle les fonctions
repertoire			#Création du repertoire de la journée, s'il n'existe pas

while [ "${FRAME}" -lt "5" ];	#Tant qu'il y a moins de "5" cliché de pris
	do
		capture   &>> /dev/null #dump (&>> = stdin+stdout append)			
		echo "Capture ${COMPTEUR} -- `date +%H%M%S`" &>> ${WDIR}/dark.log	
		kill -9 ${STREAMER} &>> /dev/null #force streamer à se fermer
		sleep ${SEC}		#Nombre de secondes avant une autre capture
		let FRAME+=1
	done

# Quand "%H" = ${HGENERATE} , on passe à la génération vidéo
if [ "`date +%H%M%S`" >=  "${HGENERATE}" ]; then
	generate 
	echo "Vidéo du ${DATE} généré dans ${VID}" &>> ${WDIR}/dark.log
	sleep 10
fi
exit 0
