from wordcloud import WordCloud
import matplotlib.pyplot as plt


# Define stopwords to remove
stopwords = ['的', '了', '是', '和', '在', '不', '与', '为', '也', '之', '而', '或', '对', '都', '就', '他', '它', '从', '但', '这', '则', '被', '以', '所', '来', '上', '有', '中', '个', '于', '并', '由', '能', '等', '会', '即', '到', '把', '又', '这种']

# Read the file
with open('all_dumps.txt', 'r', encoding='utf-8') as file:
    lines = file.readlines()

# Filter out English words and stopwords
def is_chinese(char):
    return '\u4e00' <= char <= '\u9fff'

def should_keep_line(line):
    line = line.strip()
    # Skip empty lines or lines with only special characters
    if not line or line.startswith('#') or line.startswith('_'):
        return True
    # Keep only lines that contain Chinese characters and are not stopwords
    return any(is_chinese(char) for char in line) and line not in stopwords and len(line) > 1

filtered_lines = [line for line in lines if should_keep_line(line)]

# Write back to file
with open('all_dumps.txt', 'w', encoding='utf-8') as file:
    file.writelines(filtered_lines)


text = ' '.join(line.strip() for line in filtered_lines if line.strip())

# Create and generate a word cloud image
wordcloud = WordCloud(
    font_path='/usr/share/fonts/truetype/wqy/wqy-microhei.ttc',  # Chinese font
    width=800,
    height=400,
    background_color='white',
    max_words=200,
    min_font_size=10
).generate(text)

# Display the word cloud
plt.figure(figsize=(10, 5))
plt.imshow(wordcloud, interpolation='bilinear')
plt.axis('off')

# Save the image
plt.savefig('chinese_wordcloud.png', dpi=300, bbox_inches='tight')
plt.close()