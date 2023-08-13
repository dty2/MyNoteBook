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

### Coc nvim && tabnine
* 介绍: 自动补全
* 安装: 
  - 获取 Vim(+python3) :  
    1. `git clone @github.com:vim/vim.git`  
    2. `sudo apt install python3` + `sudo apt install python3-dev`  
    3. 配置参数  
       ``` bash shell
       ./configure \
       --with-features=huge \
       --enable-fontset \
       --enable-python3interp \
       --with-python3-command=python3
       ```
    4. 查询cpu数量`cat /proc/cpuinfo | less` (ps:查看逻辑cpu数量)  
    4. `sudo make -j8` + `sudo make install`  
    5. 查看Vim版本`vim --version`,看是否有+python3  
  - 安装Coc nvim
  - 获取nodejs和npm `sudo apt install nodejs` + `sudo apt install npm`(ps:也可按照github上的指示进行安装)
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
* 安装: 获取npm和yarn `sudo apt install npm` `npm install --global yarn`  
* 待解决:   
  遇到个奇怪的问题，我在.vimrc中设置了`let g:mkdp_auto_close = 1`和`let g:mkdp_auto_open = 1`, 但是貌似并未起作用。并且，当我用nerdtree打开新的md文件时，先前预览的文件并不会消失，反而会打开一个名字和之前预览的文件一样的预览，但是该预览并没有内容。虽然也会打开新的预览文件，但是之前的并未关闭。(个人猜测可能是auto close设置并未生效)虽然并不影响使用，但是比较难受。  
