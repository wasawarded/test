import os
from glob import glob

def make_logic_bold(html_content):
    return html_content.replace('votre mot', '<b>votre mot</b>')

def main():
    # Process each HTML file in contexte_html directory
    html_dir = 'votre chemin contexte_html'
    
    for html_file in glob(os.path.join(html_dir, '*.html')):
        # Read HTML content
        with open(html_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Make the word bold
        modified_content = make_logic_bold(content)
        
        # Save modified content
        with open(html_file, 'w', encoding='utf-8') as f:
            f.write(modified_content)

if __name__ == '__main__':
    main()