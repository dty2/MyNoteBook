# Timer.4 使用成员函数作为完成处理程序
在本教程，我们会看到如何使用一个类的成员函数作为完成处理程序
这个程序应该和教程Timer3中的程序执行结果一样
``` c++
#include <iostream>
#include <boost/asio.hpp>
#include <boost/bind/bind.hpp>
```
不去定义一个自由函数print作为完成处理程序，像我们在上个教程程序中那样
我们现在定义一个类叫做printer
``` c++
class printer
{
public:
```
这个类的构造器将接受io_context对象的引用，并在初始化timer_成员时使用它。用于关闭程序的计数器也是一个类的成员。
``` c++
    printer(boost::asio::io_context& io)
        : timer_(io, boost::asio::chrono::seconds),
            count_(0)
    {
```
boost::bind()函数对类成员函数和对自由函数一样有效。由于所有非静态类成员函数都有隐式this形参，因此需要将this绑定到函数。与教程Timer3中一样，boost::bind()将我们完成处理程序(现在是一个成员函数)转换为一个函数对象。该对象可以被调用，就像它具有void(const boost::system::error_code&)签名一样。

您将注意到这里没有指定boost:asio:placeholders:error占位符，因为print成员函数不接受错误对象作为参数。
``` c++
    timer_.async_wait(boost::bind(&printer::print, this));
}
```
在类构造函数中我们会打印出计数器最后的值
``` c++
    ~printer()
    {
        std::cout << "Final count is " << count_ << std::endl;
    }
```
print成员函数和教程Timer3中的print函数是非常相似的，只不过它现在对类数据成员进行操作，而不是将计时器和计数器作为参数传入。
``` c++
    void print()
    {
        if (count_ < 5)
        {
            std::cout << count_ << std::endl;
            ++ count_;
            
            timer_.expires_at(timer_.expiry() + boost::asio::chrono::seconds(1));
            timer_.async_wait(boost::bind(&printer::print, this));
        }
    }
private:
    boost::asio::steady_timer timer_;
    int count_;
```
主函数是比之前的简单不少，因为现在它在正常运行io_context之前声明一个本地的printer对象
```
int main()
{
    boost::asio::io_context io;
    printer p(io);
    io.run();

    return 0;
}
```