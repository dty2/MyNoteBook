.PHONY : clean 伪目标，防止与文件同名
.RECIPEPREFIX = > 使用>代替命令前的tab
.ONESHELL: 每行命令都在一个shell中执行

@ 关闭回声
- 忽略错误

自动变量:
$@:代指构建目标 
$<:代指第一个前置条件
$?:代指比目标更新的所有的前置条件
$^:代指所有的前置条件

函数:
addprefix a,b:
作用:将a作为前缀加到b前面

wildcard a:
作用: 在a中使用bash通配符

patsubst a,b,c:
介绍: pattern substiture string 模式替换字符串
作用: 替换c中的a成b

filter a, b:
作用: 过滤出b中含有a的内容，并返回b
filter-out a, b:
作用: 剔除b中含有a的内容，并返回b

文件搜寻:
vpath %.h ../headers .h文件在../headers目录下搜索

赋值运算符:
= 运行时扩展
:= 在定义时扩展
?= 在变量为空时设置值
+= 追加


变量替换引用:
foo := a.o b.o c.o
bar := $(foo:.o=.c)
bar: a.c b.c c.c

区别shell与makefile中的变量引用
shell:
\$(echo hello) 或者是 `echo hello` 为命令引用
\$xxx 或者是 \${} 为变量引用
makefile: \$() 变量引用

区别通配符与正则表达式
makefile或shell: *表示通配符，% 是匹配符
regex: .表示通配符，* 则表示匹配任意次数

Example:
``` Makefile
# Makefile内容
NAME=
HOME = /home/hunter

WORK_DIR=$(shell pwd)
BUILD_PATH = $(WORK_DIR)/scripts/build.mk

.PHONY: run gdb clean

include $(BUILD_PATH)

IMG += 
ARGS +=
EXEC := $(BINARY) $(ARGS) $(IMG)

run-env: $(BINARY)

run: run-env
	@echo "run: $(EXEC)"
	@$(EXEC)

gdb: run-env
	gdb -s $(BINATY) --args $(EXEC)

clean:
	-rm -rf $(BUILD_DIR)
```

``` Makefile
# build.mk内容
# compilation flags
CC := gcc
LD := gcc

# Add necessary options if the target is a shared library
CFLAGS += -g
LDFLAGS += 

# DIR
BUILD_DIR = $(WORK_DIR)/build
OBJ_DIR = $(BUILD_DIR)/obj-$(NAME)

INC_DIR = $(WORK_DIR)/include 
SRC_DIR = $(WORK_DIR)/src

# FILE
BINARY = $(BUILD_DIR)/$(NAME)
INCLUDES = $(addprefix -I, $(INC_DIR))
SRCS = $(wildcard $(SRC_DIR)/*.c)
OBJS = $(SRCS:%.c=$(OBJ_DIR)/%.o)

# Compilation flags
CFLAGS := -O2 -Wall $(INCLUDES)
LDFLAGS := -O2 $(LDFLAGS)

$(BINARY): $(OBJS)
	@echo + LD $@
	@$(LD) $(LDFLAGS) $(OBJS) -o $@

$(OBJ_DIR)/%.o: %.c
	@echo + CC $<
	@mkdir -p $(dir $@)
	@$(CC) $(CFLAGS) -c $< -o $@
```
