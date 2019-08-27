# NSInputStream_NSOutputStream_Socket

我们写一个Demo, 使用NSInputStream和NSOutputStream作数输入流和数出流进行Socket通信。
NSInputStream和NSOutputStream对应CoreFoundation里的CFReadStreamRef和CFWriteStreamRef, 这是对BSD Socket的高层抽象。

Demo达到的目的：
1. 开启server
2. client()向server发起连接
3. server向client发送数据：喜欢什么水果？并让client填入喜欢的水果的序号
4. client把序号发给server
5. server把client想要的水果发给client

先用c写一个server:
[源代码](https://github.com/ACommonChinese/MyGitbookSubDemos/tree/master/CFSocket/server_cpp)

```C
//
//  main.cpp
//  server_cpp
//
//  Created by liuweizhen on 2019/6/6.
//  Copyright © 2019 DaLiu. All rights reserved.
//  http://c.biancheng.net/view/2128.html

#include <iostream>
#include <string.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

int main(int argc, const char * argv[]) {
    /**
     创建套接字
     名字: socket -- create an endpoint for communication
     概要，大纲（synopsis[sɪ'nɑpsɪs]）：
        #include <sys/socket.h>
        int socket(int domain, int type, int protocol)
     描述（description）:
        参数domain: AF_INET: internetwork: UDP, TCP, etc.  AF_INET6: IPV6
        参数type: SOCK_STREAM SOCK_DGRAM SOCK_RAW
        参数protocol: 协议
     
     tcp_socket = socket(AF_INET, SOCK_STREAM, 0);
     udp_socket = socket(AF_INET, SOCK_DGRAM, 0);
     raw_socket = socket(AF_INET, SOCK_RAW, protocol);
     */
    int serv_sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    
    /**
     struct sockaddr_in {
        sa_family_t sin_family;   // address family: AF_INET 采用的地址，IPv4或IPv6
        in_port_t sin_port;       // port in network byte order 端口
        struct in_addr sin_addr;  // internet address IP地址
     }
     
     // Internet address
     struct in_addr {
        uint32_t s_addr; // address in network byte order
     };
     */
    struct sockaddr_in serv_addr; // 套接字地址
    memset(&serv_addr, 0, sizeof(serv_addr)); // 每个字节都用0填充
    serv_addr.sin_family = AF_INET; // 使用IPv4地址
    serv_addr.sin_addr.s_addr = inet_addr("30.16.108.149"); // IP地址
    serv_addr.sin_port = htons(1234); // 端口号
    /***
     htonl, htons, ntohl, ntohs -- convert values between host and network
     byte order
     即：htonl, htons, ntohl, ntohs这4个函数转换主机节序和网络的字节序。网络中使用大端big endian, 大字节在前
     htonl: Host TO Network Long  ==> uint32_t htonl(uint32_t hostlong);
     htons: Host To Network Short ==> uint16_t htons(uint16_t hostshort);
     ntohl: Network To Host Long  ==> uint32_t ntohl(uint32_t netlong);
     ntohs: Network To Host Short ==> uint16_t ntohs(uint16_t netshort);
     */
    
    // 将套接字和IP、端口绑定
    bind(serv_sock, (const struct sockaddr *)&serv_addr, sizeof(serv_addr));
    
    /**
     listen for connections on a socket   #include <sys/socket.h>
     函数原形：int listen(int sockt, int backlog)
     描述：
     Creation of socket-based connections requires several operations.
     1>. a socket is created with socket.
     2>. a willingness to accept incoming connections and a queue limit for incoming connections are specified
        with listen().
     3>. the connections are accepted with accept.
     The listen() call applies only to sockets of type SOCK_STREAM.
     */
    listen(serv_sock, 20); // 进入监听状态，等待客户端发起请求
    
    // 接收客户端请求
    struct sockaddr_in clnt_addr;
    socklen_t clnt_addr_size = sizeof(clnt_addr);
    int clnt_sock = accept(serv_sock, (struct sockaddr *)&clnt_addr, &clnt_addr_size);
    // The call returns -1 on error and the global variable errno is set to
    // indicate the error.  If it succeeds, it returns a non-negative integer
    // that is a descriptor for the accepted socket.

    switch (clnt_sock) { // On success,  these system calls return a nonnegative integer that is a descriptor for the accepted socket. 即，如果accept成功，此值应为正数
        case -1: {
            printf("The call returns -1 on error and the global variable errno is set to indicate the error. \n");
            printf("【%d】", errno); // errno: http://man.he.net/?topic=errno&section=all
            break;
        }
        case EBADF:
            printf("EBADF: socket is not a valid file descriptor.\n");
            break;
        case ECONNABORTED:
            printf("ECONNABORTED: The connection to socket has been aborted.\n");
            break;
        case EFAULT:
            printf("EFAULT: The address parameter is not in a writable part of the user address space.\n");
            break;
        case EINTR:
            printf("EINTR: The accept() system call was terminated by a signal.\n");
            break;
        case EINVAL:
            printf("EINVAL: socket is unwilling to accept connections.\n");
            break;
        case EMFILE:
            printf("EMFILE:  The per-process descriptor table is full.\n");
            break;
        case ENFILE:
            printf("ENFILE: The system file table is full.\n");
            break;
        case ENOMEM:
            printf("ENOMEM: Insufficient memory was available to complete the operation.\n");
            break;
        case ENOTSOCK:
            printf("ENOTSOCK:  socket references a file type other than a socket.\n");
            break;
        case EOPNOTSUPP:
            printf("EOPNOTSUPP: socket is not of type SOCK_STREAM and thus does not accept connections.\n");
            break;
        case EWOULDBLOCK:
            printf("EWOULDBLOCK: socket is marked as non-blocking and no connections are present to be accepted.\n");
            break;
        default:
            break;
    }

    char str[] = "你想要哪一种水果?\n1. 苹果 \n2. 桔子\n3. 香蕉\n";
    write(clnt_sock, str, sizeof(str)); // 发送给客户端
    
    int buffer;
    read(clnt_sock, (void *)&buffer, sizeof(buffer));
 
    switch (buffer) {
            case 1: {
                char fruits[100] = "苹果...";
                write(clnt_sock, (const void *)fruits, sizeof(fruits));
                break;
            }
            case 2: {
                char fruits[100] = "桔子...";
                write(clnt_sock, (const void *)fruits, sizeof(fruits));
                break;
            }
            case 3: {
                char fruits[100] = "香蕉...";
                write(clnt_sock, (const void *)fruits, sizeof(fruits));
                break;
            }
        default:
            break;
    }

    /** 另一次连结
    int clnt_sock2 = accept(serv_sock, (struct sockaddr *)&clnt_addr, &clnt_addr_size);
    if (clnt_sock2 == -1) {
        std::cout << "failure for accept" << std::endl;
    }
     */

    // 关闭套接字
    close(clnt_sock);
    close(serv_sock);
    
    return 0;
}
```

接下来写iOS客户端代码：

[源代码](https://github.com/ACommonChinese/MyGitbookSubDemos/tree/master/CFSocket/SubDemos/SubDemos/ViewController_4)

```Objective-C
#import "Cell_4_ViewController.h"

static int32_t const kStreamBufferSize = 2048;

@interface Cell_4_ViewController () <NSStreamDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, strong) NSOutputStream *outputStream;

@end

@implementation Cell_4_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)sendToServer:(id)sender {
    int inputNum = [self.textField.text intValue];
    if ([self.outputStream hasSpaceAvailable]) {
        [self.outputStream write:(const uint8_t *)&inputNum maxLength:sizeof(inputNum)];
    }
}

- (IBAction)connectToHost:(id)sender {
    NSString *host = @"30.16.108.149";
    UInt32 port = 1234;
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                       (__bridge CFStringRef)host,
                                       port,
                                       &readStream,
                                       &writeStream);
    _inputStream = (__bridge NSInputStream *)(readStream);
    _outputStream = (__bridge NSOutputStream *)(writeStream);
    _inputStream.delegate = self;
    _outputStream.delegate = self;
    [_inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [_inputStream open];
    [_outputStream open];
}

#pragma mark - <NSStreamDelegate>

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    /**
     typedef NS_OPTIONS(NSUInteger, NSStreamEvent) {
         NSStreamEventNone = 0, // 无事件
         NSStreamEventOpenCompleted = 1UL << 0, // 打开成功
         NSStreamEventHasBytesAvailable = 1UL << 1, // 有字节可读（输入流）
         NSStreamEventHasSpaceAvailable = 1UL << 2, // 有空间，可以发放字节 （输出流）
         NSStreamEventErrorOccurred = 1UL << 3, // 连接出现错误
         NSStreamEventEndEncountered = 1UL << 4 // 连接结束
     };
     */
    NSMutableData *receivedData = nil;
    switch (eventCode) {
        case NSStreamEventOpenCompleted:
            if (aStream == self.inputStream && self.inputStream.streamStatus == NSStreamStatusOpen) {
                NSLog(@"输入流打开成功");
            }
            else if (self.outputStream.streamStatus == NSStreamStatusOpen) {
                // connectionStatusDidChange:NSStreamEventOpenCompleted
                NSLog(@"输出流打开成功");
            }
            break;
        case NSStreamEventHasBytesAvailable: {
            NSLog(@"inputStream 有字节可读");
            if (receivedData == nil) {
                receivedData = [[NSMutableData alloc] init];
            }
            uint8_t streamBuffer[kStreamBufferSize] = {0};
            NSInteger numBytesRead = [(NSInputStream *)aStream read:streamBuffer maxLength:kStreamBufferSize];
            if (numBytesRead == 0) {
                NSLog(@"inputStream读取完毕");
                [self clear];
                return;
            }
            else if (numBytesRead < 0) {
                NSLog(@"inputStream读取出现错误");
                return;
            }

            [receivedData appendBytes:streamBuffer length:numBytesRead];
            NSLog(@"inputStream读取数据%d字节", (int)numBytesRead);

            while ([(NSInputStream *)aStream hasBytesAvailable]) {
                numBytesRead = [(NSInputStream *)aStream read:streamBuffer maxLength:kStreamBufferSize];
                NSLog(@"inputStream读取数据%d字节", (int)numBytesRead);
                [receivedData appendBytes:streamBuffer length:numBytesRead];
            }
            NSString *str = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
            self.label.text = [NSString stringWithFormat:@"%@", str];

            break;
        }
        case NSStreamEventHasSpaceAvailable: {
            NSLog(@"outputStream 有空间，可以发送字节");

            break;
        }
        case NSStreamEventErrorOccurred: {
            NSLog(@"连接出现错误");
            break;
        }
        case NSStreamEventEndEncountered: {
            NSLog(@"连接结束");
            [self clear];
            break;
        }
        default:
            break;
    }
}

- (void)clear {
    [self.inputStream close];
    [self.outputStream close];
    [self.inputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}
@end
```


