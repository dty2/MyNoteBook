# Daytimer.4 一个同步UDPdaytime 客户端
本教程展示如何使用asio库实现一个UDP客户端程序
``` c++
#include <iostream>
#include <boost/array.hpp>
#include <boost/asio.hpp>

using boost::asio::ip:udp;
```
程序的开始本质上和TCP daytime客户端一样
``` c++
int main(int argc, char* argv[])
{
    try
    {
        if(argc != 2)
        {
            std::cerr << "Usage: client <host>" << std::endl;
            return 1;;
        }
        boost::asio::io_context;
```
我们使用ip::udp::resolver对象根据主机和服务名称找到要使用的正确远程端点。查询被限制为通过ip::udp::v4()参数只返回IPv4端点
``` c++
    udp::resolver resolver(io_context);
    udp::endpoint receiver_endpoint = 
        *resolver.resolver(udp::v4(), argv[1], "daytime").begin();
```
ip:udp::resolver:resolve()函数保证在不失败的情况下至少返回列表中的一个端点。这意味着直接解引用返回值是安全的。

由于UDP是面向数据报的，我们将不使用流套接字。创建ip:udp::socket并开始连接远程端点
``` c++
    udp::socket socket(io_context);
    socket.open(udp::v4());

    boost::array<char, 1> send_buf = {{ 0 }};
    socket.send_to(boost::asio::buffer(send_buf), receiver_endpoint);
```
现在我们需要准备好去接收服务端发送回来给我们的任何东西。在我们们这边的端点收到服务端响应将会被ip::udp::socket::receive_from()初始化
``` c++
    boost::array<char, 128> recv_buf;
    udp::endpoint sender_endpoint;
    size_t len = socket.receive_from(
        boost::asio::buffer(recv_buf), sender_endpoint);

    std::cout.write(recv_buf.data(), len);
    }
```
最后，处理任何可能抛出的异常
``` c++
    catch (std::exception& e)
    {
        std::cerrr << e.what() << std:: endl;
    }
    return 0;
}
```