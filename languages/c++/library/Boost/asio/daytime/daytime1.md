# Daytimer.1 一个同步TCP daytime客户端
本教程展示如何使用asio通过TCP去完成客户端程序
我们从包含必要的头文件开始
``` c++
#include <iostream>
#include <boost/array.hpp>
#include <boost/asio.hpp>
```
这个程序的意图是使用一个daytime服务，所以我们需要用户指定服务端
``` c++
using boost::asio::ip::tcp;

int main(int argc, char *argv[])
{
    try
    {
        if(argc != 2)
        {
            std::cerr << "Usage:client <host> " << std::endl;
            return 1;
        }
    }
}
```
所有使用asio的程序需要包含最少一个I/O执行上下文，例如一个io_context对象
``` c++
    boost::asio::io_context io_context;
```
我们需要转换被指定的参数即服务端名字给程序，给TCP末端。我们需要使用ip::tcp::resolver对象
``` c++
    tcp::resolver resolver(io_context);
```
解析器接受主机的名字和服务名，并将它们转换为端点列表。我们使用服务器的名称(在argv[1]中指定)和服务的名称(在本例中为“daytime”)执行解析调用。

端点列表使用ip::tcp::resolver::results类型的对象返回。该对象是一个范围，具有begin()和end()成员函数，可用于对结果进行迭代
``` c++
    tcp::resolver::results_type endpoints =
        resolver.resolve(argv[1]. "daytime");
```
现在我们创建并且来连接socket。端点列表获得之前可能链接的IPv4和IPv6端点，所有我们需要尝试他们中的每个，直到我们找到一个工作的。这保证了客户端程序独立于指定的IP版本。boost::asio::connect()函数已经自动为我们做好了。
``` c++
        tcp::socket socket(io_context);
        boost::asio::connect(socket, endpoints);
```
连接是打开的。所有我们需要现在做的是从daytime服务读取响应。
我们使用boost::array去接收收到的数据。boost::asio::buffer()函数自动决定数组的大小，以帮助防止缓冲区溢出。我们能够使用char[]或者std::vector，去替代boost::array。
``` c++
        for (;;)
        {
            boost::array<char, 128> buf;
            boost::system::error_code error;

            size_t len = socket.read_some(boost::asio::buffer(buf), error);
```
当服务端关闭连接，ip::tcp::socket::read_some()函数会退出，带有boost::asio::error::eof error，这让我们知道为什么退出循环。
``` c++
            if (error == boost::asio::error::eof)
                break;
            else if (error)
                throw boost::system::system_error(error);

            std::cout.write(buf.data(), len);
```
最后，处理我们所有可能抛出的异常
``` c++
    }
    catch (std::exception& e)
    {
        std::cerr << e.waht << std::endl;
    }
```