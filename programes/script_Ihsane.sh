#!/usr/bin/env bash

# Définition des chemins
base_dir=".."

# Déclaration des langues et des mots-clés
langues=("ar" "fr")
declare -A mots
mots=( ["ar"]="المنطق |منطق" ["fr"]="Logique|logique|Logiques|logiques" )

# Déclaration des messages de succès par langue
declare -A messages
messages=( ["ar"]="تم إنشاء النتيجة بنجاح" ["fr"]="Résultat généré avec succès" )

# Déclaration des titres des colonnes par langue
declare -A titres
titres["ar"]="
            <th>تطابق الكلمة</th>
            <th>إطار الكلمة</th>
            <th>معالجة الصفحة</th>
            <th>امتصاص الصفحة</th>
            <th>تكرار الكلمة</th>
            <th>عدد الكلمات الكلي</th>
            <th>ترميز</th>
            <th>رمز جواب الصفحة</th>
            <th>الرابط</th>
            <th>رقم</th>"

titres["fr"]="
            <th>Numéro</th>
            <th>URL</th>
            <th>Code HTTP</th>
            <th>Encodage HTML</th>
            <th>Nombre de Tokens</th>
            <th>Occurences</th>
            <th>Aspirations</th>
            <th>Dumps</th>
            <th>Contexte</th>
            <th>Concordance</th>"

for langue in "${langues[@]}"; do

    # Initialisation d'environement de travail
    tableaux_DIR="$base_dir/tableaux/${langue}_tableaux"
    aspirations_DIR="$base_dir/aspirations/${langue}_html"
    dumps_DIR="$base_dir/dumps-text/${langue}_logique"
    PDF_DIR="$base_dir/aspirations/${langue}_pdf"
    pals_DIR="$base_dir/pals"
    concordances_DIR="$base_dir/concordances/${langue}_concordances"
    contextes_DIR="$base_dir/contextes/${langue}_contexte"
    log_DIR="$base_dir/log"
    OUTPUT_HTML="$tableaux_DIR/${langue}_table.html"
    LOG_FILE="$log_DIR/script_errors_${langue}.log"

    # Création des répertoires
    mkdir -p "$tableaux_DIR" "$aspirations_DIR" "$dumps_DIR" "$PDF_DIR" "$pals_DIR" "$concordances_DIR" "$contextes_DIR" "$log_DIR"
    if [[ $? -ne 0 ]]; then
        echo "Erreur lors de la création des répertoires pour $langue." >> "$LOG_FILE"
        exit 1
    fi

    touch "$OUTPUT_HTML" "$LOG_FILE"

    # Initialisation du compteur
    COUNT=1

    # Définir le chemin du fichier contenant les URLs pour chaque langue
    urls_file="$base_dir/URLs/${langue}_url/${langue}_url.txt"

    # Vérifier si le fichier existe
    if [[ ! -f "$urls_file" ]]; then
        echo "Le fichier $urls_file n'existe pas !" >> "$LOG_FILE"
        continue
    fi
    # Initialisation du tableau HTML
    cat <<EOT > "$OUTPUT_HTML"
<!DOCTYPE html>
<html lang="${langue}">
<head>
    <meta charset="UTF-8">
    <title>Tableau des résultats</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
	<link rel="stylesheet" href="../../sites_groupe/style.css">

</head>

<body>
	<!-- Navigation -->
    <nav class="navbar is-dark" role="navigation" aria-label="main navigation">
        <div class="navbar-brand">
            <a class="navbar-item" href="#">
                <i class="fas fa-brain"></i>
            </a>
        </div>
        <div class="navbar-menu">
            <div class="navbar-start">
                <a class="navbar-item" href="../../index.html">Accueil</a> <!--doit contenir présentationdu projet+définition-->
                <a class="navbar-item" href=\"../$OUTPUT_HTML\" target=\"_blank\">Tableaux</a>
                <a class="navbar-item" href=\"../../sites_groupe/analyse_linguistique _${langue}.html\" target=\"_blank\">Analyse</a>
                <a class="navbar-item" href="#script">Script</a>
                <a class="navbar-item" href="../../sites_groupe/Logique_à_propos_du_projet.html">À propos</a>
            </div>
            <div class="navbar-end">
                <div class="navbar-item has-dropdown">
                    <a class="navbar-item" href="#script">Langues</a>
                    <div class="navbar-dropdown">
                        <a href="../../sites_groupe/en_table.html">English</a>
                        <a href="#script-fr">Français</a>
                        <a href="#script-pt">Português</a>
                        <a href="#script-ar">العربية</a>
                        <a href="#script-ch">中文</a>
                    </div>
                </div>
            </div>
        </div>
    </nav>
<div style="width: 80%; margin: 0 auto; padding-top: 15px;">
<table border="1" width="100%">
    <caption style="padding-bottom:20px;">
        <strong><u><center> ${messages[$langue]}</center></u></strong>
    </caption>
    <thead>
        <tr>
            ${titres[$langue]}
        </tr>
    </thead>
    <tbody>
EOT

    # Lire les URLs ligne par ligne dans le fichier
    while IFS= read -r url || [[ -n "$url" ]]; do

        temp_concordance="temp_concordance_${COUNT}.html"

        echo "[$COUNT] Traitement de l'URL : $url"

        # Vérification si l'URL pointe vers un PDF
        if [[ "$url" == *.pdf ]]; then
            PDF_FILE="${PDF_DIR}/${langue}_${COUNT}.pdf"
            dump_FILE="${dumps_DIR}/${langue}_${COUNT}.txt"
            concordance_FILE="${concordances_DIR}/${langue}_${COUNT}.html"
            context_FILE="${contextes_DIR}/${langue}_${COUNT}.txt"

            # Téléchargement du PDF
            curl -s -o "$PDF_FILE" -A "Mozilla/5.0" "$url"

            # Vérification si le PDF est téléchargé
            if [[ -f "$PDF_FILE" ]]; then
                # Extraction du texte du PDF
                pdftotext "$PDF_FILE" "$dump_FILE"

                if [[ $? -ne 0 ]]; then
                    echo "Erreur lors de l'extraction du texte du PDF : $PDF_FILE" >> "$LOG_FILE"
                    continue
                fi

               # Comptage des tokens
                token_count=$(wc -w < "$dump_FILE")
                # Comptage des occurrences du mot étudié
                word_count=$(grep -o -E "${mots[$langue]}" "$dump_FILE" | wc -l)

                # Extraction des contextes
                context_FILE="${contextes_DIR}/${langue}_${COUNT}.txt"
                grep -C 2 -E "${mots[$langue]}" "$dump_FILE" > "$context_FILE"

                if [[ "$langue" == "ar" ]]; then
                    # Génération des concordances
                    grep -o -E ".{0,30}(${mots[$langue]}).{0,30}" "$dump_FILE" | sed -E "s/(.{0,30})(${mots[$langue]})(.{0,30})/<tr><td>\3<\/td><td><strong>\2<\/strong><\/td><td>\1<\/td><\/tr>/" > $temp_concordance
                else
                    grep -o -E ".{0,30}(${mots[$langue]}).{0,30}" "$dump_FILE" | sed -E "s/(.{0,30})(${mots[$langue]})(.{0,30})/<tr><td>\1<\/td><td><strong>\2<\/strong><\/td><td>\3<\/td><\/tr>/" > $temp_concordance
                fi

                # Génération du fichier HTML de concordances
                cat <<EOC > "$concordance_FILE"
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Tableau des résultats</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
	<link rel="stylesheet" href="../../sites_groupe/style.css">

</head>

<body>
	<!-- Navigation -->
    <nav class="navbar is-dark" role="navigation" aria-label="main navigation">
        <div class="navbar-brand">
            <a class="navbar-item" href="#">
                <i class="fas fa-brain"></i>
            </a>
        </div>
        <div class="navbar-menu">
            <div class="navbar-start">
                <a class="navbar-item" href="../../index.html">Accueil</a> <!--doit contenir présentationdu projet+définition-->
                <a class="navbar-item" href=\"../$OUTPUT_HTML\" target=\"_blank\">Tableaux</a>
                <a class="navbar-item" href=\"../../sites_groupe/analyse_linguistique _${langue}.html\" target=\"_blank\">Analyse</a>
                <a class="navbar-item" href="#script">Script</a>
                <a class="navbar-item" href="../../sites_groupe/Logique_à_propos_du_projet.html">À propos</a>
            </div>
            <div class="navbar-end">
                <div class="navbar-item has-dropdown">
                    <a class="navbar-item" href="#script">Langues</a>
                    <div class="navbar-dropdown">
                        <a href="../../sites_groupe/en_table.html">English</a>
                        <a href="#script-fr">Français</a>
                        <a href="#script-pt">Português</a>
                        <a href="#script-ar">العربية</a>
                        <a href="#script-ch">中文</a>
                    </div>
                </div>
            </div>
        </div>
    </nav>
<h2>Concordance pour les mots : ${mots[$langue]}</h2>
<table>
    <thead>
        <tr>
            <th>Contexte gauche</th>
            <th>Mot</th>
            <th>Contexte droit</th>
        </tr>
    </thead>
    <tbody>
$(cat $temp_concordance)
    </tbody>
</table>
</body>
</html>
EOC
                rm $temp_concordance

                if [[ "$langue" == "fr" ]]; then
                    echo -e "<tr>
                        <td>$COUNT</td>
                        <td><a href=\"$url\" target=\"_blank\">$url</a></td>
                        <td>PDF</td>
                        <td></td>
                        <td>$token_count</td>
                        <td>$word_count</td>
                        <td><a href=\"../$PDF_FILE\" target=\"_blank\">aspiration</a></td>
                        <td><a href=\"../$dump_FILE\" target=\"_blank\">dupm</a></td>
                        <td><a href=\"../$context_FILE\" target=\"_blank\">Contexte</a></td>
                        <td><a href=\"../$concordance_FILE\" target=\"_blank\">Concordances</a></td>
                    </tr>" >> "$OUTPUT_HTML"
                else
                    echo -e "<tr>
                        <td><a href=\"../$concordance_FILE\" target=\"_blank\">Concordances</a></td>
                        <td><a href=\"../$context_FILE\" target=\"_blank\">Contexte</a></td>
                        <td><a href=\"../$dump_FILE\" target=\"_blank\">dupm</a></td>
                        <td><a href=\"../$PDF_FILE\" target=\"_blank\">aspiration</a></td>
                        <td>$word_count</td>
                        <td>$token_count</td>
                        <td></td>
                        <td>PDF</td>
                        <td><a href=\"$url\" target=\"_blank\">$url</a></td>
                        <td>$COUNT</td>
                    </tr>" >> "$OUTPUT_HTML"
                fi

            else
                 echo "[$COUNT] Erreur lors du téléchargement du PDF : $url" >> "$LOG_FILE"
            fi

            COUNT=$((COUNT + 1))
            continue
        fi

        # Récupération des en-têtes HTTP
        RESPONSE=$(curl --connect-timeout 10 -s -I -L -A "Mozilla/5.0" "$url" -o /dev/null -w "%{http_code} %{content_type}")
        HTTP_CODE=$(echo $RESPONSE | cut -d " " -f1)
		CONTENT_TYPE=$(echo $RESPONSE | cut  -f2)
        ENCODING=$(echo "$CONTENT_TYPE" | grep -E -o -i "charset\S+" | sed -E 's/charset=(.*)/\1/')

        if [[ "$HTTP_CODE" -eq 200 ]]; then
            # Téléchargement du contenu HTML
            aspirations_FILE="${aspirations_DIR}/${langue}_${COUNT}.html"
            dump_FILE="${dumps_DIR}/${langue}_${COUNT}.txt"
            concordance_FILE="${concordances_DIR}/${langue}_${COUNT}.html"
            context_FILE="${contextes_DIR}/${langue}_${COUNT}.txt"

            curl -s -A "Mozilla/5.0" "$url" > "$aspirations_FILE"

            # Vérification si le fichier HTML est téléchargé
            if [[ -s "$aspirations_FILE" ]]; then
                # Extraction du texte brut avec lynx
                lynx -dump -nolist "$aspirations_FILE" > "$dump_FILE"

                # Comptage des tokens
                token_count=$(wc -w < "$dump_FILE")

                # Comptage des occurrences du mot étudié
                word_count=$(grep -o -E "${mots[$langue]}" "$dump_FILE" | wc -l)

                # Extraction des contextes
                grep -C 2 -E "${mots[$langue]}" "$dump_FILE" > "$context_FILE"

                 if [[ "$langue" == "ar" ]]; then
                    # Génération des concordances
                    grep -o -E ".{0,30}(${mots[$langue]}).{0,30}" "$dump_FILE" | sed -E "s/(.{0,30})(${mots[$langue]})(.{0,30})/<tr><td>\3<\/td><td><strong>\2<\/strong><\/td><td>\1<\/td><\/tr>/" > $temp_concordance
                else
                    grep -o -E ".{0,30}(${mots[$langue]}).{0,30}" "$dump_FILE" | sed -E "s/(.{0,30})(${mots[$langue]})(.{0,30})/<tr><td>\1<\/td><td><strong>\2<\/strong><\/td><td>\3<\/td><\/tr>/" > $temp_concordance
                fi

                # Génération du fichier HTML de concordances
                cat <<EOC > "$concordance_FILE"
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Tableau des résultats</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
	<link rel="stylesheet" href="../../sites_groupe/style.css">

</head>

<body>
	<!-- Navigation -->
    <nav class="navbar is-dark" role="navigation" aria-label="main navigation">
        <div class="navbar-brand">
            <a class="navbar-item" href="#">
                <i class="fas fa-brain"></i>
            </a>
        </div>
        <div class="navbar-menu">
            <div class="navbar-start">
                <a class="navbar-item" href="../../index.html">Accueil</a> <!--doit contenir présentationdu projet+définition-->
                <a class="navbar-item" href=\"../$OUTPUT_HTML\" target=\"_blank\">Tableaux</a>
                <a class="navbar-item" href=\"../../sites_groupe/analyse_linguistique _${langue}.html\" target=\"_blank\">Analyse</a>
                <a class="navbar-item" href="#script">Script</a>
                <a class="navbar-item" href="../../sites_groupe/Logique_à_propos_du_projet.html">À propos</a>
            </div>
            <div class="navbar-end">
                <div class="navbar-item has-dropdown">
                    <a class="navbar-item" href="#script">Langues</a>
                    <div class="navbar-dropdown">
                        <a href="../../sites_groupe/en_table.html">English</a>
                        <a href="#script-fr">Français</a>
                        <a href="#script-pt">Português</a>
                        <a href="#script-ar">العربية</a>
                        <a href="#script-ch">中文</a>
                    </div>
                </div>
            </div>
        </div>
    </nav>
<h2>Concordance pour les mots : ${mots[$langue]}</h2>
<table>
    <thead>
        <tr>
            <th>Contexte gauche</th>
            <th>Mot</th>
            <th>Contexte droit</th>
        </tr>
    </thead>
    <tbody>
$(cat $temp_concordance)
    </tbody>
</table>
</body>
</html>
EOC
                rm $temp_concordance

                if [[ "$langue" == "fr" ]]; then
                    echo -e "<tr>
                        <td>$COUNT</td>
                        <td><a href=\"$url\" target=\"_blank\">$url</a></td>
                        <td>$HTTP_CODE</td>
                        <td>$ENCODING</td>
                        <td>$token_count</td>
                        <td>$word_count</td>
                        <td><a href=\"../$aspirations_FILE\" target=\"_blank\">aspiration</a></td>
                        <td><a href=\"../$dump_FILE\" target=\"_blank\">dump</a></td>
                        <td><a href=\"../$context_FILE\" target=\"_blank\">Contexte</a></td>
                        <td><a href=\"../$concordance_FILE\" target=\"_blank\">Concordances</a></td>
                    </tr>" >> "$OUTPUT_HTML"
                else
                    echo -e "<tr>
                        <td><a href=\"../$concordance_FILE\" target=\"_blank\">Concordances</a></td>
                        <td><a href=\"../$context_FILE\" target=\"_blank\">Contexte</a></td>
                        <td><a href=\"../$dump_FILE\" target=\"_blank\">dump</a></td>
                        <td><a href=\"../$aspirations_FILE\" target=\"_blank\">aspiration</a></td>
                        <td>$word_count</td>
                        <td>$token_count</td>
                        <td>$ENCODING</td>
                        <td>$HTTP_CODE</td>
                        <td><a href=\"$url\" target=\"_blank\">$url</a></td>
                        <td>$COUNT</td>
                    </tr>" >> "$OUTPUT_HTML"
                fi
            else
                echo "[$COUNT] Erreur lors du téléchargement de la page HTML : $url" >> "$LOG_FILE"
            fi
        fi

        COUNT=$((COUNT + 1))
    done < "$urls_file"

    # Finalisation du tableau HTML
    cat <<EOT >> "$OUTPUT_HTML"
    </tbody>
</table>
</div>
</body>
</html>
EOT
done
echo "Le script s'est exécuté avec succès pour toutes les langues. Consultez $LOG_FILE pour plus de détails."
