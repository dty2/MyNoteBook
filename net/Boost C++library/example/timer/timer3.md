# Timer3 绑定参数到完成处理程序
在这个教程中，我们会修改教程二的程序，计时器会每秒触发一次。
这会展示如何传递额外的参数到你的完成处理程序
``` c++
#include <iostream>
#include <boost/asio.hpp>
#include <boost/bind/bind.hpp>
```
使用asio去执行一个重复的定时器，你需要用完成处理程序去改变定时器的过期时间，并且接下来去开始一个新的异步等待。很显然，这意味着完成处理程序能够访问定时器对象。在这之后，我们会增加两个新的参数到print函数中:
* 一个指向定时器对象的指针
* 一个计数器能让我们在定时器触发第六次的时候停止程序
在参数列表的末尾
``` c++
void print(const boost::system::error_code&
    boost::asio::steady_timer* t, int *count)
{
```
如上所述，本教程程序使用计数器在计时器触发第六次的时候让其停止运行。然而，你会发现没有显式调用去让io_context停止。回想一下，在Timer2中，我们学的是io_context::run()函数，其当不再有工作的时完成。如果在count到达5时不在计时器上启动新的异步等待，io_context会做完工作并停止运行
``` c++
if(*count < 5)
{
    std::cout << *count << std::endl;
    ++(*count);
```
接下来，我们将计时器的到期时间从前一个到期时间移动一秒。通过计算新的过期时间相对于旧的过期时间，我们可以确保计时器不会因为处理处理程序的任何延迟而偏离整秒标记。
``` c++
    t->expires_at(t->expiry() + boost::asio::chrono::seconds(1));
```
接着，我们在计时器上开始一个新的异步等待。你可以看到，boost::bind()函数用于将额外的参数和完成处理程序关联起来。steady_timer::async_wait()函数期望一个签名为void(const boost::system::error_code&)的处理函数(或者是函数对象)。绑定附加参数将print函数转换为与签名正确匹配的函数对象。
查看Boost.Bind文档获取更多如何使用boost::bind()函数
在本例子中，boost::asio::placeholders::error参数到boost::bind()是一个名为placeholder用于错误对象传递到处理器。当初始化异步操作，并且如果使用boost::bind()，你一定明确只有这个placeholder可能被省略，如果参数是不被完成处理程序需要。

在本例中，boost::bind()的boost::asio:placeholders:error参数是一个命名占位符，它代表了传递给处理函数的错误对象。在初始化异步操作时，如果使用boost::bind()，则必须只指定与处理程序的参数列表匹配的参数。在教程Timer.4中，您将看到，如果完成处理程序不需要该参数，则可以省略此占位符。
``` c++
        t->async_wait(boost::bind(print, boost::asio::palceholders::error, t, count));
    }
}

int main()
{
    boost::asio::io_context io;
```
一个心得计数器变量被添加如此我们能在计时器触发第六次的时候停止程序
``` c++
    int count = 0;
    boost::asio::steady_timer t(io, boost::asio::chrono::seconds(1));
```
与步骤四一样，当从main调用到steady_timer::async_wait()时，我们绑定了print函数需要的附加参数
``` c++
    t.async_wait(boost::bind(print, boost::asio::placeholders::error, &t, &count));
    
    io.run();
```
最后，为了证明在打印处理程序函数中使用了count变量，我们将打印出它的新值。
``` c++
    std::cout << "Final count is " << count << std::endl;
    return 0;
```