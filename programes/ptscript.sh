
#!/bin/bash

# Fichiers et dossiers
INPUT_FILE="/home/ines/PPE_website_marche_sur_la_lune/URLs/pt_url/pt_url.txt"
OUTPUT_HTML="pt_tableux.html"
CONTEXT_DIR="/home/ines/PPE_website_marche_sur_la_lune/contextes/pt_contexte"
CONCORDANCE_DIR="/home/ines/PPE_website_marche_sur_la_lune/tableaux/concordances/pt_concordances"
ASPIRATION_DIR="/home/ines/PPE_website_marche_sur_la_lune/aspirations/port_html"
DUMP_DIR="/home/ines/PPE_website_marche_sur_la_lune/dumps-text/logique_portugais"
WORD="lógica|lógico|lógicas|lógicos"

# Créer les dossiers nécessaires
mkdir -p "$CONTEXT_DIR" "$CONCORDANCE_DIR" "$ASPIRATION_DIR" "$DUMP_DIR"

# Fonction pour extraire le contexte
function extract_context() {
    local content="$1"
    local word="$2"
    echo "$content" | grep -i -o -P ".{0,50}\b($word)\b.{0,50}" | head -n 5
}

function extract_concordance() {
    local content="$1"
    local word="$2"
    echo "$content" | grep -o -P "(?:(?:\S+\s+){0,3})\b($word)\b(?:\s+\S+){0,3}" | sed -E 's/(.*\b)\b('$word')\b(\b.*)/\1\t\2\t\3/' | awk -F'\t' '{print $1 "\t" $2 "\t" $3}' | head -n 10
}


# Début du tableau HTML
echo "<!DOCTYPE html>
<html lang=\"fr\">
<head>
    <meta charset=\"UTF-8\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
    <title>Résultats du traitement</title>
    <style>
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: center; }
        th { background-color: #f8f9fa; }
        tr:nth-child(even) { background-color: #f9f9f9; }
        a { color: #007BFF; text-decoration: none; }
    </style>
</head>
<body>
    <h1>Résultats du traitement des dumps pour le mot logique en portugais</h1>
    <table>
        <thead>
            <tr>
                <th>Numéro</th>
                <th>URL</th>
                <th>Code HTTP</th>
                <th>Encodage HTML</th>
                <th>Nombre de Tokens</th>
                <th>Compte</th>
                <th>Contexte</th>
                <th>Concordance</th>
                <th>Aspiration</th>
                <th>Dump Textuel</th>
            </tr>
        </thead>
        <tbody>" > "$OUTPUT_HTML"

# Initialisation du compteur
COUNTER=1

# Lire chaque URL
while IFS= read -r url; do
    if [[ -z "$url" ]]; then
        continue
    fi

    # Récupérer le contenu avec curl
    RESPONSE=$(curl -s -I "$url" | head -n 1)
    HTTP_CODE=$(echo "$RESPONSE" | awk '{print $2}')

    # Si le code HTTP est une erreur, ignorer la page
    if [[ "$HTTP_CODE" -ge 400 ]]; then
        echo "Page avec erreur HTTP ($HTTP_CODE) : $url. Ne sera pas traitée." >&2
        echo "        <tr>
            <td>$COUNTER</td>
            <td><a href=\"$url\" target=\"_blank\">$url</a></td>
            <td>$HTTP_CODE</td>
            <td colspan=\"6\">Erreur HTTP $HTTP_CODE</td>
        </tr>" >> "$OUTPUT_HTML"
        COUNTER=$((COUNTER + 1))
        continue
    fi

    CONTENT=$(curl -s "$url")
    ENCODING=$(echo "$CONTENT" | file -bi - | sed -n 's/.*charset=//p')

    # Sauvegarder la page HTML dans le dossier des aspirations
    ASPIRATION_FILE="$ASPIRATION_DIR/aspiration_$COUNTER.html"
    echo "$CONTENT" > "$ASPIRATION_FILE"

    # Convertir la page en texte avec Lynx et sauvegarder dans le dossier des dumps textuels
    DUMP_TEXT=$(echo "$CONTENT" | lynx -stdin -dump)
    DUMP_FILE="$DUMP_DIR/dump_$COUNTER.txt"
    echo "$DUMP_TEXT" > "$DUMP_FILE"

    # Compter les tokens dans le dump textuel
    TOKENS=$(echo "$DUMP_TEXT" | wc -w)

    # Compter les occurrences du mot
    COMPTE=$(echo "$DUMP_TEXT" | grep -oiP "\b($WORD)\b" | wc -l)

    # Extraire le contexte
    CONTEXT=$(extract_context "$DUMP_TEXT" "$WORD")

    # Sauvegarder le contexte dans un fichier HTML
    CONTEXT_HTML="$CONTEXT_DIR/context_$COUNTER.html"
    echo "<!DOCTYPE html>
<html lang=\"fr\">
<head>
    <meta charset=\"UTF-8\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
    <title>Contexte $COUNTER</title>
</head>
<body>
    <h1>Contexte pour le mot \"$WORD\"</h1>
    <p style=\"white-space: pre-wrap;\">$CONTEXT</p>
</body>
</html>" > "$CONTEXT_HTML"

# Extraire les concordances
CONCORDANCE=$(extract_concordance "$DUMP_TEXT" "$WORD")

# Sauvegarder les concordances dans un fichier HTML
CONCORDANCE_HTML="$CONCORDANCE_DIR/concordance_$COUNTER.html"
echo "<!DOCTYPE html>
<html lang=\"fr\">
<head>
    <meta charset=\"UTF-8\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
    <title>Concordance $COUNTER</title>
    <style>
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: center; }
        th { background-color: #f8f9fa; }
        tr:nth-child(even) { background-color: #f9f9f9; }
    </style>
</head>
<body>
    <h1>Concordances pour le mot \"$WORD\"</h1>
    <table>
        <thead>
            <tr>
                <th>Gauche</th>
                <th>Mot</th>
                <th>Droit</th>
            </tr>
        </thead>
        <tbody>" > "$CONCORDANCE_HTML"

# Ajouter chaque concordance à la table HTML
echo "$CONCORDANCE" | while IFS=$'\t' read -r left word right; do
    echo "        <tr>
            <td>${left:-&nbsp;}</td>
            <td>${word:-&nbsp;}</td>
            <td>${right:-&nbsp;}</td>
        </tr>" >> "$CONCORDANCE_HTML"
done

# Fermer la table et le fichier HTML
echo "    </tbody>
    </table>
</body>
</html>" >> "$CONCORDANCE_HTML"


    # Ajouter les résultats au tableau HTML
echo "        <tr>
    <td>$COUNTER</td>
    <td><a href=\"$url\" target=\"_blank\">$url</a></td>
    <td>$HTTP_CODE</td>
    <td>${ENCODING:-Inconnu}</td>
    <td>$TOKENS</td>
    <td>$COMPTE</td>
    <td><a href=\"$CONTEXT_HTML\" target=\"_blank\">HTML</a></td>
    <td><a href=\"$CONCORDANCE_HTML\" target=\"_blank\">HTML</a></td>
    <td><a href=\"$ASPIRATION_FILE\" target=\"_blank\">HTML</a></td>
    <td><a href=\"$DUMP_FILE\" target=\"_blank\">TXT</a></td>
</tr>" >> "$OUTPUT_HTML"


    COUNTER=$((COUNTER + 1))
done < "$INPUT_FILE"

# Fin du tableau HTML
echo "    </tbody>
    </table>
</body>
</html>" >> "$OUTPUT_HTML"

echo "Tableau HTML généré dans $OUTPUT_HTML"
echo "Fichiers de concordance générés dans $CONCORDANCE_DIR"
