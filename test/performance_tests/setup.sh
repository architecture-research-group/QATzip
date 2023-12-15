#!/bin/bash
ICP_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"/../../../QAT20.L.1.0.50-00003
set -e
CURRENT_PATH=`dirname $(readlink -f "$0")`
process=48
\cp $CURRENT_PATH/config_file/4xxx/4xxx*.conf /etc

service qat_service restart
echo 1024 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
rmmod usdm_drv
insmod $ICP_ROOT/build/usdm_drv.ko max_huge_pages=1024 max_huge_pages_per_process=24
sleep 5