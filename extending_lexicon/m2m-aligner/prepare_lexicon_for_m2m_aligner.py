def read_file(file_path):
    f = open(file_path,'r',encoding='utf8')
    text = [l.strip() for l in f.readlines()]
    f.close()
    return text

new_lexicon_file = open("libri_lexicon_m2m_input.txt",'w',encoding='utf8')
for line in read_file("librispeech-lexicon_num_removed.txt"):
    word = " ".join([*line.split()[0]])
    pronunciation = " ".join(line.split()[1:])
    new_lexicon_file.write(word+"\t"+pronunciation+"\n")