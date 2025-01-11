import os
from pathlib import Path
from glob import glob

def get_context(lines, target_idx, window=2):
    start = max(0, target_idx - window)
    end = min(len(lines), target_idx + window + 1)
    return lines[start:end]

def token_to_contexte():
    # Setup paths
    input_dir = '../../dumps-text/logique_chinois/dump_ch_tokenized'
    output_dir = './contexte_txt'
    
    # Create output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)
    
    # Process each file
    for filepath in glob(os.path.join(input_dir, '*.txt')):
        filename = Path(filepath).name
        output_file = os.path.join(output_dir, filename)
        
        # Read input file
        with open(filepath, 'r', encoding='utf-8') as f:
            lines = f.readlines()
        
        # Find contexts
        contexts = []
        for idx, line in enumerate(lines):
            if '逻辑' in line:
                context = get_context(lines, idx)
                contexts.extend(context)
                contexts.append('\n' + '-'*50 + '\n')  # separator
        
        # Save if we found any contexts
        if contexts:
            with open(output_file, 'w', encoding='utf-8') as f:
                f.writelines(contexts)

def convert_to_html(content):
    html_template = f"""
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Context Display</title>
</head>
<body>
    {content}
</body>
</html>
"""
    return html_template

def main():
    # Setup paths
    input_dir = './contexte_txt'
    output_dir = './contexte_html'
    
    # Create output directory
    os.makedirs(output_dir, exist_ok=True)
    
    # Process each file
    for txt_file in glob(os.path.join(input_dir, '*.txt')):
        # Read input file
        with open(txt_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Convert content to HTML
        content = content.replace('\n', '<br>\n')
        content = content.replace('-'*50, '<hr>')
        html_content = convert_to_html(content)
        
        # Save as HTML
        output_file = os.path.join(output_dir, Path(txt_file).stem + '.html')
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(html_content)

if __name__ == '__main__':
    token_to_contexte()
    main()