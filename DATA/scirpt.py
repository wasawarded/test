import matplotlib.pyplot as plt
from wordcloud import WordCloud

with open("cooccurrences_ar.txt", "r", encoding="utf-8") as file:
    text = file.read()

wordcloud = WordCloud(width=800, height=400, background_color="white").generate(text)
plt.figure(figsize=(10, 5))
plt.imshow(wordcloud, interpolation="bilinear")
plt.axis("off")
plt.title("Nuage de mots - Cooccurrences autour de منطق")
plt.show()