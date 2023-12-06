def read_file(file_path):
    f = open(file_path,'r',encoding='utf8')
    text = [l.strip() for l in f.readlines()]
    f.close()
    return text


libri_lexicon = {}
for line in read_file("librispeech-lexicon_num_removed.txt"):
    word = line.split()[0]
    if word in libri_lexicon:
        libri_lexicon[line.split()[0]].append(line.split()[1:])
    else:
        libri_lexicon[line.split()[0]] = [line.split()[1:]]

rules = {
    'start':{
        'TH':'t', #3rd rule
        'DH':'d', #4th rule
        'IH':'y IH','IY':'y IY', #5th rule
        'W':'' #7th rule

    },
    'not-start':{
        'AE':'aa','EY':'ee','OW':'oo','OY':'oo', #1st rule
        'ZH':'j', #2nd rule
        'TH':'th', #3rd rule
        'DH':'d', #4th rule
        'F':'ph', #9th rule
        'V':'bh','W':'bh', #10th rule

    }
}        

unified_map = {}
for line in read_file("cmu_map_unified_code"):
    unified_map[line.split()[0]]=line.split()[1]

def get_mis_pronuciations(phon_trans):
    new_pronunciation = phon_trans.copy()
    # creating mis pronunciations based on rules
    for idx,phon in enumerate(phon_trans):
        if idx == 0:
            if phon in rules['start']:
                new_pronunciation[idx] = rules['start'][phon]
        else:
            if phon in rules['not-start']:
                new_pronunciation[idx] = rules['not-start'][phon]
    if new_pronunciation == phon_trans:
        # print(new_pronunciation,"--",phon_trans)
        return []
    else:
        new_pronunciation = " ".join(new_pronunciation)
        # mapping xmu phones to corresponding unified
        new = []
        for phon in new_pronunciation.split():
            if phon in unified_map:
                new.append(unified_map[phon])
            else:
                new.append(phon)
        return [" ".join(new)]





new_lexicon = {}
for word in libri_lexicon:
    new_lexicon[word] = []
    
    
    for phon_trans in libri_lexicon[word]:
        new = []
        for phon in phon_trans:
            if phon in unified_map:
                new.append(unified_map[phon])
            else:
                new.append(phon)
        new_lexicon[word].append(" ".join(new))
        new_lexicon[word] += get_mis_pronuciations(phon_trans)
        # print(get_mis_pronuciations(phon_trans))

# print(new_lexicon)
file_write = open('extended_lexicon_final.txt','w',encoding='utf8')
for word in new_lexicon:
    if len(new_lexicon[word]) != 0:
        for phone_trans in new_lexicon[word]:
            # print(phon_trans)
            # print(phone_trans)
            file_write.write(word+"\t"+phone_trans+"\n")
file_write.close()
print("Completed successfully...")
   
