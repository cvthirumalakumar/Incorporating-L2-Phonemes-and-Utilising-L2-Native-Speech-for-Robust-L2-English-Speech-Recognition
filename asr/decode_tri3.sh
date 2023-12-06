#!/bin/bash
clear
#set-up for single machine or cluster based execution
. ./cmd.sh
#set the paths to binaries and other executables
[ -f path.sh ] && . ./path.sh

test_sets="test_l2hindi"
mfccdir=mfcc


# for part in test_clean test_l2hindi; do
#     steps/make_mfcc.sh --cmd "$train_cmd" --nj 1 data/$part exp_libri_360/make_mfcc/$part $mfccdir
#     steps/compute_cmvn_stats.sh data/$part exp_libri_360/make_mfcc/$part $mfccdir
# done

# echo "---------- exp_libri_360 ----------"
# # utils/mkgraph.sh data/lang_test_LibriSmall \
# #     exp_libri_360/tri3 exp_libri_360/tri3/graph_LibriSmall
# for test in $test_sets; do
#     steps/decode_fmllr.sh --nj 4 --cmd "$decode_cmd" \
#         exp_libri_360/tri3/graph_LibriSmall data/${test} exp_libri_360/tri3/decode_LibriSmall_$test
# done



echo "---------- exp ----------"

# for part in test_clean test_l2hindi; do
#     steps/make_mfcc.sh --cmd "$train_cmd" --nj 4 data/$part exp/make_mfcc/$part $mfccdir
#     steps/compute_cmvn_stats.sh data/$part exp/make_mfcc/$part $mfccdir
# done
# utils/mkgraph.sh data/lang_test_EnglishUnified \
#     exp/tri3 exp/tri3/graph_EnglishUnified
for test in test_clean; do
    steps/decode_fmllr.sh --nj 40 --cmd "$decode_cmd" \
        exp/tri3/graph_EnglishUnified data/${test} exp/tri3/decode_EnglishUnified_$test
done
for test in test_l2hindi; do
    steps/decode_fmllr.sh --nj 4 --cmd "$decode_cmd" \
        exp/tri3/graph_EnglishUnified data/${test} exp/tri3/decode_EnglishUnified_$test
done