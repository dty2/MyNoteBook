# Daytime.5 同步UDP daytime服务端
本教程展示如何使用asio实现UDP服务端
``` c++
int main()
{
    try
    {
        boost::asio::io_context io_context;
```
创建ip::udp::socket对象接收端口13的UDP请求
``` c++
    udp::socket socket(io_context, udp::endpoint(udp::v4(), 13));
```
等待客户端开始连接到我们。remote_endpoint对象将会由ip::udp::socket::receive_from()填充
``` c++
        for(;;)
        {
            boost::array<char, 1> recv_buf;
            udp::endpoint remote_endpoint;
            socket.receive_from(boost::asio::buffer(recv_buf), remote_endpoint);
```
取决于我们想要发送回客户端的内容
``` c++
        std::string message = make_daytime_string();
```
发送响应到远程端点
``` c++
            boost::system::error_code ignored_error;
            socket.send_to(boost::asio::buffer(message),
                remote_endpoint, 0, ignored_error);
        }
    }
```
最后处理异常
``` c++
    catch (std::exception& e)
    {
        std::cerr << e.what() << std::endl;
    }

    return 0;
}
```