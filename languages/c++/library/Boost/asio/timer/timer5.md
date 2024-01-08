# Timer.5 多线程中同步完成处理程序
本教程演示在多线程程序中使用strand模板类来同步地完成处理程序

前四个教程通过仅从一个线程调用io_context::run()函数来避免处理程序的同步问题。你应该知道，asio库提供了一个保证，即只从当前正在调用io_context::run()的线程中调用完成处理程序
因此，从单一线程调用io_context::run()确保完成处理程序不能并发地运行

在用asio开发应用程序时，单线程方法通常是最好的起点。缺点是它限制了程序，特别是服务器，包括：
* 处理花长时间才能完成的程序时，响应性差
* 无法在多处理器上进行扩展

如果你发现自己遇到了这些限制，一个可行地方式是使用一个线程池调用io_context::run()。然而，由于这运行处理程序并发的执行，我们需要一种同步的方法去解决处理程序可能访问共享，或者线程不安全的资源
``` c++
#include <iosteam>
#include <boost/asio.hpp>
#include <boost/thread/thread.hpp>
#include <boost/bind/bind.hpp>
```
我们从定义一个名为printer的类开始，和先前的教程中的类相似。
这个类会通过并行运行两个计时器来扩展之前的教程。
``` c++
class printer
{
public:
```

除了初始化一对boost:asio:steady_timer成员外，构造函数还初始化strand_成员，boost::asio::strand<boost::asio::io_context::executor_type>类型的对象

strand类模板是一个执行程序适配器，它保证，对于那些通过它分派的处理程序，一个正在执行的处理程序将被允许在下一个处理程序开始之前完成。无论调用io_context::run()的线程数量有多少，都可以保证这一点。当然，处理程序仍然可以与其他处理程序并发执行，这些处理程序不是通过一个strand来调度的，或者是通过一个不同的strand对象来调度的。
``` c++
    printer(boost::asio::io_context& io)
        : strand_(boost::asio::make_strand(io)),
            timer1_(io, boost::asio::chrono::seconds(1)),
            timer2_(io, boost::asio::chrono::seconds(1)),
            count_(0)
    {
```
当初始化异步操作，每一个完成处理程序被“绑定”到boost::asio::strand<boost::asio::io_context::executor_type>对象。boost::asio::bind_executor()函数返回一个新的处理程序，该程序通过strand对象自动分配其包含的处理程序。通过将处理程序绑定到到相同的strand，我们可以确保他们不会并发执行
``` c++
        timer1_.async_wait(boost::asio::bind_executor(strand_,
            boost::bind(&printer::print1, this)));

        timer2_.async_wait(boost::asio::bind_executor(strand_,
            boost::bind(&printer::print2, this)));
    }
    ~printer()
    {
        std::cout << "Final count is " << count_ << std::endl;
    }
```
在一个多线程的程序中，如果他们访问共享资源异步操作的处理程序应该被同步。本教程，共享资源被处理std::cout和成员数据count_程序(print1和print2)使用
``` c++
    void print1()
    {
        if (count_ < 10)
        {
            std::cout << "Timer 1: " << count_ << std::endl;
            ++ count_;

            timer1_.expires_at(timer1_.expiry() + boost::asio::chrono:seconds(1));
            timer1_.async_wait(boost::asio::bind_executor(strand_,
                boost::bind(&printer::print1, this)));
        }
    }

    void print2()
    {
        if (count_ < 10)
        {
            std::cout << "Timer 2: " << count_ << std::endl;
            ++ count_;
            timer2_.expires_at(timer2_.expiry() + boost::asio::chrono::seconds(1));
            timer2_.async_wait(boost::asio::bind_executor(strand_,
                boost::bind(&printer::print2, this)));
        }
    }

privare:
    boost::asio::strand<boost::asio::io_context::executor_type> strand_'
    boost::asio::steady_timer timer1_;
    boost::asio::steady_timer timer2_;
    int count_;
};
```
主函数现在导致io_context::run()从两个线程中被调用:主线程和另一个附加线程。其使用boost::thread对象使用完成。

就像从单个线程调用一样，并发调用io_context::run()会当还有工作要做的时继续执行。在后台线程不会退出，直到所有的异步操作被完成。
``` c++
int main()
{
    boost::asio::io_context io;
    printer p(io);
    boost::thread t(boost::bind(&boost::asio::io_contextrun, &io));
    io.run();
    t.join();
    return 0;
}
```