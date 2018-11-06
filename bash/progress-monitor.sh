#!/bin/bash
CPU_CURRENT_USAGE=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)}END{printf ("%.2f\n",usage)}')
MEM_TOTAL=$(grep 'MemTotal' /proc/meminfo |awk '{printf ("%.2f\n",$2/1024)}')
MEM_AVAILABLE=$(grep 'MemAvailable' /proc/meminfo |awk '{printf ("%.2f\n",$2/1024)}')
MEM_CURRENT_USAGE=$(echo "scale=2;(${MEM_TOTAL}-${MEM_AVAILABLE})/${MEM_TOTAL}*100"|bc)
CPU_CORES=$(grep -c 'processor' /proc/cpuinfo)
LOAD_AVG_1MIN=$(uptime|awk -F '[:,]' '{print $8 }')
CPU_MAX=10
MEM_MAX=60
DATE=$(date '+%F')

echo_date(){
echo "====================$(date '+%F %H:%M:%S') ====================" 
}

mem_check(){
MEM_VALUE=$(echo "${MEM_CURRENT_USAGE} > ${MEM_MAX}"|bc)
if [ ${MEM_VALUE} -eq 1 ];then
    echo_date >> /var/log/high-memory-${DATE}.log 
    pidstat -p ALL -r -l|sort -k9,9rn|head -10 >> /var/log/high-memory-${DATE}.log
fi
}

cpu_check(){
CPU_VALUE=$(echo "${CPU_CURRENT_USAGE} > ${CPU_MAX}"|bc)
if [ ${CPU_VALUE} -eq 1 ];then
   echo_date >> /var/log/high-cpu-${DATE}.log
   pidstat -p ALL -l|sort -k8,8rn|head -10 >> /var/log/high-cpu-${DATE}.log
fi
}

io_check(){
LOAD_VALUE=$(echo "${LOAD_AVG_1MIN} > ${CPU_CORES}"|bc)
if [ ${CPU_VALUE} -eq 1 ];then
   echo_date >> /var/log/high-io-${DATE}.log
   pidstat -p ALL -d -l|sort -k5,5rn|head -10 >> /var/log/high-io-${DATE}.log
fi
}

while true;do
    mem_check
    cpu_check
    io_check
    sleep 30
done
