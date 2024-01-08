# Daytime.7 结合TCP/UDP 异步服务端
这个教程程序展示了如何将我们刚刚编写的两个异步服务器组合成一个服务器应用程序
主函数
``` c++
int main()
{
    try
    {
        boost::asio::io_context io_Context;
```
我们将会开始于创建一个服务对象去接收TCP客户端的连接
``` c++
    tcp_server server1(io_context);
```
我们也需要一个服务对象去接收UDP客户端请求
``` c++
    udp_server server2(io_context);
```
我们已经创建了两个工作组为io_context对象
``` c++
        io_context.run();
    }
    catch (std::exception& e)
    {
        std::cerr << e.what() << std::endl;
    }

    return 0;
}
```
tcp_connection和tcp_server对象
接下来两个类取自Daytime.3
``` c++
class tcp_connection
    : public boost::enable_shared_from_this<tcp_connection>
{
public:
    typedef boost::shared_ptr<tcp_connection> pointer;

    static pointer create(boost::asio::io_context& io_context)
    {
        return pointer(new tcp_connection(io_context));
    }

    tcp::socket& socket()
    {
        return socket_;
    }

    void start()
    {
        message_ = make_daytime_string();

        boost::asio::async_write(socket_, boost::asio::buffer(message_),
            boost::bind(&tcp_connection::handle_write, shared_from_this()));
    }

private:
    tcp_connection(boost::asio::io_context& io_context)
        : socket_(io_context)
        {}

    void handle_write()
    {}

    tcp::socket socket_;
    std::string message_;
};
class tcp_server
{
public:
    tcp_server(boost::asio::io_context& io_context)
        : io_context_(io_context),
          acceptor_(io_context, tcp::endpoint(tcp::v4(), 13))
    {
        start_accept();
    }

private:
    void start_accept()
    {
        tcp_connection::pointer new_connection =
            tcp_connection::create(io_context_);

        acceptor_.async_accept(new_connection->socket(),
            boost::bind(&tcp_server::handle_accept, this, new_connection,
                boost::asio::placeholders::error));
    }
    void handle_accept(tcp_connection::pointer new_connection,
        const boost::system::error_code& error)
    {
        if(!error)
        {
            new_connection->start();
        }

        start_accept();
    }

    boost::asio::io_context& io_context_;
    tcp::acceptor acceptor_;
};
udp_server类 
相似的，接下来的类来自于先前的教程中
``` c++
class udp_server
{
public:
    udp_server(boost::asio::io_context& io_context)
        : socket_(io_context, udp::endpoint(udp::v4(), 13))
    {
        start_receive();
    }

private:
    void start_receive()
    {
        socket_.async_receive_from(
            boost::asio::buffer(recv_buffer_), remote_endpoint_,
            boost::bind(&udp_server::handle_revice, this,
            boost::asio::placeholders::error));
    }

    void handle_receive(const boost::system::error_code& error)
    {
        if(!error)
        {
            boost::shared_ptr<std::stirng> message(
                new std::string(make_daytime_string()));
            
            socket_.async_send_to(boost::asio::buffer(*message), remote_endpoint_,
                boost::bind(&udp_server::handle_send, this, message));

            start_receive();
        }
    }

    void handle_send(boost::shared_ptr<std::string> /*message*/){}

    udp::socket socket_;
    udp::endpoint remote_endpoint_;
    boost::array<char, 1> recv_buffer_;
};
```

