# Help
[Help](https://www.boost.org/doc/libs/1_83_0/doc/html/boost_asio.html)

linux: libevent libev libuv

boost.asio 跨平台，主要用于winddows
as: async 异步

同步io reactor(非阻塞io) 阻塞IO网络模型
异步io iocp(windows)
接口上：read accept connect write 返回，io已经完成
       WSARecv AcceptEx ConnectEx WSASend 返回，io没结束

原理：
阻塞io:客户端等待服务端产生服务
reactor:服务端有服务就通知，客户端被通知再被服务(不用等待服务端请求)
异步io:服务端有服务可以不通知，客户端也不用等待，客户端什么时候请求，服务端再服务

本质：
封装操作系统提供的API接口，并进行一定的扩展，向上提供更强大的服务
为什么不直接用操作系统提供的接口呢？
答:在大型的项目中要处理的旁支非常多，用原生的接口的话是比较麻烦的
