#! /bin/bash
################################################################
#   BSD LICENSE
#
#   Copyright(c) 2007-2023 Intel Corporation. All rights reserved.
#   All rights reserved.
#
#   Redistribution and use in source and binary forms, with or without
#   modification, are permitted provided that the following conditions
#   are met:
#
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in
#       the documentation and/or other materials provided with the
#       distribution.
#     * Neither the name of Intel Corporation nor the names of its
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
#   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
#   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
#   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
#   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
#   OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
#   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
#   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
#   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
#   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
################################################################

set -e
echo "***QZ_ROOT run_perf_test.sh start"

rm -f result_comp_stderr
rm -f result_decomp_stderr

CURRENT_PATH=`dirname $(readlink -f "$0")`
QZ_ROOT=$CURRENT_PATH/../..

#Perform performance test
echo "Perform performance test"
thread=4
thread=1
process=20

echo > result_comp
cpu_list=0
for((numProc_comp = 0; numProc_comp < $process; numProc_comp ++))
do
    taskset -c $cpu_list sudo $QZ_ROOT/test/test -P busy  -m 4 -l 1000 -t $thread -D comp  >> result_comp 2>> result_comp_stderr &
    cpu_list=$(($cpu_list + 1))
done
wait
compthroughput=`awk '{sum+=$8} END{print (sum/8)*1000}' result_comp`
echo "compthroughput=$compthroughput MB/s"

echo > result_decomp
cpu_list=0
for((numProc_decomp = 0; numProc_decomp < $process; numProc_decomp ++))
do
    taskset -c $cpu_list sudo $QZ_ROOT/test/test -P busy -m 4 -l 1000 -t $thread -D decomp  >> result_decomp 2>> result_decomp_stderr &
    cpu_list=$(($cpu_list + 1))
done
wait
decompthroughput=`awk '{sum+=$8} END{print (sum/8)*1000}' result_decomp`
echo "decompthroughput=$decompthroughput MB/s"
