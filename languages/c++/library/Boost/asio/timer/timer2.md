# Timer.2 异步使用定时器
这个教程的程序演示了如何通过改变教程Timer1的代码来使用asio的异步功能去展示一个在定时器上的异步等待。
``` c++
#include <iostream>
#include <boost/asio.hpp>
```
使用asio的异步功能意味着提供一个Completion Tokens,其决定在异步操作完成时如何将结果传递给完成处理程序。在这个程序中我们定义了一个函数叫做`print`，当异步等待结束时调用它。

``` c++
void print(const boost::system::error_code& )
{
    std::cout << "hello,world!" << std::endl;
}

int main(){
    boost::asio::io_context io;
    boost::asio::steady_timer t(io, boost::asio::chrono:seconds(5));
```
接下来，不像教程Timer1中做一个阻塞等待，我们调用steady_timer::async_wait()函数去执行一个异步的等待。当调用这个函数时我们传递之前定义的print函数
``` c++
t.async_wait(&print);
```
最后，我们必须在io_context对象上调用io_context::run()成员函数
asio库保证只从当前调用io_context::run()的线程调用完成处理程序。因此，除非调用io_context::run()函数，否则永远不会调用异步等待完成的完成处理程序。
asio库函数只要有工作要做就会继续执行。在本例中，工作是在计时器上异步等待，所以调用不会返回，直到定时器过期并且完成处理程序被返回
重要的是在调用io_context::run()之前给io_context一些工作去做。例如，如果我们省去上面对steady_timer::async_wait()的调用，io_context将会没有任何工作去做，结果就是io_context::run()将会立即返回
``` c++
    io.run();
    return 0;
}
```