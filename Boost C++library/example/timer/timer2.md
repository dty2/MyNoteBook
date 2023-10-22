# Timer.2 异步使用定时器
这个教程的程序演示了如何通过改变教程Timer1的代码来使用asio的异步功能去展示一个在定时器上的异步等待。
```
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
接下来，不像教程Timer1中做一个阻塞等待，我们调用steady_timer::async_wait()函数去执行一个异步的等待。当调用这个函数我们传递之前定义的print函数
```
t.async_wait(&print);
```
最后，我们必须在io_context对象上调用io_context::run()成员函数
asio库函数也会继续执行直到还有个工作去做。在这个例子中，工作是在计时器上异步等待，所以调用不会返回知道定时器过期并且completion handler被返回
在调用io_context::run()之前给io_context一些工作去做是重要的。例如，如果我们省去之前所有的steady_timer::async_wait()的调用，io_context会没有任何工作去做，并且io_context::run()将会立即返回
```
    io.run();
    return 0;
}
```