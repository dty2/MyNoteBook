# rofi脚本 5
## 名字
rofi 脚本模块 - Rofi可脚本化的模块  
## 描述
rofi支持在后台使用简单的脚本生产列表并处理用户操作结果的模式。  
其提供了一个简单的接口去对rofi做一些简单的扩展。  
## 用法
指定一个脚本模式，用:"{name}:{executable}"语法来设置一个模式  
例如：  
``` bash shell
rofi -show fb -modes "fb:file_browser.sh"
```  
name应该是唯一的。
## 接口
rofi 在首次启动时不带参数地调用可执行文件，这应生成通过(\n)分割的选项列表(这可以在脚本中更改)。  
如果用户选择了一个选项，rofi会调用可执行文件并将选项的文本作为第一个参数传入。  
如果脚本返回了空条目，rofi将退出。  
一个简单的脚本：
``` bash shell
#!/usr/bin/env bash

if [ x"$@" = x"quit" ]
then
    exit 0
fi
echo "reload"
echo "quit"
```  
这显示了两个条目，reload和quit。当退出条目被选择，关闭rofi。  
## 环境变量
当执行脚本的时候rofi可以设置如下环境变量：  
### *ROFI_RETV*
一个整数表示当前的状态：  
* 0:初始化调用脚本。
* 1:选择一个条目。
* 2:选择一个自定义条目。
* 10-28:自定义键位映射1-19(需要被特别指定成可用的脚本)。
### *ROFI_INFO*
如果设置了，则在使用'info'行选项的属性值设置所选条目时设置环境。  
### *ROFI_DATA*
当脚本在头文件设置`data`时设置环境。  
## 传递mode选项
其他选项，例如提示，能在脚本中设置。  
额外的选项就是以NULL字符(\0)开头，跟随一个键值，分隔符(\x1f)和数值。  
例如设置提示：
```
echo -en "\0prompt\x1fChange prompt\n"
```  
存在如下其他选项：
* prompt:更新提示文本。
* message:更新信息文本。
* markup-rows:如果为真，在行中呈现标记。
* urgent:将行标记为紧急。(有关句法，参考dmenu模式下的urgent选项)
* active:将行标记为活动。(有关句法，参考dmenu模式下的active选项)
* delim:设置定界符给下一行。默认'\n'并且这个选项应该以此结束。只有当调用其作为在脚本中的第一次调用，它被记作连续的调用。
* no-custom:如果设置为真，只接受条目列表，忽略自定义的输入
* use-hot-key:如果设置为真，它允许用脚本进行自定义键位映射。警告这打破了正常的rofi工作流。
* keep-selection:如果设置，所选内容不能移动到第一个条目，而是保持当前位置。清楚过滤器。
* new-selection:如果`keep-selection`被设置，其允许你去覆盖已选的条目(绝对位置)
* data:通过ROFI_DATA给下一个脚本的执行传递传递数据。
* theme:小主题片段，改变窗口的背景颜色。  

## 解析行选项
可以为单独的行设置额外的选项。  
额外的选项可以按照与mode选项相同的语法来指定，但是要在条目之后指定。  
例如：
```
echo -en "aap\0icon\x1ffolder\n"
```  
支持如下选项：
* icon:为行设置图标
* meta:指定不可见的搜索词
* nonselectable:如果为真，行不能活动
* info:信息在选择时，被放置在`ROFI_INFO`环境变量中。这个条目不能被搜索。
* urgent:在条目上设置紧急标签(真/假)
* active:在条目上设置活动标签(真/假)
多个条目可以被使用`\x1f`分离符传送。
```
echo -en "aap\0icon\x1ffolder\x1finfo\x1ftest\n"
```  
## 执行额外的程序
如果你想从脚本中启动外部程序，你需要确保它在后台启动。如果没有，rofi会等它的输出(显示)。
在bash实现其最好的方式是使用`coproc`.
```
coproc ( myApp > /dev/null 2>&1 )
```  
## DASH shell
如果你使用`dash`shell作为你的脚本，要特殊注意dash如何处理分隔符的转义值。关注github上的issue #1201
## 脚本位置
有如下选项去指定脚本:
* 指定一个绝对地址给脚本
* 脚本是可被执行的并且在你指定的$PATH上
位于如下地址的脚本会被首先加载：
* 位于`$XDG_CONFIG_PATH/rofi/scripts/`的脚本，这通常在`~/.config/rofi/scripts/`
## 另请参考
rofi(1), rofi-sensible-terminal(1), dmenu(1), rofi-theme(5), rofi-theme-selector(1)  
## 作者
Qball Cow qball@gmpclient.org  
Rasmus Steinke rasi@xssn.at  
Morgane Glidic sardemff7+rofi@sardemff7.net  
Original code based on work by: Sean Pringle sean.pringle@gmail.com    
For a full list of authors, check the AUTHORS file.  
翻译 董统鹰扬(Hunter)

# 注释 
prompt：这个参数用于设置菜单的提示文本。提示文本是显示在菜单上方的一行文本，用于指示用户应该输入什么样的内容。例如，如果您正在编写一个脚本来搜索文件，那么提示文本可能是“请输入要搜索的文件名”。提示文本通常以粗体字显示，以便用户更容易看到它。  
message：这个参数用于设置菜单下方的消息文本。消息文本是一行文本，用于向用户提供有关菜单选项的信息。例如，如果您正在编写一个脚本来安装软件包，那么消息文本可能是“请选择要安装的软件包”。消息文本通常以正常字体显示。  
markup-rows：这个参数用于启用或禁用菜单项中的标记语言。如果将其设置为“true”，则可以在菜单项中使用标记语言（如HTML或Markdown）来格式化文本。例如，您可以使用标记语言来添加颜色、字体样式、图像等。  
urgent：这个参数用于将菜单项标记为紧急。如果将其设置为“true”，则会将菜单项突出显示为红色或其他醒目的颜色，以便用户更容易看到它们。
active：这个参数用于将菜单项标记为活动状态。如果将其设置为“true”，则会将菜单项突出显示为蓝色或其他醒目的颜色，以便用户更容易看到它们。  
delim：这个参数用于设置下一行的分隔符。默认情况下，分隔符是换行符“\n”。如果您想使用不同的分隔符，则可以使用此选项来指定它。  
no-custom：这个参数用于限制用户只能选择预定义的选项。如果将其设置为“true”，则用户无法输入自定义内容。  
use-hot-keys：这个参数用于启用自定义快捷键。如果将其设置为“true”，则用户可以使用自定义快捷键来选择菜单项。  
keep-selection：这个参数用于保留当前选择的菜单项。如果将其设置为“true”，则当前选择不会被重置，并且过滤器会被清除。  
new-selection：这个参数允许您覆盖当前选择。如果您想要选择不同的菜单项，则可以使用此选项来指定新的选择。  
data：这个参数允许您传递数据到下一次执行脚本时使用。  
theme：这个参数允许您更改小部件的外观。例如，您可以使用此选项来更改背景颜色或字体样式。
