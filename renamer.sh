
#simple " batch renamer" : file_10001, file_10002,... 
counter=10000
for f in *.jpg; do #ici, tout les fichiers jpg
let "counter+=1"
mv $f file_${counter:1}.jpg
done
