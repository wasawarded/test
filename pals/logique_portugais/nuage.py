from wordcloud import WordCloud
import matplotlib.pyplot as plt
import re

# Chemin vers le fichier fusionné
input_file = "cleaned_dumps.txt"

# Liste des stopwords portugais
stopwords = [
    'de', 'a', 'o', 'que', 'e', 'do', 'da', 'em', 'um', 'uma', 'os', 'as', 'é', 'para',
    'com', 'não', 'se', 'por', 'no', 'na', 'sua', 'nos', 'nas', 'ao', 'dos', 'das', 'ou',
    'uma', 'às', 'um', 'essa', 'isso', 'este', 'com', 'são', 'mais', 'pelo', 'pelos',
    'pela', 'elas', 'ele', 'entre', 'tem', 'como', 'também', 'isso', 'esse',"mas","seu","the","esta","está","outro","index php","void","php title","internet coisas","cite ref","ela","and","php title","estes","lhe","aos","index","php","title","internet","edit section","del prette","pdp","suas","links","link","cite","ref"
]

# Lire le contenu du fichier
with open(input_file, 'r', encoding='utf-8') as file:
    text = file.read()

# Nettoyer le texte
def clean_text(text):
    # Supprimer les URLs
    text = re.sub(r'http[s]?://\S+', '', text)
    # Supprimer les adresses email
    text = re.sub(r'\S+@\S+', '', text)
    # Supprimer les balises HTML
    text = re.sub(r'<[^>]+>', '', text)
    # Supprimer les caractères non alphabétiques (hors accents portugais)
    text = re.sub(r'[^a-zA-Zá-úÁ-ÚãõÃÕçÇ ]', ' ', text)
    # Réduire les espaces multiples à un seul espace
    text = re.sub(r'\s+', ' ', text)
    return text.strip()

# Nettoyer le contenu
cleaned_text = clean_text(text)

# Séparer les mots et exclure les stopwords
words = cleaned_text.lower().split()
filtered_words = [word for word in words if word not in stopwords and len(word) > 2]

# Fusionner les mots filtrés en une chaîne
filtered_text = " ".join(filtered_words)

# Générer le nuage de mots
wordcloud = WordCloud(
    stopwords=stopwords,
    width=800,
    height=400,
    background_color='white',
    max_words=200,
    min_font_size=10
).generate(filtered_text)

# Afficher le nuage de mots
plt.figure(figsize=(10, 5))
plt.imshow(wordcloud, interpolation='bilinear')
plt.axis('off')

# Sauvegarder le nuage de mots
output_image = "portuguese_wordcloud.png"
plt.savefig(output_image, dpi=300, bbox_inches='tight')
plt.close()

print(f"Nuage de mots sauvegardé sous {output_image}")
