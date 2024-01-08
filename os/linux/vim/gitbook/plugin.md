# Vim Plugins  
## Vim-plug  
* 安装Vim-plug  
   ``` bash
   cd ~
   git clone git@github.com:junegunn/vim-plugins.git
   mkdir -p ~/.vim/autoload/
   cp ~/vim-plug/plug.vim .vim/autoload/plug.vim
   ```  
* 配置vimrc  
   ``` vim script   
   let g:plug_url_format = 'git@github.com:%s.git' "使用ssh下载插件
   call plug#begin('~/.vim/plugged')
   Plug 'xxx-xxx-xxx' "替换
   call plug#end()
   ```  
* 安装插件  
在两个call中间添加`Plug 'xxx-xxx-xxx'`  
更新配置文件`source ~/.vimrc`  
插件安装`PlugInstall`  

* 删除插件  
在两个call中间删除`Plug 'xxx-xxx-xxx'`  
更新配置文件`source ~/.vimrc`  
插件安装`PlugClean`  

## Plugins
温馨提示：以下配置并非全部配置内容，详细见配置文件  
注意：以下插件皆用上述vim-plug进行安装
### Nerdtree
* 介绍: 文件树
* 配置:  
  - `nnoremap <leader>n :NERDTreeToggle<CR>` 开关
  - `let NERDTreeQuitOnOpen = 1` 打开文件自动关闭
  - `let NERDTreeShowHidden = 1` 显示隐藏文件

### Airline & Airline Themes  
* 介绍: 状态栏 + 美化
* 安装: 获取powerline字体 `sudo apt-get install fonts-powerline` (也可不下载，请往后看)
* 配置:  
  - `let g:airline#extensions#tabline#enabled = 1` 打开顶栏
  - `let g:airline_powerline_fonts = 1` 打开powerline字体效果  
  - 不用下载powerline字体，请在vimrc文件中添加如下内容(也能获得类似效果)  
    ``` vim script
    if !exists('g:airline_symbols')
    let g:airline_symbols = {}
    let g:airline_left_sep = ''
    let g:airline_right_sep = ''
    let g:airline_symbols.branch = ''
    let g:airline_symbols.readonly = ''
    let g:airline_symbols.dirty='⚡'
    endif
    ```  
    FAQ1: 获取字体命令不生效则手动上powerline仓库[去安装](https://github.com/powerline/fonts)
    FAQ2: 如果你在使用wsl2的话，需要你检查你的windows是否有字体集，如果没有则需要在windows上安装相应字体集，并在终端模拟器上进行配置
### Tagbar 
* 介绍: 标签栏
* 安装: 获取ctags 执行`sudo install apt exuberant-ctags`下载ctags  
* 配置: 
  - `let g:tagbar_autofocus = 1` 打开后自动将光标置入其中  
  - `let g:tagbar_autoclose = 1` 选择确定后自动关闭

### Vim-surround  
* 介绍: 难以描述，用就知道了
* Q: [What does the "y" stand for in "ysiw"?](https://github.com/tpope/vim-surround/issues/128)  

### Gruvbox  
* 介绍: Vim主题

### Visual-multi  
* 介绍: 多光标

### Auto-pairs  
* 介绍: 补全符号 

### Easymotion  
* 介绍: 闪现

### Coc nvim && tabnine && clangd
* Coc nvim介绍: 自动补全平台
* Coc nvim安装: 
  - 按照版本要求安装nodejs，我们通过nvm来安装
    安装nvm`curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash` ps:重启终端使其生效，安装nodejs`nvm install 16.18.0`(ps:注意版本！！！官方的readme说大于14.14.0是不行的，进入vim就报错的话，报错里会有一行说版本小于16.18.0)
  - 通过插件管理器安装coc nvim即可
* tabnine安装:
  - 安装tabnine `:CocInstall coc-tabnine`
* 配置:  
  - `:CocConfig` 在打开文件中添加  
      ```  
      {
        "coc.source.tabnine.enable":true
      }
      ```  
  - `:CocCommand tabnine.openConfig` 在打开文件中添加 `"ignore_all_lsp":true`   
* FAQ:
  - 故事：最初我在重新编译Vim的时候，是在一篇博客的指导下完成的。最初我在查阅该博客的时候，我并未打算让Vim支持lua等内容。可是当时我在照着那个博客配置参数的时候，并未注意到`--enable-fail-if-missing`这个参数，这个参数的意思是只有每个参数都配置成功才整体配置成功。但是由于我未安装lua等相关依赖，又照搬人家博客中的配置参数(含有与lua有关的参数)，最终导致我怎么尝试也不好使。最终无奈，特意查询了每个参数的含义后我才明白是怎么回事。

  - E2: 当我执行`CocCommand tabnine.openConfig`的时候，没有任何事发生。  
    这可能是由于相应的配置文件不存在所导致的。可以查看在.config目录下存不存在Tabnine文件。如果不存在则证明配置文件缺失。导致配置文件缺失可能是由于`./config/coc/extensions/coc-tabnine-data/binaries/4.5.19/x86_64-unknown-linux-musl/Tabnine`文件没有执行权限所导致的。你需要给其增加执行权限`chmod +x Tabnine`。接着执行`:CocCommand tabnine.updateTabNine`, 在这时你需要按压其他键位，你会看到在状态栏中有个进度条，让其到达100%即可。最后重新下载`:CocInstall coc-tabnine` 并尝试 `:CocCommand tabnine.openConfig` 即可。  

  - E3: 在使用kali的时候，由于ssh并未设置相应的端口，导致下载插件失败，只需将端口由10808更改成10810即可。

### preview-markdown  
* 介绍: 支持markdown预览
* 安装: 需要nodejs和xdg-utils(可能需要)
