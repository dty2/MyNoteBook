PUBLIC: 本目标需要使用,依赖这个目标的目标也需要使用
INTERFACE: 本目标不需要使用,依赖这个目标的目标需要使用
PRIVATE: 本目标需要使用,依赖这个目标的目标不需要使用

XXXConfig.in.h中的cmakedefine和define区别:
define的无论值为什么都显示
cmakedefine在值为OFF/FALSE,0和未定义的变量时不会定义

XXXConfig.h和XXXConfig.in.h:
cmake对后者进行处理并拷贝到前者中

Example:
``` CMake
cmake_minimum_required(VERSION 3.10) 
# 设置cmake的版本

project(Tutorial VERSION 1.0) 
# 设置项目名字和版本

set(CMAKE_CXX_STANDARD 11) 
# 设置C++的标准
set(CMAKE_CXX_STANDARD_REQUIRED True)
# 当当前标准不满足时,自动退回上一个版本

option(USE_MYMATH "Use tutorial provided math implementation" ON)
# 自定义宏,默认ON,用于手动打开或者关闭某宏定义

configure_file(TutorialConfig.h.in TutorialConfig.h)
# 配置头文件将CMake中的内容传递到C++文件中

if(USE_MYMATH) 添加函数库文件
  add_subdirectory(MathFunctions)
  list(APPEND EXTRA_LIBS MathFunctions)
endif()

add_executable(Tutorial tutorial.cxx) 
# 添加可执行文件

target_link_libraries(Tutorial PUBLIC ${EXTRA_LIBS}) 
# 目标文件链接库

# add the binary tree to the search path for include files
# so that we will find TutorialConfig.h
target_include_directories(Tutorial PUBLIC
                           "${PROJECT_BINARY_DIR}"
                           )
```
