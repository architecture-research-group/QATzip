#!/bin/bash


#baseline
# sudo ./../../../pcm/build/bin/pcm-memory  -csv=baseline_bw.csv -nc 0.01 -- sleep 1

# numcores=( 1 2 5 10 )
numcores=( 1 2 5 10 )
for i in ${numcores[@]};
do
    # cstring=$( seq 10 $(( 10 + $i - 1 )) | tr -s '\n' ',' | sed 's/,$//g' )
    append=$(seq 20 $(( 20 + $i - 1 )) | tr -s '\n' ' ')
    sudo ../../../pcm/build/bin/pcm-memory 0.01 -nc -csv=dcu_${i}_concurrent_bw.csv -- parallel numactl -C{} -m1 ../mt_membw_test -B0 -P busy -l1000 -m 4 -t 1 -i ../../../HyperCompressBench/extracted_benchmarks/ZSTD-DECOMPRESS/009253_cl10_ws22 -D decomp ::: $append
    #2M file to exceed Cache && drive mb: ../../../HyperCompressBench/extracted_benchmarks/ZSTD-DECOMPRESS/000005_cl0_ws10
    # 4M file: ../../../HyperCompressBench/extracted_benchmarks/ZSTD-DECOMPRESS/009253_cl10_ws22
done

# sudo ./../../../pcm/build/bin/pcm-memory -csv=pcm.out -nc 0.01 -- parallel numactl -C{} -m1 ../test -B0 -P busy -l1000 -m 4 -t 1 -i ../../../HyperCompressBench/extracted_benchmarks/ZSTD-DECOMPRESS/000005_cl0_ws10