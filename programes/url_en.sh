#!/bin/sh
nb=1
url_path="../URLs/en_url/logic_english.txt"
dump_path="../dumps-text/logique_anglais/dump_en"
contexte_path="../contextes/en_contexte/en_contexte"
concordance_path="../concordances/en_concordances/en_concordance"
aspiration_path="../aspirations/en_html/en"
mot="logic"


echo "<!DOCTYPE html>
<html lang=\"fr\">
<head>
    <meta charset=\"UTF-8\">
    <title>Tableau des résultats</title>
</head>
<body>
<div style=\"width: 80%; margin: 0 auto; padding-top: 15px;\">
<table border=\"1\" width=\"100%\">
    <caption style=\"padding-bottom:20px;\">
        <strong><u><center>Résultats du traitement des dumps pour le mot logique en anglais</center></u></strong>
    </caption>
    <thead>
        <tr>
            <th>Numéro</th>
            <th>URL</th>
            <th>Code HTTP</th>
            <th>Encodage HTML</th>
            <th>Nombre de Tokens</th>
            <th>Compte</th>
            <th>Lien Aspiration</th>
            <th>Lien Dumps-text</th>
            <th>Lien Contexte</th>
            <th>Lien Concordance</th>
        </tr>
    </thead>
    <tbody>" > "../tableaux/en_table.html"

while read -r line && [ $nb -lt 51 ] ;
do
	if [[ $line =~ ^https?:// ]]
	then
		# -I que les entêtes, pas besoin de -i les html
		# -o les médadonnées et les textes
		file=$aspiration_path$nb.html
		reponse=$(curl --connect-timeout 10 -s -L -w "%{http_code}\t%{content_type}" -o $file $line)
		code_http=$(echo $reponse | cut -d " " -f1)
		content_type=$(echo $reponse | cut  -f2)
		encodage=$(echo $content_type | grep -E -o -i "charset\S+" | sed -E 's/charset=(.*)/\1/')
		comptage=$(grep -i -o "logic" $file | wc -w ) # word logic occurrence
		# vérification de ne pas avoir des url répétés : create a no repetition list
		if [[ $encodage =~ [uU][tT][fF]-8 ]] && [ $code_http -eq 200 ]
		then
			lynx -dump -nolist $file > $dump_path$nb.txt # dump file
			nombre_mots=$(lynx -dump -nolist "$dump_path$nb.txt" | wc -w) # all words from dump file
			grep -i -C2 "\blogic\b" "$dump_path$nb.txt" > $contexte_path"$nb.txt" # contexte file
			h1="$aspiration_path$nb.html"
			h2="$dump_path$nb.txt"
			h3="$contexte_path$nb.txt"
			h4="$concordance_path$nb.html"

			echo "<tr>
            <td>$nb</td>
            <td><a href=\"$line\">$line</a></td>
            <td>200</td>
            <td>utf-8</td>
            <td>$nombre_mots</td>
            <td>$comptage</td>
            <td><a href=\"$h1\">Aspiration</a></td>
            <td><a href=\"$h2\">Dumps</a></td>
            <td><a href=\"$h3\">Contexte</a></td>
            <td><a href=\"$h4\">Concordance</a></td>
            </tr>" >> "../tableaux/en_table.html"
			nb=$(expr $nb + 1)

		elif [ $code_http -ne 200 ]
		then
		# even if the code is not 200, we need to write a information in our html
			echo -e "$nb\t$line not 200"

		elif [[ ! $encodage =~ [uU][tT][fF]-8 ]] && [ $code_http -eq 200 ]
		then
			iconv -f $encodage -t utf-8 $file -o $file # transformation en UTF-8
			lynx -dump -nolist $file > $dump_path$nb.txt # dump file
			nombre_mots=$(lynx -dump -nolist "$dump_path$nb.txt" | wc -w) # all words from dump file
			grep -i -C2 "\blogic\b" "$dump_path$nb.txt" > $contexte_path"$nb.txt" # cotexte file
			h1="$aspiration_path$nb.html"
			h2="$dump_path$nb.txt"
			h3="$contexte_path$nb.txt"
			h4="$concordance_path$nb.html"

			echo "<tr>
            <td>$nb</td>
            <td><a href=\"$line\">$line</a></td>
            <td>200</td>
            <td>utf-8</td>
            <td>$nombre_mots</td>
            <td>$comptage</td>
            <td><a href=\"$h1\">Aspiration</a></td>
            <td><a href=\"$h2\">Dumps</a></td>
            <td><a href=\"$h3\">Contexte</a></td>
            <td><a href=\"$h4\">Concordance</a></td>
            </tr>" >> "../tableaux/en_table.html"
			nb=$(expr $nb + 1)
		fi
	else
		echo -e "$nb\t$line\tformat non conforme"
	fi
done < $url_path

echo "</tbody>
</table>
</div>
</body>
</html>" >> "../tableaux/en_table.html"
