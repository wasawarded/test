#!/bin/bash

# Variables pour les chemins relatifs
BASE_DIR=".."  # Chemin relatif vers la racine du projet
AR_CONTEXT_DIR="$BASE_DIR/contextes/ar_contexte/context_txt"
FR_CONTEXT_DIR="$BASE_DIR/contextes/fr_contexte/context_txt"
AR_DUMPS_DIR="$BASE_DIR/dumps-text/logique_arabe"
FR_DUMPS_DIR="$BASE_DIR/dumps-text/logique_français"
PALS_DIR="$BASE_DIR/pals/dumps-text"

# Arguments pour le script
input_folder=$1       # Dossier contenant les fichiers à traiter
base_name=$2          # Nom de base pour les fichiers de sortie

# Création du dossier de sortie
mkdir -p "$PALS_DIR"

# Fonction de traitement des fichiers
process_file() {
    input_file=$1
    output_file=$2

    # Tokenisation : un mot par ligne, maintien des lignes vides entre phrases
    awk '{
        for (i=1; i<=NF; i++) {
            print $i
        }
        print ""  # Ajout d'une ligne vide entre chaque ligne d'entrée
    }' "$input_file" | sed '/^$/N;/^\n$/D' > "$output_file"
}

# Vérification et assignation du bon dossier d'entrée
if [[ $input_folder == "ar_dumps" ]]; then
    input_folder=$AR_DUMPS_DIR
elif [[ $input_folder == "fr_dumps" ]]; then
    input_folder=$FR_DUMPS_DIR
elif [[ $input_folder == "ar_context" ]]; then
    input_folder=$AR_CONTEXT_DIR
elif [[ $input_folder == "fr_context" ]]; then
    input_folder=$FR_CONTEXT_DIR
else
    echo "Dossier non reconnu. Veuillez utiliser : ar_dumps, fr_dumps, ar_context ou fr_context."
    exit 1
fi

# Vérifier si le dossier d'entrée contient des fichiers
if [[ ! -d $input_folder ]]; then
    echo "Erreur : Le dossier $input_folder n'existe pas."
    exit 1
fi

if [[ -z $(ls "$input_folder"/*.txt 2>/dev/null) ]]; then
    echo "Erreur : Aucun fichier .txt trouvé dans $input_folder."
    exit 1
fi

# Boucle pour traiter les fichiers dans le dossier donné
for file in "$input_folder"/*.txt; do
    filename=$(basename "$file" .txt)  # Nom du fichier sans extension
    output_file="$PALS_DIR/${base_name}-${filename}.txt"
    process_file "$file" "$output_file"
done

echo "Traitement terminé. Les fichiers PALS sont générés dans $PALS_DIR."
