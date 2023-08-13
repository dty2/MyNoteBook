# 配置
### 配置内容
##### 输入法
参考[博客](https://muzing.top/posts/3fc249cf/)和[视频](https://www.bilibili.com/video/BV1tY411q7f1/?spm_id_from=333.999.0.0)  
##### 代理
参考[博客](https://www.junz.org/post/v2_in_linux/)和[白话文教程](https://toutyrater.github.io/)  
详见[Proxy NoteBook](https://hunters-notebook.gitbook.io/proxy-notebook/basic)
##### zsh
详见[Shell Notebook](https://hunters-notebook.gitbook.io/shell-notebook/)  
##### Vim
详见[Vim NoteBook](https://hunters-notebook.gitbook.io/vim-notebook/)
##### QQ
  1. 打开QQ官网网站，下载Linux版本QQ安装包
  2. `sudo dpkg -i linuxqq_3.1.2-13107_amd64.deb` 安装QQ
##### Vmware  
  1. 打开Vmware官网网站，下载Linux版本的Vmware Player(free的)  
  2. 加执行权限，执行安装  
     ``` bash shell   
     chmod +x VMware-Player-Full-17.0.2-21581411.x86_64.bundle
     ./VMware-Player-Full-17.0.2-21581411.x86_64.bundle
     ```  
  3. 运行Vmware Player，会遇到问题`C header files matching your running kernel were not found`，通过安装头文件来解决`sudo apt install --reinstall linux-headers-$(uname -r)`。安装之后需要重启  
  4. 重启后重新运行Vmware Player，会遇到问题`unable to install all modules vmware`。通过执行`sudo vmware-modconfig --console --install-all`来解决。执行上述指令之后需退出之前打开的Vmware Player，并重新打开Vmware Player重试即可。 
  5. Vmware的首次启动配置，一直接受即可，个人不选择更新和接受跟踪反馈用户信息服务  
##### Gnome 美化  
参考[视频](https://www.bilibili.com/video/BV1KR4y127dR/?spm_id_from=333.1007.top_right_bar_window_history.content.click&vd_source=8836eda798f42e634172036484104534)  
  * [Gnome-extension](https://extensions.gnome.org/) 初次登陆需要安装该扩展到Firefox   
    - 插件：  
      1.  User Themes : 从user目录中加载shell主题
      2.  Dash to Dock : 一个在桌面底部的Dock
      3.  Desktop Cube : 3D切换workspace
      4.  Aylur's Widget : 状态栏
    - 配置插件置只须点击插件开关旁边的button，也可通过本地(自带)扩展进行配置  
  * Cursor theme: [Nordzy-cursors](https://github.com/alvatip/Nordzy-cursors)  
  * Icon theme: [Nordzy-icon](https://github.com/alvatip/Nordzy-icon)
  * User theme: [WhiteSur-gtk-theme](https://github.com/vinceliuice/WhiteSur-gtk-theme)  
  * FAQ:  
    - Q1: Auto move windows 会影响正常的workspace使用，具体导致其dynamic workspace失效，[issue](https://gitlab.gnome.org/GNOME/gnome-shell/-/issues/290) is here!  
    - Q2: Icon theme的安装脚本好像有些问题，会出现以下报错。这边建议直接通过[压缩包](https://www.pling.com/s/Gnome/p/1686927)解压，手动安装  
    `sed：无法读取 /home/hunter/.local/share/icons/Nordzy-dark/actions/32/dialog-selectors.svg`  
