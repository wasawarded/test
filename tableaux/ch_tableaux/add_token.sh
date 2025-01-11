#!/bin/bash

# Create temporary file
temp_file=temp.csv

# Add header with new columns
echo -e "Count\tURL\tHTTP_CODE\tENCODING\tHTML\tDUMP\tNombres de Token\tCompte" > "$temp_file"

# Skip first line of input file and process the rest
tail -n +2 output.csv | while IFS=$'\t' read -r count url http encoding html dump; do
    # Extract number from count field (remove brackets)
    num=$(echo "$count" | tr -d '[]')
    
    # Initialize counts
    token_count="-"
    logic_count="-"
    
    # Path to tokenized file
    tokenized_file="./dump_ch_tokenized/dump_ch_${num}.txt_tokenized.txt"
    dump_file="../../dumps-text/logique_chinois/dump_ch_${num}.txt"
    
    # Check if files exist and count isn't for failed downloads (like [19])
    if [ -f "$tokenized_file" ] && [ -f "$dump_file" ] && [ "$http" == "200" ]; then
        # Count words in tokenized file
        token_count=$(wc -w < "$tokenized_file")
        
        # Count occurrences of 逻辑 in dump file
        logic_count=$(grep -o "逻辑" "$dump_file" | wc -l)
    fi
    
    # Output line with new columns
    echo -e "${count}\t${url}\t${http}\t${encoding}\t${html}\t${dump}\t${token_count}\t${logic_count}"
done >> "$temp_file"

# Replace original file
mv "$temp_file" output.csv