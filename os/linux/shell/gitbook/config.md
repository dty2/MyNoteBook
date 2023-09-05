# 配置
## 插件
* **oh my zsh**  
  - 下载安装脚本  
    `sudo wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh`  
  - `sh install.sh`安装   
  - `ZSH_THEME="your-theme"`设置主题  
## FAQ:
  Q1: bullet-train 主题在设置完成后会显示一个版本号  
  A1: 这是NVM版本号。如果想要关闭，则需更改主题文件。打开.oh-my-zsh目录，进入themes  
  找到bullet-train.zsh-theme，并进行如下设置   
  ```
    # NVM: Node version manager
    prompt_nvm() {
      local nvm_prompt
      if type nvm >/dev/null 2>&1; then
        nvm_prompt=$(nvm current 2>/dev/null)
        [[ "${nvm_prompt}x" == "x" || "${nvm_prompt}" == "system" ]] && return

  -   elif type node >/dev/null 2>&1; then
  -     nvm_prompt="$(node --version)"

  +   #elif type node >/dev/null 2>&1; then
  +   #  nvm_prompt="$(node --version)"

      else
        return
      fi
      nvm_prompt=${nvm_prompt}
      prompt_segment $BULLETTRAIN_NVM_BG $BULLETTRAIN_NVM_FG $BULLETTRAIN_NVM_PREFIX$nvm_prompt
    }
  ```  

