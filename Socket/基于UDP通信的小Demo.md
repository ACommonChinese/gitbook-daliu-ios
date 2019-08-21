# 基于UDP通信的小Demo


####UDP中的服务器端和客户端没有连接
UDP 不像 TCP，无需在连接状态下交换数据，因此基于 UDP 的服务器端和客户端也无需经过连接过程。也就是说，不必调用 listen() 和 accept() 函数。UDP 中只有创建套接字的过程和数据交换的过程。

####UDP服务器端和客户端均只需1个套接字
TCP 中，套接字是一对一的关系。如要向 10 个客户端提供服务，那么除了负责监听的套接字外，还需要创建 10 套接字。但在 UDP 中，不管是服务器端还是客户端都只需要 1 个套接字。

####基于UDP的接收和发送函数
创建好 TCP 套接字后，传输数据时无需再添加地址信息，因为 TCP 套接字将保持与对方套接字的连接。换言之，TCP 套接字知道目标地址信息。但 UDP 套接字不会保持连接状态，每次传输数据都要添加目标地址信息，这相当于在邮寄包裹前填写收件人地址。

**发送数据sendto()**

```C
#include <sys/socket.h>

ssize_t
send(int socket, const void *buffer, size_t length, int flags);

ssize_t
sendmsg(int socket, const struct msghdr *message, int flags);

ssize_t
sendto(int socket, const void *buffer, size_t length, int flags,
 const struct sockaddr *dest_addr, socklen_t dest_len);

```

sendto函数说明：

- sock: 套接字
- buffer: 保存待传输数据的缓冲区地址
- length: 待传输数据的长度（以字节计）
- flags: 可选项参数，若没有可传递 0
- dest_addr: 存有目标地址信息的 sockaddr 结构体变量的地址
- dest_len: 目标地址结构体变量的长度

可见，UDP 发送函数 sendto() 与TCP发送函数 write()/send() 的最大区别在于，sendto() 函数需要向他传递目标地址信息。

**接收数据**

```C
#include <sys/socket.h>

ssize_t
recv(int socket, void *buffer, size_t length, int flags);

ssize_t
recvfrom(int socket, void *restrict buffer, size_t length, int flags,
 struct sockaddr *restrict address, socklen_t *restrict address_len);

ssize_t
recvmsg(int socket, struct msghdr *message, int flags);
```

recvfrom函数说明：

- socket: 用于接收 UDP 数据的套接字 
- buffer: 保存接收数据的缓冲区地址
- length: 可接收的最大字节数（不能超过 buf 缓冲区的大小） 
- flags: 可选项参数，若没有可传递 0
- address: 发送端地址信息(sockaddr结构体)
- address_len: 发送端地址信息结构体长度

Demo示例如下：
[Demo地址](https://github.com/ACommonChinese/MyGitbookSubDemos/tree/master/UDPSocketDemo)

**server.cpp**

```C++
//
//  server.cpp
//  server_udp
//
//  Created by liuweizhen on 2019/6/21.
//  Copyright © 2019 liuxing8807@126.com. All rights reserved.
//

#include <iostream>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

#define BUF_SIZE 1024

int main(int argc, const char * argv[]) {
    struct sockaddr_in serv_addr;
    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET; // 使用IPv4
    serv_addr.sin_addr.s_addr = htonl(INADDR_ANY); // 如果是TCP, 形如：inet_addr("30.16.104.94");
    serv_addr.sin_port = htons(1234);  //端口
    
    int sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP); // 最后一个参数可写为0
    bind(sock, (const struct sockaddr *)&serv_addr, sizeof(serv_addr));
    
    // listen(serv_sock, 20) UDP不需要监听
    // int clnt_sock = accept(serv_sock, (struct sockaddr *)&clnt_addr, &clnt_addr_size) UDP无连接
    
    // 接收客户端请求
    struct sockaddr_in clnt_addr;
    socklen_t clnt_addr_size = sizeof(clnt_addr);
    char buffer[BUF_SIZE];
    while (1) {
        /**
         ssize_t
         recvfrom(int socket,
                  void *restrict buffer,
                  size_t length,
                  int flags,
                  struct sockaddr *restrict address,
                  socklen_t *restrict address_len);
         */

        ssize_t recv_len = recvfrom(sock, buffer, BUF_SIZE, 0, (struct sockaddr *)&clnt_addr, &clnt_addr_size);
    
        sendto(sock, buffer, recv_len, 0, (const struct sockaddr *)&clnt_addr, clnt_addr_size);
    }
    close(sock);
    
    return 0;
}
```

**client.cpp**

```C++
//
//  client.cpp
//  client_udp
//
//  Created by liuweizhen on 2019/6/21.
//  Copyright © 2019 liuxing8807@126.com. All rights reserved.
//

#include <iostream>
#include <stdio.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <string.h>

#define BUF_SIZE 1024

int main(int argc, const char * argv[]) {
    // 服务器地址信息
    struct sockaddr_in serv_addr;
    memset(&serv_addr, 0, sizeof(serv_addr));  //每个字节都用0填充
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = inet_addr("30.16.104.120");
    serv_addr.sin_port = htons(1234);

    int sock = socket(AF_INET, SOCK_DGRAM, 0);

    // 不断获取用户输入并发送给服务器，然后接受服务器数据
    struct sockaddr_in fromaddr;
    size_t fromaddr_len = sizeof(fromaddr);

    while (1) {
        char buffer[BUF_SIZE] = {0};
        printf("Input a string:");
        gets(buffer);
        sendto(sock, buffer, strlen(buffer), 0, (const struct sockaddr *)&serv_addr, sizeof(serv_addr)); // 发送给server，带上server地址
        ssize_t rec_len = recvfrom(sock, buffer, BUF_SIZE, 0, (struct sockaddr *)&fromaddr, (socklen_t *)&fromaddr_len);

        // buffer[rec_len] = {0};
        printf("Message form server: %s - length: %ld字节\n", buffer, rec_len);
    }

    close(sock);

    return 0;
}
```
运行：

```
g++ server.cpp -o server
g++ client.cpp -o client

./server
./client
```
