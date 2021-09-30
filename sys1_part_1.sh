#!/bin/bash

file=$1

echo Traitment du fichier: "$file"
smallestDimension=$(identify -format "%[fx:min(w,h)]" "$file")
echo Dimension la plus petite: "$smallestDimension"

fileNameSquare=${file%.jpg}"_square.jpg"
echo Nom du fichier carré: "$fileNameSquare"

fileNameSquare=${file%.jpg}"_square.jpg"
echo "$fileNameSquare"

fileNamePDF=${file%.jpg}".pdf"
echo Nom du PDF: "$fileNamePDF"

# Rognage de l'image
convert -gravity center -crop "$smallestDimension"x"$smallestDimension"+0+0! "$file" "$fileNameSquare"
# Création du PDF à partir de l'image
img2pdf --output "$fileNamePDF" --pagesize 10cmx10cm "$fileNameSquare"
