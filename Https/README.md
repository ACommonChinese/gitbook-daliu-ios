# Https

参考:  
- [https://blog.csdn.net/qq_35612929/article/details/60962138](https://blog.csdn.net/qq_35612929/article/details/60962138) 
- [https://baike.baidu.com/item/RSA%E7%AE%97%E6%B3%95/263310?fromtitle=RSA&fromid=210678&fr=aladdin](https://baike.baidu.com/item/RSA%E7%AE%97%E6%B3%95/263310?fromtitle=RSA&fromid=210678&fr=aladdin) 
- [https://www.cnblogs.com/dianming/p/7008931.html](https://www.cnblogs.com/dianming/p/7008931.html)
- [https://cheapsslsecurity.com/blog/what-is-ssl-tls-handshake-understand-the-process-in-just-3-minutes/](https://cheapsslsecurity.com/blog/what-is-ssl-tls-handshake-understand-the-process-in-just-3-minutes/)  
- 翻墙 [https://www.youtube.com/watch?v=ERp8420ucGs](https://www.youtube.com/watch?v=ERp8420ucGs)

### 说明

HTTP协议以明文方式发送内容，不提供任何方式的数据加密，如果攻击者截取了client和server之间的传输报文，就可以直接读懂其中的信息，因此HTTP协议不适合传输一些敏感信息, HTTP缺点如下:  

1. 通信使用明文(不加密), 内容可能会被窃听
2. 不验证通信方的身份, 因此有可能遭遇伪装
3. 无法证明报文的完整性, 所以有可能已遭篡改

- 为了数据传输的安全，HTTPS在HTTP的基础上加入了SSL协议，SSL依靠证书来验证服务器的身份，并为client和服务器之间的通信加密  
- HTTPS将HTTP协议数据包放到SSL/TSL层加密后，在TCP/IP层组成IP数据报去传输，以此保证传输数据的安全；而对于接收端，在SSL/TSL将接收的数据包解密之后，将数据传给HTTP协议层  
- https默认使用端口号443, 而Http默认是80, https基于Http之上主要做两件事: 身份认证和加密传输, 缺点是由于需要在SSL认证加密耗时, 因此会比HTTP慢    
- HTTPS并非是应用层的一种新协议. 只是HTTP通信接口部分用SSL(Secure Socket Layer)和TLS(Transport Layer Security)协议代替而已. 通常HTTP直接和TCP通信, 当使用SSL时, 则演变成先和SSL通信, 再由SSL和TCP通信了. 简言之, HTTPS就是身披SSL协议这导外壳的HTTP  

**Http的缺点和解决方法**

1. 通信使用明文(不加密), 内容可能会被窃听  ----> 通过加密解决
2. 不验证通信方的身份, 因此有可能遭遇伪装 ----> 通过认证彼此身份解决
3. 无法证明报文的完整性, 所以有可能已遭篡改 ----> 通过数字签字进行完整性保护解决

HTTPS = HTTP + LLS/TLS = HTTP + 加密 + 认证 + 完整性保护

-----------------------------

### 服务器端  

使用Https通信, 首先服务器要支持, 按照一般流程, 要支持https的服务器需发从权威的CA(Certificate Authority)机构申请一个用于证明服务器用途类型的证书。该证书只有用于对应的服务器的时候，客户端才信任此主机。

比如用浏览器访问一些网站的时候，浏览器会自动验证网站的证书，如果证书不是CA签发的，那么浏览器会提示提示你，此网站的证书无效（因为不是指定的机构签发的，有可能是自己签发的）