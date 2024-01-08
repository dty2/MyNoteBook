.sudo_as_admin_successful: 记录使用sudo时是否成功获得root权限，成功获得会在主目录创建该文件
.zcompdump: 记录zsh中执行的命令，由zsh的compinit机制创建，加速命令补全
.motd_shown: 显示MOTD(message of the day)信息
.lesshst: 记录在less中执行的命令
.profile: 是sh和bash默认的配置文件。如果使用的是bash则可以在其中设置环境变量。如何使用zsh则应该在zshrc中设置环境变量。该文件会在用户登录的时候执行一次。如果对其更改，需注销后重新登录才会生效。
