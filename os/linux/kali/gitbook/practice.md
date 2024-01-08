---
git rm -rf --cached .
清除git缓存
用于在.gitignore 添加了新内容(之前不在.gitignore中却已经提交过)之后不生效

---
tree:
-d 只显示目录
-L x 显示到x级目录

---
tldr:
too long don't read
更加精简的man，实战版man
ps:刚下载的话需要更新tldr --update

---
gcc:
For c:
![Alt text](image.png)

C标准:
-std=c89 / -std=iso9899:1990
-std=iso9899:199409
-std=c99 / -std=iso9899:1999

编译器: gcc,g++,clang,clang++
debug: gdb
archiver: ar

预处理:
-E: 预处理 (ps:需要使用-I指定头文件目录)

编译选项:
编译:
-S: 编译成.s
-pg: gprof选项
-I: 指定头文件目录
-c: 编译不链接
-o: filename 指定.o文件名
-v: 显示编译器调用的程序
-g: debug选项
-DNAME=VALUE: 定义宏,没有值时则默认为1 
-save-temps: 保存.i和.s文件

警告:
-Wall: woring all
-Wcomment 检测注释是否嵌套 更好的注释办法: 使用#if 0 ... #endif
-Wformat 使用scanf和printf时检查格式字符串是否匹配
-Wunused 检测未使用的变量
-Wimplicit 使用未声明函数
-Wreturn-type 函数类型不是void但是没有返回值
ps:以上是常见的警告

标准:
-ansi: 禁用gcc扩展
-pedantic: 严格遵守ISO C和ISO C++的标准
ps:不加则默认"方言"

链接:
-o 指定ELF文件名

优化:
o[0-3]: 三个等级,一般o0debug,o2投产即可
-funroll-loops: Loop Unrolling优化

source-level optimization:
CSE: 存储已经计算过的值来同时减少代码量和执行速度
FL: 内嵌函数,适用于经常被调用且代码量不多的函数
Loop Unrolling: 减少循环判断(空间换时间)

machine-level optimization:
scheduling: 新指令可在上一指令没结束前就可执行(前提是没有影响),在保证正确的情况下,最大化并行执行(提高速度,不增加空间,但是由于算法复杂耗费编译时间)

For c++:
gcc直接将c++编译成汇编语言
大多数编译器都是将c++转化为c,再转化为汇编
链接c++ objectfiles时应使用g++,而不是gcc,因为使用gcc会连接c的标准库
很多c的编译链接选项也可用到c++的编译链接中
.cpp .cc .cxx都指代c++程序
.ii c++的".i"文件

---
gcov:
查看程序中每一行执行的时间,用于优化
使用前gcc编译需加-fprofile-arcs -ftest-coverage参数
编译之后会产生新文件:xxx.gcno
运行之后会产生新文件:xxx.gcda
使用gcov xxx.c后再次产生新文件xxx.c.gcov
打开xxx.c.gcov可看见每行执行次数

---
gprof:
检查函数执行时间的工具,用于优化程序
使用前gcc编译需加-pg参数
运行之后会产生新文件:gmon.out
使用gprof ./a.out查看信息

---
ldd:
查看可执行文件依赖哪些动态库

---
nm:
查看符号表
用于检查某个函数是否在某个目标文件中被定义
T: 函数被定义
U: 函数未被定义(动态库)

---
file:
用于显示文件类型
可执行文件:
linux: .out/ELF(Executable and Linking Format)
MS-DOS: COFF(Common Object File Format)
windows: .EXE(Execute)
静态库:
linux: .a (archive存档)
动态库:
linux: .so (shared object)
windows: .dll
LSB/MSB: 低位在前,高位在前 cpu理解字节顺序的方向, LSB:interl和AMDx86 MSB:Motorola
not stripped: 包含符号表,包含debug信息

---
time:
计算程序运行时间
time ./a.out
real: xxx
user: 用户态
sys: 内核态

---
nmcli:
networkmanager管理网络

---
fc-list:
显示当前系统所有可使用的字体
/usr/share/fonts/pc/Px_IBM_3270pc.ttf: Px IBM 3270pc:style=Regular
想使用以上字体,填入Px IBM 3270pc(即":"后的内容)

---
cmartix:
martix矩阵,黑客帝国里的代码流

---
ulimit: 
ulimit -c 查询是否允许产生core文件, 0不允许, unlimit不受限制(允许)
有关core dump(核心转储)文件(即程序崩溃之后产生的尸体,记录其在内存中的那时候的状态)

---
useradd 和 adduser
useradd 低级命令，具体需要指定具体内容
adduser 高级命令(小白使用)

sudo 使用权限
需要将想使用sudo命令的用户添加到sudoers文件或sudo组中
`usermod -aG sudo username`

第一次指定root密码
`sudo passwd root`
