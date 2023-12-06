#!/usr/bin/bash

input_file="hindi_words.txt"
output_words_file="hindi_lexicon.txt"

# Initialize the output_words_file
> "$output_words_file"

while IFS= read -r word; do
    ./unified-parser "$word" 1 0 0 0 
    echo $word
    extracted_words=$(grep -o '"[^"]*"' "wordpronunciation" | tr -d '"' | tr '\n' ' ')
    echo -e "$word\t$extracted_words" >> "$output_words_file"
done < "$input_file"
