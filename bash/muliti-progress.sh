#!/bin/bash

# 创建管道文件
mkfifo fifofile

# 创建文件描述符 1000 ，以读写方式操作管道文件 fifofile
exec 1000<> fifofile

# 删除管道文件 fifofile
rm fifofile

# 4 为并发进程数，生成 4 行数据，交给文件描述符，此时管道文件中也会有 4 行数据
seq 1 4 1>& 1000

for i in `seq 1 24`;do

#read -u 从文件描述符中读取数据，每次读取一行，管道中减少一行，当读完设置的 4行数据之后，再次读取进入阻塞状态，限制进程数量
  read -u 1000
  {
    # 要执行的一组任务，在花括号中，
    echo "success progress $i";
    # 为了测试效果 sleep
    sleep 2;
    # 当任务执行完毕之后往描述符中插入一个空行，保持管道中占位行一直为 4 行
    echo >& 1000
  } & # & 存放在后台执行，每循环一次，管道中的行 -1
done

#等待所有进程完成，最后退出
wait

# 关闭文件描述符写
exec 1000>&-
# 关闭文件描述符读
exec 1000<&-
