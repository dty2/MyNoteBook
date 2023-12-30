# Daytime.3 异步TCP daytime服务端
主函数
``` c++
int main()
{
    try
    {
```
我们需要创建一个服务对象去接收将要到来的客户端连接。io_context对象提供了I/O服务，例如服务对象将会使用的sockets
``` c++
    boost::asio::io_context io_context;
    tcp_server server(io_context);
```
执行io_context对象以便于执行其代表你去执行一个异步操作
``` c++
    io_context.run();
    }
    catch (std::excepetion& e)
    {
        std::cerr << e.what() << std::endl;
    }
    return 0;
}
```
tcp_server类
``` c++
class tcp_server
{
public:
```
构造函数初始化一个接收器去在13端口上监听
``` c++
    tcp_server(boost::asio::io_context& io_context)
        : io_context(io_context),
          acceptor_(io_context, tcp::endpoint(tcp::v4(), 13))
    {
        start_accept();
    }

private:
```
函数start_accept()创建一个套接字并初始化一个异步接收操作去等待新的连接
``` c++
    void start_accept()
    {
        tcp_connection::pointer new_connection = 
            tcp_connection::create(io_context_);
        
        acceptor_.async_accept(new_connection->socket(),
            boost::bind(&tcp_server::handle_accept, this, new_connection,
                boost::asio::placeholders::error));
    }
```
当异步接收操作被start_accept完成初始化时函数handle_accept()被调用。它服务客户端的需求，并且接下来调用start_accept去初始化下一个异步操作
``` c++
    void handle_accept(tcp_connection::pointer new_connertion,
        const boost::system::error_code& error)
    {
        if(!error)
        {
            new_connection->start();
        }
        start_accept();
    }
}
```
tcp_connection类
我们将使用shared_prt和enable_shared_from_this，因为我们想要保持tcp_connecion对象活跃，只要有一个操作引用它
``` c++
class  tcp_connection
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
}
```
在函数start中，我们调用boost::asio::async_write()为客户端服务处理数据。
标记我们正在使用boost::asio::async_write()，而不是ip::tcp::socket::async_write_some()，去确保整个被阻塞的数据被发送
``` c++
    void start()
    {
```
被发送的数据被存储到在类的message_成员变量中作为我们需要保持的有效数据直到异步操作被完成
``` c++
    message_ = make_daytime_string();
```
当初始化异步操作，并且如果使用boost::bind()时，你必须明确只有匹配处理程序的参数列表的参数。在这个程序中，这两个参数储存器(boost::asio::placeholders::error和boost::asio::placeholders::bytes_transferred)可能已经被移除了，当他们不再被handle_write()使用时。
``` c++
    boost::asio::async_write(socket_, boost::asio::buffer(message_),
        boost::bind(&tcp_connection::handle_write, shared_from_this()
            boost::asio::placeholders::error,
            boost::asio::placeholders::bytes_transferred));
```
该客户端连接的任何进一步操作现在都由handle_write()负责
``` c++
    }

private:
    tcp_connection(boost::asio::io_context& io_context)
        : socket_(io_context)
    {}

    void handle_write(const boost::system::error_code& size_t)
    {}

    tcp::socket socket_;
    std::string message_;
```
移除未被使用的处理参数
你可能注意到，error,和bytes_transferred参数在handle_write()函数主体中没被使用。如果参数不被需要，可以在函数中去掉他们，像这样:
``` c++
    void handle_write()
    {}
```
然后可以将用于初始化调用的boost:asio:async_write()调用更改为:
``` c++
    boost::asio::async_write(socket_, boost::asio::buffer(message_),
        boost::bind(&tcp_connection::handle_write, shared_from_this()));
```