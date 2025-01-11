import re

# Fonction pour nettoyer le texte
def clean_text(text):
    # Supprimer les URLs, "localhost" et chemins web
    text = re.sub(r"http[s]?://\S+|www\.\S+|localhost\S*", " ", text)

    # Supprimer les balises HTML
    text = re.sub(r"<[^>]+>", " ", text)

    # Supprimer les chemins de fichiers (tmp, html, js, etc.)
    text = re.sub(r"\b\w+\.(html|tmp|js|css|pdf|docx|xlsx|json)\b", " ", text)

    # Supprimer les séquences de lettres ou chiffres isolés (identifiants, caractères aléatoires)
    text = re.sub(r"\b[a-zA-Z0-9]{10,}\b", " ", text)

    # Supprimer les lettres isolées et les mots très courts (moins de 2 caractères)
    text = re.sub(r"\b[a-zA-Z]{1,2}\b", " ", text)

    # Supprimer les mots-clés techniques ou indésirables
    stopwords = [
        "file", "button", "version", "close", "lang", "download", "header",
        "footer", "logo", "rss", "form", "javascript", "local", "link", "save",
        "set", "locale", "csp", "article", "mimeo", "pages", "projeto", "tmp",
        "text", "journal", "feed", "top", "back", "v", "n", "pt", "op", "cit"
    ]
    for word in stopwords:
        text = re.sub(r"\b" + word + r"\b", " ", text, flags=re.IGNORECASE)

    # Supprimer les caractères non portugais (tout sauf lettres portugaises, espaces)
    text = re.sub(r"[^a-zA-Zá-úÁ-ÚãõÃÕçÇ\s]", " ", text)

    # Convertir le texte en minuscules
    text = text.lower()

    # Supprimer les espaces multiples
    text = re.sub(r"\s+", " ", text).strip()

    return text

# Lire le fichier d'entrée
input_file = "all_dumps.txt"
output_file = "cleaned_dumps.txt"

# Lire le contenu du fichier
with open(input_file, "r", encoding="utf-8") as infile:
    content = infile.read()

# Nettoyer le contenu
cleaned_content = clean_text(content)

# Sauvegarder le contenu nettoyé dans un fichier de sortie
with open(output_file, "w", encoding="utf-8") as outfile:
    outfile.write(cleaned_content)

print(f"Le fichier nettoyé a été sauvegardé dans '{output_file}'.")

