安装详情见[官方教程](https://learn.microsoft.com/zh-cn/windows/wsl/install-manual#step-4---download-the-linux-kernel-update-package)

FAQ:
Q1:
无法将磁盘“C:\Users\dongt\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu22.04LTS_79rhkp1fndgsc\LocalState\ext4.vhdx”附加到 WSL2： 系统找不到指定的文件。Error code: Wsl/Service/CreateInstance/MountVhd/HCS/ERROR_FILE_NOT_FOUND  
A*5:
* 检查磁盘文件
  打开磁盘管理工具并查看是否可以找到ext4.vhdx文件3。
* 装载磁盘文件
  如果找到该文件，请尝试装载它3。
* 重启电脑
  如果找不到该文件或无法装载它，你可以尝试重启电脑以重置Ubuntu子系统3。
* 重新启用WSL2
  如果问题仍然存在，你可以尝试以管理员身份运行PowerShell，并运行以下命令：`Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux`。这将重新启用WSL2，并可能解决无法附加磁盘的问题3。
* 注销并重新安装子系统
  在PowerShell上，先查看还有哪些子系统：`wsl --list --all`，然后注销子系统：`wsl --unregister Ubuntu-22.04`，然后重新安装就好了

**A5解决问题**

Q2:WSL2配合V2rayN使用  
A:
* 开启V2rayN的局域网连接
首先，你需要在Windows的V2rayN客户端上开启允许来自局域网的连接2。
* 获取Windows的IP地址
在WSL2中，你需要找到Windows的IP地址。你可以在Ubuntu子系统中通过运行以下命令来查看DNS服务器IP，这个IP就是Windows的IP1：`cat /etc/resolv.conf`。你会看到类似于nameserver 172.19.80.1的输出，其中172.19.80.1就是Windows的IP地址1。
* 设置WSL2的代理
然后，你需要在WSL2中设置代理。你可以通过设置环境变量ALL_PROXY来实现1：
`export ALL_PROXY="http://172.19.80.1:7890"`。其中，172.19.80.1是你刚刚获取到的Windows的IP地址，7890是V2rayN客户端的端口1。

配置脚本
``` bash
#!/bin/bash
getip=$(cat /etc/resolv.conf | grep "nameserver" | cut -f 2 -d " ")
echo 'export ALL_PROXY="http://'$getip':10808"' >> ~/.bashrc
```

Q3: Proxy CONNECT aborted
hunter@Hunter:~$ tldr --update
Cloning into 'tldr'...
fatal: unable to access 'https://github.com/tldr-pages/tldr.git/': Proxy CONNECT aborted
tldr: Received ExitFailure 128 when running
Raw command: git clone https://github.com/tldr-pages/tldr.git
Run from: /home/hunter/.local/share/tldr  
A:
设置git代理
``` bash
git config --global http.proxy http://172.17.0.1:10809
git config --global http.proxy https://172.17.0.1:10809
```
其中我的代理服务器地址为什么是172.17.0.1？因为这是在wsl2中使用windows中的V2rayN，所以代理服务器地址应该是我的Windows的IP地址，通过`cat /etc/resolv.conf`查询

Q4:curl: (56) Proxy CONNECT aborted  
A:
``` bash
export http_proxy=http://172.17.0.1:10809
export https_proxy=http://172.17.0.1:10809
```
