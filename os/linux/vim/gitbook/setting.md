# 设置
- `set wildmenu` 命令补全
- `set showcmd` 显示命令
- `set title` 在顶部显示标题
- `set wrap` 自动换行
- `set hlsearch` 高亮搜索
- `set scrolloff=5` 光标距顶/底5行
- `set backspace=indent,eol,start` backspace 能删除缩进，行尾/首空格
- `set laststatus=2` 状态栏2行
- `colorscheme gruvbox` 主题为gruvbox
- `set cursorline` 高亮当前行
- `set cursorcolumn` 高亮当前列
- `set smartindent` 智能缩进
- `set tabstop=4` tab占4个空格
- `set softtabstop=4` 插入模式tab占4个空格
- `set shiftwidth=4` 智能缩进为4个空格
- `set clipboard=unnamedplus` 复制到系统剪贴板
- `let mapleader= ' '` 空格作为leader键位

- `au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif` 每次打开都回到上次编辑位置

- Wsl中，复制内容到Windows剪贴板
    ```
    let s:clip = '/mnt/c/Windows/System32/clip.exe'
    if executable(s:clip)
        augroup WSLYank
            autocmd!
            autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
        augroup END
    endif
    ```
