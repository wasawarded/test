import csv
import html

def csv_to_html():
    html_start = """<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>CH Table</title>
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
            margin: 20px 0;
            font-size: 14px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
            max-width: 300px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        th {
            background-color: #f2f2f2;
            position: sticky;
            top: 0;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
        td:hover {
            white-space: normal;
            word-break: break-all;
        }
    </style>
</head>
<body>
<h1>Résultats du traitement des dumps pour le mot logique en chinois</h1>
    <table>"""

    with open('output.csv', 'r', encoding='utf-8') as f:
        reader = csv.reader(f, delimiter='\t')
        headers = next(reader)
        
        # Create table headers
        html_content = "<thead><tr>"
        for header in headers:
            if header != "HTML" and header != "DUMP":
                html_content += f"<th>{html.escape(header)}</th>"
        html_content += "<th>Lien Contexte</th><th>Lien Concordance</th><th>Aspiration</th><th>Dump</th>"
        html_content += "</tr></thead><tbody>"
        
        # Create table rows
        for row in reader:
            file_id = row[0].strip('[]')
            html_content += "<tr>"
            for index, cell in enumerate(row):
                if index == 1:
                    html_content += f"<td><a href=\"{cell}\">{html.escape(str(cell))}</a></td>"
                elif index == 4 or index == 5:
                    continue
                else:
                    html_content += f"<td>{html.escape(str(cell))}</td>"

            contexte_path = f"../../contextes/ch_contexte/contexte_txt/dump_ch_{file_id}.txt_tokenized.txt"
            concordance_path = f"../concordances/ch_concordances/dump_ch_{file_id}.txt_tokenized.html"
            aspiration_path = f"../../aspirations/ch_html/ch_{file_id}.html"
            dump_path = f"../../dumps-text/logique_chinois/dump_ch_{file_id}.txt"
            html_content += f"<td><a href=\"{contexte_path}\">Contexte</a></td>"
            html_content += f"<td><a href=\"{concordance_path}\">Concordance</a></td>"
            html_content += f"<td><a href=\"{aspiration_path}\">aspiration</a></td>"
            html_content += f"<td><a href=\"{dump_path}\">dump</a></td>"
            html_content += "</tr>"

    html_end = "</tbody></table></body></html>"
    
    with open('ch_table.html', 'w', encoding='utf-8') as f:
        f.write(html_start + html_content + html_end)

if __name__ == "__main__":
    csv_to_html()
