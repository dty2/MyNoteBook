# Timer.1 同步地使用timer
这个教程程序通过展示如何在计时器上执行阻塞等待来介绍asio
我们从包含必要的头文件开始
只需要简单地包含`asio.hpp`头文件，所有的asio类就都可以使用了
```
#include <iostream>
#include <boost/asio.hpp>
```
任何使用了asio的程序最少有一个I/O执行上下文，例如一个io_context或者thread_pool对象。
一个I/O执行上下文提供对I/O功能的访问。我们首先声明一个io_context在主函数中
```
int main()
{
    boost::asio::io_context io;
```
接下来我们声明一个boost::asio::steady_timer类型的对象。
提供了I/O功能(或者在本例子中是定时器功能)的核心asio类总是将executor或者对执行上下文(例如io_context)的引用作为他们构造函数的第一个参数。
第二个构造函数参数设置了计时器从现在开始5秒到期
```
boost::asio::steady_timer t(io, boost::asio::chrono::seconds(5));
```
在这个简单的例子中我们在计时器上执行了一个阻塞等待。
也就是说，对`steady_timer::wait()`的调用将不会返回，直到定时器过期
即定时器对象创建后的5秒后(即，不从等待开始时开始)

一个计时器总是处于灵感状态：“过期”或者是“未过期”。
如果`steady_timer::wait()`函数在一个已经过期的定时器上被调用
它将会立刻返回
```
t.wait();
```
最后我们通过打印必要的"hello,world！"信息来展示何时计时器会过期
```
    std::cout << "hello, world!" << std::endl;
    return 0;
}
```

``` c++
/*
例程
*/
#include <iostream>
#include <boost/asio.hpp>

int main()
{
  boost::asio::io_context io;
  boost::asio::steady_timer t(io, boost::asio::chrono::seconds(5));
  std::cout << " hello " << std::endl;
  t.wait();   //等待五秒后返回
  std::cout << " hello " << std::endl;
  t.wait();   // 立刻返回
  std::cout << " hello " << std::endl;
  return 0;
}
```