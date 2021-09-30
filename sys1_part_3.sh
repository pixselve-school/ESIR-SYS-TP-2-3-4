#!/bin/bash

function fileToPDF() {
  local file=$1

  if [ ! -f "$file" ]; then
    echo "Le fichier n'existe pas"
    exit
  fi
  echo Traitment du fichier: "$file"
  smallestDimension=$(identify -format "%[fx:min(w,h)]" "$file")
  echo Dimension la plus petite: "$smallestDimension"

  fileNameSquare=${file%.jpg}"_square.jpg"
  echo Nom du fichier carré: "$fileNameSquare"

  if [ -f "$fileNameSquare" ]; then
    echo "Le fichier intermédiaire existe déjà"
    exit
  fi

  fileNamePDF=${file%.jpg}".pdf"
  echo Nom du PDF: "$fileNamePDF"

  if [ -f "$fileNamePDF" ]; then
    echo "Le fichier pdf existe déjà"
    exit
  fi
  # Rognage de l'image
  convert -gravity center -crop "$smallestDimension"x"$smallestDimension"+0+0! "$file" "$fileNameSquare"
  # Création du PDF à partir de l'image
  img2pdf --output "$fileNamePDF" --pagesize 10cmx10cm "$fileNameSquare"
}

if [ "$#" -lt 1 ]; then
  echo "Pas d'image spécifiée"
  exit
fi

for var in "$@"; do
  fileToPDF "$var"
done
