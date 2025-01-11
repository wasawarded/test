import os
from pathlib import Path

def find_logic_context(section):
    """Find first occurrence of 逻辑 and surrounding tokens in a section."""
    for line in section.strip().split('\n'):
        tokens = line.strip().split()
        for i, token in enumerate(tokens):
            if '逻辑' in token:
                prev_token = tokens[i-1] if i > 0 else ''
                next_token = tokens[i+1] if i < len(tokens)-1 else ''
                return [prev_token, token, next_token]
    return None

def create_html_table(results, filename):
    """Create HTML table with results."""
    html = '''
    <html>
    <head>
        <style>
            table {{ 
                border-collapse: collapse; width: 100%; }}
            th, td {{
               border: 1px solid black; padding: 8px; text-align: left; }}
        </style>
    </head>
    <body>
        <h2>{0}</h2>
        <table>
            <tr>
                <th>Previous Token</th>
                <th>Logic Token</th>
                <th>Next Token</th>
            </tr>
    '''.format(filename)
    
    for tokens in results:
        if tokens:
            html += '<tr><td>{}</td><td>{}</td><td>{}</td></tr>'.format(*tokens)
    
    html += '''
        </table>
    </body>
    </html>
    '''
    return html

def process_file(filepath):
    """Process single file and generate HTML."""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        sections = content.split('-' * 50)
        results = []
        
        for section in sections:
            if section.strip():
                tokens = find_logic_context(section)
                if tokens:
                    results.append(tokens)
        
        html_content = create_html_table(results, Path(filepath).name)
        output_path = Path(filepath).with_suffix('.html')
        
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(html_content)
            
    except Exception as e:
        print(f"Error processing {filepath}: {str(e)}")

def main():
    """Main function to process all files."""
    context_dir = './contexte_txt'
    for filename in os.listdir(context_dir):
        if filename.endswith('.txt'):
            filepath = os.path.join(context_dir, filename)
            process_file(filepath)
        else:
            print(f"File not found: {filename}")

if __name__ == '__main__':
    main()