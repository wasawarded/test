#!/usr/bin/env bash

# Vérifier qu'un argument a été fourni
if [ $# -eq 0 ]; then
    echo "Erreur : Veuillez fournir un fichier en argument"
    echo "Usage : $0 <fichier>"
    exit 1
fi

# Vérifier que le fichier existe et est lisible
if [ ! -f "$1" ] || [ ! -r "$1" ]; then
    echo "Erreur : Le fichier '$1' n'existe pas ou n'est pas lisible"
    exit 1
fi

COUNT=1
outout_csv="output.csv"

echo -e "Count\tURL\tHTTP_CODE\tENCODING\tHTML\tDUMP" > "$outout_csv"

while read -r line;
do
    url="$line"

    response=$(curl -s -I -L -w "HTTP_CODE:%{http_code}\nCONTENT_TYPE:%{content_type}\n" "$url" -o /dev/null)
    http_code=$(echo "$response" | grep "HTTP_CODE" | cut -d':' -f2)
    content_type=$(echo "$response" | grep "CONTENT_TYPE" | cut -d':' -f2)
    encoding=$(echo "$content_type" | grep -oE 'charset=[^;]+' | cut -d'=' -f2)
    
    if [ $http_code -eq 200 ]; then
        content=$(curl -s "$url")
        html_file="../../aspirations/ch_html/ch_$COUNT.html"
        txt_file="../../dumps-text/logique_chinois/dump_ch_$COUNT.txt"

        echo "$content" > "$html_file"
        dump=$(lynx -dump -nolist $html_file)
        echo "$dump" > "$txt_file"

        echo -e "[$COUNT]\t$url\t$http_code\t$encoding\t$html_file\t$txt_file" >> "$outout_csv"
    else
        echo "[$COUNT] $url : ERROR! $http_code"
        echo -e "[$COUNT]\t$url\t$http_code\t$encoding\t-\t-" >> "$outout_csv"
    fi

    COUNT=$((COUNT + 1))
done < "$1"