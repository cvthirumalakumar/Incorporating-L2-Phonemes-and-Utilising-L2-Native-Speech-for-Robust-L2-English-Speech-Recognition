#!/bin/bash
clear
#set-up for single machine or cluster based execution
. ./cmd.sh
#set the paths to binaries and other executables
[ -f path.sh ] && . ./path.sh
train_cmd=run.pl
decode_cmd=run.pl

test_sets="test_clean test_l2hindi"
dumpdir=dump
data_folder=data
mfccdir="$dumpdir/mfcc_$data_folder"
lmtags="EnglishUnified"
expdir=exp
dir=exp/chain_fmllr/tdnn_cnn_sp

set -e


for datadir in $test_sets; do 
    utils/fix_data_dir.sh ${data_folder}/$datadir
    utils/copy_data_dir.sh ${data_folder}/$datadir ${data_folder}/${datadir}_hires
done

for datadir in $test_sets; do 
    steps/make_mfcc.sh --nj 1 --mfcc-config conf/mfcc_hires.conf --cmd "$decode_cmd" \
        ${data_folder}/${datadir}_hires $expdir/make_mfcc/${datadir}_hires $mfccdir/${datadir}_hires || exit 1;
    utils/fix_data_dir.sh ${data_folder}/${datadir}_hires
    steps/compute_cmvn_stats.sh ${data_folder}/${datadir}_hires $expdir/make_mfcc/${datadir}_hires \
        $mfccdir/${datadir}_hires || exit 1;
done

for datadir in $test_sets; do 
    steps/online/nnet2/extract_ivectors_online.sh --cmd "$train_cmd" --nj 1 \
        ${data_folder}/${datadir}_hires $expdir/nnet3_fmllr/extractor \
        $expdir/nnet3_fmllr/ivectors_${datadir}_hires || exit 1;
done

for lmtype in $lmtags;do

    echo =========================== $lmtype ===========================
    graph_dir=$dir/graph${lmtype:+_$lmtype}

    utils/mkgraph.sh --self-loop-scale 1.0 --remove-oov ${data_folder}/lang_test_${lmtype} $dir $graph_dir

    for decode_set in $test_sets; do
        steps/nnet3/decode.sh --use-gpu false --acwt 1.0 --post-decode-acwt 10.0 --nj 1 --num-threads 4 \
            --cmd "$decode_cmd" --online-ivector-dir \
            $expdir/nnet3_fmllr/ivectors_${decode_set}_hires $graph_dir \
            ${data_folder}/${decode_set}_hires $dir/decode_${decode_set}_${lmtype} || exit 1;   
    done
    # for decode_set in $test_sets; do
    #     steps/lmrescore_const_arpa.sh \
    #         --cmd "$decode_cmd" data/lang_test_{$lmtype,pie_4} \
    #         data/${decode_set}_hires exp/chain_cleaned/tdnn_1d_sp/decode_${decode_set}_{$lmtype,pie_4}
    #     steps/lmrescore_const_arpa.sh \
    #         --cmd "$decode_cmd" data/lang_test_{$lmtype,wiked_4} \
    #         data/${decode_set}_hires exp/chain_cleaned/tdnn_1d_sp/decode_${decode_set}_{$lmtype,wiked_4}
    # done

    # for decode_set in $test_sets; do
    # steps/score_kaldi.sh --cmd "$decode_cmd" ${data_folder}/${decode_set}_hires $graph_dir $dir/decode_${decode_set}_$lmtype
    # done

    # for decode_set in $test_sets; do
    #     decode_dir=exp/chain_cleaned/tdnn_1d_sp/decode_${decode_set}_$lmtype;
    #     scripts/rnnlm/lmrescore_pruned.sh \
    #         --cmd "$decode_cmd" \
    #         --weight 0.45 --max-ngram-order 4 \
    #         data/lang_nosp_test_$lmtype exp/rnnlm_lstm_1a \
    #         ${data_folder}/${decode_set}_hires ${decode_dir} \
    #         ${dir}/decode_${decode_set}_${lmtype}_rnnlm_rescore
    # done

    # for score_set in $test_sets; do
    #     steps/get_ctm_conf.sh ${data_folder}/${score_set}_hires $graph_dir $dir/decode_${score_set}_${lmtype}
    # done	
done
