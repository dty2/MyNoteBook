# 配置
### 配置内容
* Linux
  - 输入法
  - 代理
  - Vim
  - QQ
  - Vmware
* Windows(Vmware)
#### 输入法
参考[博客](https://muzing.top/posts/3fc249cf/)和[视频](https://www.bilibili.com/video/BV1tY411q7f1/?spm_id_from=333.999.0.0)
#### 代理
参考[博客](https://www.junz.org/post/v2_in_linux/)和[白话文教程](https://toutyrater.github.io/)  
详见[Proxy NoteBook](https://hunters-notebook.gitbook.io/proxy-notebook/basic)
#### Vim
详见[Vim NoteBook](https://hunters-notebook.gitbook.io/vim-notebook/)
#### QQ
1. 打开QQ官网网站，下载Linux版本QQ安装包
2. `sudo dpkg -i linuxqq_3.1.2-13107_amd64.deb` 安装QQ
#### Vmware  
1. 打开Vmware官网网站，下载Linux版本的Vmware Player(free的)  
2. 加执行权限，执行安装  
   ``` bash shell   
   chmod +x VMware-Player-Full-17.0.2-21581411.x86_64.bundle
   ./VMware-Player-Full-17.0.2-21581411.x86_64.bundle
   ```  
3. 运行Vmware Player，会遇到问题`C header files matching your running kernel were not found`，通过安装头文件来解决`sudo apt install --reinstall linux-headers-$(uname -r)`。安装之后需要重启  
4. 重启后重新运行Vmware Player，会遇到问题`unable to install all modules vmware`。通过执行`sudo vmware-modconfig --console --install-all`来解决。执行上述指令之后需退出之前打开的Vmware Player，并重新打开Vmware Player重试即可。 
5. Vmware的首次启动配置，一直接受即可，个人不选择更新和接受跟踪反馈用户信息服务  
