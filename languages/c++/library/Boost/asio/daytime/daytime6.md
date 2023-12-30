# Daytime.6 异步UDP daytime服务端
主函数
``` c++
int main()
{
    try
    {
```
创建一个服务对象去接收将要到来的客户端请求，并且运行io_context对象
``` c++
    boost::asio::io_context io_context;
    udp_server server(io_context);
    io_context.run();
    }
    catch (std::exception& e)
    {
        std::cerr << e.what() << std::endl;
    }

    return 0;
}
```
udp_server类
``` c++
class udp_server
{
public:
```
构造函数初始化一个套接字去监听UDP端口13
``` c++
    udp_server(boost::asio::io_context& io_context)
        : socket_(io_context, udp::endpoint(udp::v4(), 13))
    {
        start_receive();
    }

private:
    void start_receive()
    {
```
函数ip::udp::socket::async_receive_from()将使用应用程序再后台监听新请求。当收到这样的请求，io_context对象将使用两个函数调用handle_receive()函数:boost::system::error_code类型的值指示操作是否成功或失败，以及size_t值bytes_transferred指定接收的字节数。
``` c++
        socket_.async_recevie_from(
            boost::asio::buffer(recv_buffer_), remote_endpoint_,
            boost::bind(&udp_server::handle_receive, this,
                boost::asio::placeholders::error,
                boost::asio::placeholders::bytes_transferred));
    }
```
函数handle_recevie()将服务客户端的请求
``` c++
    void handle_receive(const boost::system::error_code& error,
        std::size_t/*bytes_transferred*/)
    {    
```
error参数包含异步操作的结果。因为我们只提供一字节的recv_buffer_去包含客户端的请求，如果客户端发送的东西太长，io_context对象将会返回一个错误。当这种错误出现时我们能忽视它
``` c++
        if (!error)
        {
```
取决于我将要发送什么
``` c++
        boost::shared_ptr<std::string> message(
            new std::string(make_daytime_string()));
```
我们现在调用ip::udp::socket::async_send_to()去服务客户端发送的数据
``` c++
    socket_.async_send_to(boost::asio::buffer(*message), remote_endpoint_,
        boost::bind(&udp_server::handle_send, this, message,
            boost::asio::placeholders::error,
            boost::asio::placeholders::bytes_transferred));
```
当初始化异步操作时如果使用boost::bind()，你需要指明与处理参数列表匹配的参数。在这个程序中，这个两个参数展位符(boost::asio::placeholders::error 和 boost::asio::placeholders::bytes_transferred)可能已经被删除了

开始监听下个客户端的请求
``` c++
    start_receive();
```
客户端请求的任何进一步操作都由handle_send()负责。
``` c++
        }
    }
```
函数handle_send()在服务端请求已经完成后被调用
``` c++
    void handle_send(boost::shared_ptr<std::string> /*message*/,
        const boost::system::error_code& /*error*/,
        std::size_t /*bytes_transferred*/)
    {

    }

    udp::socket socket_;
    udp::endpoint remote_endpoint_;
    boost::array<char, 1> recv_buffer_;
};
```
