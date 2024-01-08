# 桌面环境
* 简单配置：Gnome  
* 折腾配置：i3  
## Gnome 美化(转战i3)  
* 参考[视频](https://www.bilibili.com/video/BV1KR4y127dR/?spm_id_from=333.1007.top_right_bar_window_history.content.click&vd_source=8836eda798f42e634172036484104534)  
* [Gnome-extension](https://extensions.gnome.org/)初次登陆需要安装[Mozilla Addons](https://addons.mozilla.org/en-US/firefox/addon/gnome-shell-integration/)扩展到Firefox和本地连接器`$ sudo apt install chrome-gnome-shell`温馨提示：基本上默认都带，无需安装   
  - 插件: 
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
    `sed:无法读取 /home/hunter/.local/share/icons/Nordzy-dark/actions/32/dialog-selectors.svg`  

## i3 全家福 
### 第一版
* i3 + polybar + picom + rofi + alacritty + ...
* 配置i3
  - 安装i3 + 删除i3status:  
    `sudo apt install i3` + `sudo apt remove i3status` 删除默认的status(因为我们选用tolybar，所以就不用i3带的status了)  
  - 控制硬件:  
    - 亮度light(无配置)  
    - 音量pluseaudio(无配置)  
  - variety + feh 换壁纸(无配置):  
    `sudo apt install variety` + `sudo apt install feh` variety 一个管理壁纸的工具，variety想要在i3上运行需要feh或者是nitrogen的支持(参考脚本里的内容 `For simple WMs, use either feh or nitrogen`) 类似的解决问题方案如[油管视频](https://www.youtube.com/watch?v=zplxmG8Y-XU)   
  - i3lock-color:  
    原生i3lock不支持色彩等设定，因此这里我们选择手动编译github上的[i3lock-color](https://github.com/Raymo111/i3lock-color)  
    1. 配置依赖(温馨提示:这是Debain的依赖)  
    `sudo apt install autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util0-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev`(小声bb: 宝宝级别的依赖了，从编译器到链接器，啥都有)  
    2. `./build.sh` + `./install-i3lock-color.sh`  
    3. 配置[脚本]()lock* ，将脚本放置到 `~/.config/i3` 目录下。  
  - 配置config，在 `~/.config/i3` 中添加config文件  
  - 添加其他脚本到`~/.config/i3` 目录下  
    - bootpolybar*  
    - rt* (roggle touchpad)   
* 配置polybar  
  - 安装polybar `sudo apt install polybar`  
  - 配置

* 配置rofi
  - 配置文件

* FAQ:  
  - Q1: 为什么需要light，pluseaudio，polybar等软件?  
    A1: 因为i3只是个窗口管理器，没有其他功能。所以 ，电源，音量等调节控制需要额外的控制软件进行控制。  

第一版结束：第一次尝试，大致都搞明白了，但是还是没完全搞通，而且文档也没有坚持同时写，因此只能到此为止了，但是还没完之后还会再战，所以说期待第二版的到来。
