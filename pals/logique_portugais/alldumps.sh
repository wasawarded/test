#!/bin/bash

# Chemin vers le dossier contenant les dumps
DUMPS_FOLDER="/home/ines/PPE_website_marche_sur_la_lune/dumps-text/logique_portugais"

# Fichier de sortie unique
OUTPUT_FILE="all_dumps.txt"

# Fusionner tous les fichiers texte dans un seul fichier
cat "$DUMPS_FOLDER"/*.txt > "$OUTPUT_FILE"

echo "Tous les dumps ont été fusionnés dans $OUTPUT_FILE"

