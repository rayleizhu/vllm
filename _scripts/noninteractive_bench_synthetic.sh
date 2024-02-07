#!/bin/bash

# set -x

# work load config
IOs=( "64,128" "128,256" "256,512" )
# IOs=( "256,512" )
PREFIX_LENs=( 512 1024 2048 256 128 64 )
# PREFIX_LENs=( 1024 )
NUM_REQS=1000

# llama2 30B config
MODEL=meta-llama/Llama-2-13b-hf

GPU=$( nvidia-smi --query-gpu=name --format=csv | tail -n1 | tr ' ' '-' )
NOW=$(date "+%Y-%m-%d-%H.%M.%S")

for IO in ${IOs[@]}; do
    # echo $IO
    IFS=',' read CONTEXT_LEN OUTPUT_LEN <<< "${IO}"
    # echo $CONTEXT_LEN $OUTPUT_LEN
    for PREFIX_LEN in ${PREFIX_LENs[@]}; do
<<<<<<< HEAD
        # model_id=$(echo "$MODEL" | tr '/' '.')
        # model_id=${MODEL#*/}
        model_id=$( basename $MODEL )
        # echo $model_id
        OUTPUT_DIR=outputs/noninteractive_bench_synthetic/${GPU}/${model_id}/nreqs_${NUM_REQS}.ctxlen_${CONTEXT_LEN}.outlen_${OUTPUT_LEN}.prefixlen_${PREFIX_LEN}.backend_vllm+pc
        mkdir -p $OUTPUT_DIR
        python benchmarks/benchmark_throughput.py \
            --num-prompts $NUM_REQS \
            --input-len $CONTEXT_LEN \
            --output-len $OUTPUT_LEN \
            --output-dir $OUTPUT_DIR \
            --prefix-len $PREFIX_LEN \
            --model $MODEL \
            --load-format dummy \
            --backend vllm+ \
            2>&1 | tee -a $OUTPUT_DIR/${NOW}.log
        sleep 1
=======
        for BACKEND in ${BACKENDs[@]}; do
            # model_id=$(echo "$MODEL" | tr '/' '.')
            model_id=${MODEL#*/}
            # echo $model_id
            OUTPUT_DIR=outputs/noninteractive_bench_synthetic/${GPU}/${model_id}/nreqs_${NUM_REQS}.ctxlen_${CONTEXT_LEN}.outlen_${OUTPUT_LEN}.prefixlen_${PREFIX_LEN}.backend_${BACKEND}
            mkdir -p $OUTPUT_DIR
            python benchmarks/benchmark_throughput.py \
                --num-prompts $NUM_REQS \
                --input-len $CONTEXT_LEN \
                --output-len $OUTPUT_LEN \
                --output-dir $OUTPUT_DIR \
                --prefix-len $PREFIX_LEN \
                --model $MODEL \
                --backend $BACKEND \
                --load-format dummy \
                2>&1 | tee -a $OUTPUT_DIR/${NOW}.log
            sleep 1
        done
>>>>>>> dev_relay_transparent
    done
done
