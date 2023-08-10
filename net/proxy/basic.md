# 基础配置
## Windows Proxy
Windows下的代理软件我们选择V2rayN  
V2rayN是windows下V2ray的客户端程序  
由于其是图形界面，且其不用更改配置文件，因此是比较容易的。
### 配置  
1. 下载[V2rayN](https://github.com/2dust/v2rayN)  
2. 登入[订阅获取地](cnnic.pub)一键复制订阅地址
3. 打开v2rayN找到**订阅**, 打开**订阅设置**, 将复制内容粘贴到V2rayN中即可  
## Linux Proxy  
Linux下我们配置代理可以选择使用QV2ray  
QV2ray是Linux下V2ray的客户端程序  
由于其是图形界面，且其不用更改配置文件。因此相对于手动配置代理是比较容易的。  
但是既然都在linux环境下了，再用简单的方式去配置，心理着实有点过不去，因此这里我们选择手动配置。  
#### 前期准备
* 前提：至少粗率看过V2ray官方文档中提及的[白话文教程](https://toutyrater.github.io/)   
* 知识储备：参考白话文教程中前言的目标用户  
#### 手动配置(小白版)
基础版只让你在linux下的访问常见网址(浏览器和终端), 仅供网络小白使用  
这里选择纯手动配置，没有使用脚本  
* 找到[V2ray](https://github.com/v2ray/v2ray-core)中的发行版本(即releases)  
  安装相应版本的v2ray，这里是v2ray-linux-64.zip  
* 解压后将相应文件放置到对应路径，没有的文件在相应位置新建即可  
  ``` bash shell
  v2ray -> /usr/local/bin/v2ray
  v2ctl -> /usr/local/bin/v2ctl
  geoip.dat -> /usr/local/share/v2ray/geoip.dat
  geosite.dat -> /usr/local/share/v2ray/geosite.dat
  config.json -> /usr/local/etc/v2ray/config.json
  access.log -> /var/log/v2ray/access.log # 确保日志文件所有人都有读写权限
  error.log -> /var/log/v2ray/error.log # 确保日志文件所有人都有读写权限
  v2ray.service -> /etc/systemd/system/v2ray.service
  v2ray@.service -> /etc/systemd/system/v2ray@.service
  ```
* 配置config.json文件(可以将其他客户端的配置文件导出到这里使用)  
  温馨提示：这里在不懂网络知识的情况下，要选择导出其他客户端的配置文件，以免过多的配置问题  
  以下内容仅供参考(只需更改地址即可)  
  ``` json  
  {
    "log": {
      "access": "/var/log/v2ray/access.log",
      "error": "/var/log/v2ray/error.log",
      "loglevel": "warning"
    },
    "inbounds": [
      {
        "tag": "socks",
        "port": 10810,
        "listen": "127.0.0.1",
        "protocol": "socks",
        "sniffing": {
          "enabled": true,
          "destOverride": [
            "http",
            "tls"
          ]
        },
        "settings": {
          "auth": "noauth",
          "udp": true,
          "allowTransparent": false
        }
      }
    ],
    "outbounds": [
      {
        "tag": "proxy",
        "protocol": "vmess",
        "settings": {
          "vnext": [
            {
              "address": "这里填地址即可",
              "port": 80,
              "users": [
                {
                  "id": "ab4c04e1-cc44-4f59-af3e-3a7584e3ad65",
                  "alterId": 0,
                  "email": "t@t.tt",
                  "security": "auto"
                }
              ]
            }
          ]
        },
        "streamSettings": {
          "network": "ws",
          "wsSettings": {
            "path": "/",
            "headers": {
              "Host": "tms.dingtalk.com"
            }
          }
        }
      }
    ],
    "routing": { //国内直连
      "domainStrategy": "IPIfNonMatch",
      "rules": [
        {
          "type": "field",
          "inboundTag": [
            "api"
          ],
          "outboundTag": "api",
          "enabled": true
        },
        {
          "type": "field",
          "port": "0-65535",
          "outboundTag": "proxy",
          "enabled": true
        }
      ]
    }
  }
  ```  
* 终端实现代理  
  根据使用的shell, 将以下内容填写到不同的shell配置文件中  
  `export ALL_PROXY="socks5://127.0.0.1:10810"`  
* 系统设置代理：打开设置->网络->代理->手动->填入相关端口  
  填写内容例如：127.0.0.1和10810  
* 使用  
  ``` bash shell
  # 启动
  sudo systemctl start v2ray
  # 检查状态
  sudo systemctl status v2ray
  # 设置开机自启动
  sudo systemctl enable v2ray
  ```
* 测试`curl -x socks5://127.0.0.1:10810 https://www.google.com -v` 
## FAQ
Q: 所有端口和配置都弄好了，但是还是不行，测试就会超时，长时间没反应。  
A: 更新订阅，更换节点，重启终端(让更改后的配置文件生效），重启V2ray(让更改后的配置文件生效)
