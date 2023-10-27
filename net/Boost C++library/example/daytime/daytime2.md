# Daytime.2 一个 同步的TCP daytime服务
本教程展示如何使用asio实现一个基于TCP的服务端程序
``` c++
#include <ctime>
#include <iostream>
#include <string>
#include <boost/asio.hpp>

using boost::asio::ip::tcp;
```
我们定义make_daytime_string()函数去创建要发送回客户端的字符串。该函数将在我们所有的daytime服务端应用程序中重用。
``` c++
std::string make_daytime_string()
{
    using namespace std;
    time_t now = time(0);
    return ctime(&now);
}

int main()
{
    try
    {
        boost::asio::io_context io_context;
```
一个ip::tcp::acceptor对象需要被创建去监听一个新的连接。它被初始化到监听TCP端口13，IPv4。
``` c++
 tcp::acceptor acceptor(io_context, tcp::endpoint(tcp::v4(), 13));
```
这是一个迭代服务端，其意味着它将一次处理一个连接。创建一个套接字，它将表示与客户端的连接，然后等待连接。
``` c++
        for(;;)
        {
            tcp::socket socket(io_context);
            acceptor.accept(socket);
```
客户端正连接到我们的服务器。取决于当前的时间和转换信息给客户端。
``` c++
            std::string message = make_daytime_string();

            boost::system::error_code ignored_error;
            boost::asio::write(socket, boost::asio::buffer(message), ignored_error);
```
最后，处理异常
``` c++
    catch (std::exception& e)
    {
        std::cerr << e.waht() << std::endl;
    }
    return 0;
}
```