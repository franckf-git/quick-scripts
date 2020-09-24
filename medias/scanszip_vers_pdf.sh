#! /bin/sh
# dependances : ImageMagick et prename
dossier=$1
cd $dossier
nomdossier=$(echo $dossier | cut -d"/" -f1)

# renommage
renommage (){
    for zip in $(ls)
    do
        mv $zip $(echo $zip | iconv --from-code=UTF-8 --to-code=ASCII//TRANSLIT)
    done

    prename 'y/A-Z\ /a-z-/' *
    prename 's/\[//g' *
    prename 's/[^a-z0-9-.]/-/g' *
}

renommage

mkdir faits

# dezipper tous les fichiers
for zip in $(ls | egrep '*.zip')
do
    mv $zip faits/
    cd faits/
    # todo verifier si cest un dossier
    unzip $zip
    nom=$(basename $zip .zip)
    mv $zip ../../
    renommage

    for image in $(ls)
    do
        mv $image ../"$nom"_"$image"
    done

    cd ../
done

convert *.* "$nomdossier".pdf
mv "$nomdossier".pdf ../
cd ../
rm -Rf $dossier
