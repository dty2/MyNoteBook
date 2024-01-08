## 构建VIM
1.配置参数  
``` bash shell
    ./configure \
    --with-features=huge \
    --enable-fontset \
    --enable-python3interp \
    --with-python3-command=python3
```
2.查询cpu数量`cat /proc/cpuinfo | less` (ps:查看逻辑cpu数量)  
3.`sudo make -j8` + `sudo make install`  (ps:看vim官方编译教程，上面要求命令执行在固定位置)
4.查看Vim版本`vim --version`,看是否有+python3，如果有则构建成功

FAQ:
Q1. no terminal library found
checking for tgetent()... configure: error: NOT FOUND!
      You need to install a terminal library; for example ncurses.
      On Linux that would be the libncurses-dev package.
      Or specify the name of the library with --with-tlib.
make[1]: *** [Makefile:1972: config] Error 1
make[1]: Leaving directory '/home/hunter/vim/src'
make: *** [Makefile:2000: reconfig] Error 2

A:缺少一个依赖库，安装上就行了`sudo apt-get install libncurses-dev`

Q2:构建失败删除VIM删不了
A:进如`/user/local/bin`中删除vim，之后再删除之前构建vim的vim目录，别忘了使用sudo
