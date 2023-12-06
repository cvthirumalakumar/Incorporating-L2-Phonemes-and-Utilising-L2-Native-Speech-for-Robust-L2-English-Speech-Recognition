# Incorporating-L2-Phonemes-and-Utilising-L2-Native-Speech-for-Robust-L2-English-Speech-Recognition-

This is a course project. Main goal of the project is to implement the method presented in the [paper](https://www.isca-speech.org/archive/pdfs/interspeech_2023/wang23e_interspeech.pdf) for building efficient L2 English ASR. In the paper authors extended the english lexicon using phoneme transfer rules obtained from some linguistic studies and unified phonemes from English and native language of L2 English learners, then trained Acoustic Model with both native L1 speech corpus and native L2 speech corpus. The intution behind using L2 native langauge is to show the acusic realisation of L2 phonemes and train the AM to recognise L2 phonemes well while showing L2 english mispronunciations paired with L1 speech. Refer to paper mentioned to know more details.

#Experimental setting
In the paper authors implemented the method for Korean speakers. In this project I have implemented for Hindi speakers speaking English. More details about the expeiments and results can be found in `report.pdf`

Experiments are conducted using kaldi toolkit. And Hindi Lexicon is generated using [Unfied-Parser](https://www.iitm.ac.in/donlab/tts/unified.php). Extended lexicon is genereated based on the phoneme transfer rules mentioned in [Indic TIMIT](https://ieeexplore.ieee.org/document/9041230) paper using custom python script. generated Hindi lexicon and extended lexion are found in `asr/data/local/lexicons`
