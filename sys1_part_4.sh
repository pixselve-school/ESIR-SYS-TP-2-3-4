#!/bin/bash

# Chemin vers le répertoire de travail temporaire
TEMP_FOLDER="./tempImages"

# @Param 1: fichier à traiter
function fileToPDF() {
  local filePath=$1
  local fileName=$(basename "$filePath")

  if [ ! -f "$filePath" ]; then
    echo "Le fichier n'existe pas"
    exit
  fi

  echo Traitment du fichier: "$filePath"

  smallestDimension=$(identify -format "%[fx:min(w,h)]" "$filePath")
  echo Dimension la plus petite: "$smallestDimension"

  fileNameSquare=${fileName%.jpg}"_square.jpg"
  echo Nom du fichier carré: "$fileNameSquare"

  if [ -f "$fileNameSquare" ]; then
    echo "Le fichier intermédiaire existe déjà"
    exit
  fi

  fileNamePDF=${fileName%.jpg}".pdf"
  echo Nom du PDF: "$fileNamePDF"

  if [ -f "$fileNamePDF" ]; then
    echo "Le fichier pdf existe déjà"
    exit
  fi

  # Rognage de l'image
  convert -gravity center -crop "$smallestDimension"x"$smallestDimension"+0+0! "$filePath" "$TEMP_FOLDER"/"$fileNameSquare"
  # Création du PDF à partir de l'image
  img2pdf --output "$TEMP_FOLDER"/"$fileNamePDF" --pagesize 10cmx10cm "$TEMP_FOLDER"/"$fileNameSquare"
}

if [ "$#" -lt 1 ]; then
  echo "Pas d'image spécifiée"
  exit
fi

if [ -f ./result.pdf ]; then
  echo "Un PDF résultat existe déjà"
  exit
fi


#Création du répertoire de travail
if [ -d $TEMP_FOLDER ]; then
  echo "Le répertoire de travail existe déjà"
  exit
fi
mkdir "$TEMP_FOLDER"


#Traitement des images passées en argument
for filePath in "$@"; do
  fileToPDF "$filePath"
done

#Création du PDF final
pdfunite $TEMP_FOLDER/*.pdf ./result.pdf

#Desctruction du répertoire de travail
rm -Rf $TEMP_FOLDER
