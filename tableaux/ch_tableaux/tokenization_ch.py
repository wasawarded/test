import thulac
import errno
import fileinput
import os

# autre possibilité, lancer la commande:
# python -m thulac chinois.txt chinois_seg_output.txt -seg_only
# Mais ne permet pas les redirections d'entrées/sorties

seg = thulac.thulac(seg_only=True)

input_dir = "../../dumps-text/logique_chinois/"
output_dir = "./dump_ch_tokenized/"

os.makedirs(output_dir, exist_ok=True)

for filename in os.listdir(input_dir):
    input_path = os.path.join(input_dir, filename)
    output_path = os.path.join(output_dir, f"{filename}_tokenized.txt")
    try:
        with open(input_path, 'r', encoding='utf-8') as infile, open(output_path, 'w', encoding='utf-8') as outfile:
            for line in infile:
                outfile.write(seg.cut(line, text=True) + '\n')
    except IOError as e:
        if e.errno != errno.EPIPE:
            raise