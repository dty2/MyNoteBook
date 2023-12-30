# 安装 
## 准备安装(Windows + Kali)
硬件：U盘 计算机  
软件：[操作系统映像文件](https://www.kali.org/get-kali/#kali-platforms) 烧录软件([Rufus](https://rufus.ie/en/#))
## 主要步骤
1. 在Windows中使用Rufus烧录映像文件到U盘中  
2. 在Windows的磁盘管理中划分空间给另一个操作系统
3. 重启，在引导界面选择U盘引导
4. 安装系统
## FAQ
Q1：Kali官网教程使用Live中的Gparted对磁盘进行分区管理，但是由于BitLock原因，我们无法在Gparted对磁盘进行分区管理操作  
A：我们不需要按照官网的指示用Live的Gparted，只需要在windows中使用磁盘管理的选项**压缩卷**将空闲分区压缩成未分配分区即可  

Q2：本电脑涉及安全启动问题，在引导项里无U盘启动选项(即使有，在安装kali之后也会出现无该启动项，或者是无法启动kali的问题)  
A：只需在BIOS中将安全启动即**security boot**设置为**disable**即可(温馨提示：想要运行windows需要打开该选项)

Q3：在安装Kali过程中，可能会遇到**选择并安装软件失败**  
A：这是由于源地址是在国外，只需换源即可  
这里在安装软件失败后会让你跳入其他步骤，这里我们跳入到shell步骤并进入shell
``` bash shell
chroot /target
nano /etc/apt/sources.list

deb http://mirros.ustc.edu.cn/kali kali-rolling main non-free contrib
#这里按ctrl + o(保存),回车和ctrl + x(退出)

apt-get update
apt-get upgrade
apt-get disk-upgrade
apt-get clean
apt-get autoclean

exit #退出x2
```

# 卸载
1. 在windows的磁盘管理中删除kali对应的磁盘分区
2. 以管理员身份打开终端(win + r运行cmd,按下ctrl + shift + enter)， 使用命令行删除kali启动文件
``` bash shell
diskpart
list disk
select disk 0 # 只有0号盘，那就选0号盘，如果有其他盘，根据你kali安装的位置来进行选择
list partition
select partition 1 # 选择系统所在分区
assign letter=x # 给当前分区打上标签，为了一会退出之后方便重新进入
exit
x:
dir
cd efi # 选择EFI(启动程序)
dir
rd kali /S # 删除kali
Y # 确认
```
[教程视频](https://www.bilibili.com/video/BV1Ba411z75z/?spm_id_from=333.999.0.0)
