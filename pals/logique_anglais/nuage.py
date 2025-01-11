from wordcloud import WordCloud
import matplotlib.pyplot as plt
import re

# Chemin vers le fichier fusionné
input_file = "tokenized_all_en_dump.txt"

# Liste des stopwords portugais
stopwords = [
    "i", "me", "my", "myself", "we", "our", "ours", "ourselves", "you", "your", "yours", "yourself", "yourselves",
    "he", "him", "his", "himself", "she", "her", "hers", "herself", "it", "its", "itself", "they", "them", "their",
    "theirs", "themselves", "what", "which", "who", "whom", "this", "that", "these", "those", "am", "is", "are", "was",
    "were", "be", "been", "being", "have", "has", "had", "having", "do", "does", "did", "doing", "a", "an", "the", "and",
    "but", "if", "or", "because", "as", "until", "while", "of", "at", "by", "for", "with", "about", "against", "between",
    "into", "through", "during", "before", "after", "above", "below", "to", "from", "up", "down", "in", "out", "on", "off",
    "over", "under", "again", "further", "then", "once", "here", "there", "when", "where", "why", "how", "all", "any",
    "both", "each", "few", "more", "most", "other", "some", "such", "no", "nor", "not", "only", "own", "same", "so",
    "than", "too", "very", "s", "t", "can", "will", "just", "don", "should", "now", "d", "ll", "m", "o", "re", "ve", "y",
    "ain", "aren", "couldn", "didn", "doesn", "hadn", "hasn", "haven", "isn", "ma", "mightn", "mustn", "needn", "shan",
    "shouldn", "wasn", "weren", "won", "wouldn"
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
output_image = "anglais_wordcloud.png"
plt.savefig(output_image, dpi=300, bbox_inches='tight')
plt.close()

print(f"Nuage de mots sauvegardé sous {output_image}")
