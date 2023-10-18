孤儿进程与僵尸进程
僵尸进程：由于子进程先于父进程退出导致死了之后其PCB没有被父亲释放
孤儿进程：子进程后于父进程退出导致其在活着的时候没有父亲,在linux中，这样的进程被init进程收留。

守护进程：
Daemon Process,即Daemon进程(精灵进程)
用户守护进程: 孤儿进程，其父进程为init(ID:1)
内核守护进程：...

UID,PID,PPID,SID,TTY,TPGID,STAT:
UID: User Identify Document 用户标识
PID: Processes Identify Document 进程标识
SID: Session Identify Document 会话标识
TTY: Terminal Type 终端类型
STAT: process Stauts 进程状态
PPID: Parent Process Identify Document 父进程标识
TPGID: Terminal Process Group Identify Document 终端进程组标识

