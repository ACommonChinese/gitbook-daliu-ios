# 分析AFNetworking

参考: 
- [简书](https://www.jianshu.com/p/3e6b24446d54)
- [AF](https://github.com/AFNetworking/AFNetworking) 

AF官网说法: 

### Security Policy

`AFSecurityPolicy` evaluates server trust against pinned X.509 certificates and public keys over secure connections.

Adding pinned SSL certificates to your app helps prevent man-in-the-middle attacks and other vulnerabilities. Applications dealing with sensitive customer data or financial information are strongly encouraged to route all communication over an HTTPS connection with SSL pinning configured and enabled.

#### Allowing Invalid SSL Certificates

```
AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
manager.securityPolicy.allowInvalidCertificates = YES; // 
```

AFSecurityPolicy是针对HTTPS连接时做的证书认证

The security policy used by created session to evaluate server trust for secure connections. `AFURLSessionManager` uses the `defaultPolicy` unless otherwise specified. A security policy configured with `AFSSLPinningModePublicKey` or `AFSSLPinningModeCertificate` can only be applied on a session manager initialized with a secure base URL (i.e. https). Applying a security policy with pinning enabled on an insecure session manager throws an `Invalid Security Policy` exception.

```
// -- AFHTTPSessionManager.h --
@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;
```

继承自AFURLSessionManager, 在初始化时赋值: 

```
self.securityPolicy = [AFSecurityPolicy defaultPolicy];
```

### 流程 

首先, 用于认证的challenge有两种, 一是基于session的, 一是基于task的, 即:

session-wide and task-wide 
[这里](https://developer.apple.com/documentation/foundation/urlprotectionspace/nsurlprotectionspace_authentication_method_constants) 哪些方法是sesison-wide, 哪些方法是task-wide 


```objective-c
typedef NS_ENUM(NSInteger, NSURLSessionAuthChallengeDisposition) {
    NSURLSessionAuthChallengeUseCredential = 0,                                       /* Use the specified credential, which may be nil */
    NSURLSessionAuthChallengePerformDefaultHandling = 1,                              /* Default handling for the challenge - as if this delegate were not implemented; the credential parameter is ignored. */
    NSURLSessionAuthChallengeCancelAuthenticationChallenge = 2,                       /* The entire request will be canceled; the credential parameter is ignored. */
    NSURLSessionAuthChallengeRejectProtectionSpace = 3,                               /* This challenge is rejected and the next authentication protection space should be tried; the credential parameter is ignored. */
} API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0));
```

**session级别的认证**  
```Objective-c
// 对服务器的认证会走这里
// AF没有做处理, 而是交给了self.sessionDidReceiveAuthenticationChallenge处理
- (void)URLSession:(NSURLSession *)session
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    NSAssert(self.sessionDidReceiveAuthenticationChallenge != nil, @"`respondsToSelector:` implementation forces `URLSession:didReceiveChallenge:completionHandler:` to be called only if `self.sessionDidReceiveAuthenticationChallenge` is not nil");

    NSURLCredential *credential = nil;
    NSURLSessionAuthChallengeDisposition disposition = self.sessionDidReceiveAuthenticationChallenge(session, challenge, &credential);

    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}
```

```objective-c
- (void)setSessionDidReceiveAuthenticationChallengeBlock:(NSURLSessionAuthChallengeDisposition (^)(NSURLSession *session, NSURLAuthenticationChallenge *challenge, NSURLCredential * __autoreleasing *credential))block {
    self.sessionDidReceiveAuthenticationChallenge = block;
}
```

**task级别的认证**  
```objective-c
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    BOOL evaluateServerTrust = NO;
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    NSURLCredential *credential = nil;

    if (self.authenticationChallengeHandler) {
        id result = self.authenticationChallengeHandler(session, task, challenge, completionHandler);
        if (result == nil) {
            return;
        } else if ([result isKindOfClass:NSError.class]) {
            objc_setAssociatedObject(task, AuthenticationChallengeErrorKey, result, OBJC_ASSOCIATION_RETAIN);
            disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
        } else if ([result isKindOfClass:NSURLCredential.class]) {
            credential = result;
            disposition = NSURLSessionAuthChallengeUseCredential;
        } else if ([result isKindOfClass:NSNumber.class]) {
            disposition = [result integerValue];
            NSAssert(disposition == NSURLSessionAuthChallengePerformDefaultHandling || disposition == NSURLSessionAuthChallengeCancelAuthenticationChallenge || disposition == NSURLSessionAuthChallengeRejectProtectionSpace, @"");
            evaluateServerTrust = disposition == NSURLSessionAuthChallengePerformDefaultHandling && [challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
        } else {
            @throw [NSException exceptionWithName:@"Invalid Return Value" reason:@"The return value from the authentication challenge handler must be nil, an NSError, an NSURLCredential or an NSNumber." userInfo:nil];
        }
    } else {
        evaluateServerTrust = YES;
    }

    if (evaluateServerTrust) {
        if ([self.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
            disposition = NSURLSessionAuthChallengeUseCredential;
            credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        } else {
            objc_setAssociatedObject(task, AuthenticationChallengeErrorKey, ServerTrustError(challenge.protectionSpace.serverTrust, task.currentRequest.URL), OBJC_ASSOCIATION_RETAIN);
            disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
        }
    }

    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}
```

项目代码:  

**MyBaseNetworkManager**  

```objective-c
- (instancetype)init {
    self = [super init];
    if (self) {
        // ...
        // Session did receive authentication challenge
        [BMKNetworkManager sharedManager].sessionDidReceiveAuthenticationChallenge =
            ^NSURLSessionAuthChallengeDisposition(NSURLSession *session,
                                                  NSURLAuthenticationChallenge *challenge,
                                                  NSURLCredential *__autoreleasing *credential) {
                return [MyBaseCertTrustManager authChallengeDisposition:session
                                                              challenge:challenge
                                                             credential:credential];
            };
    }
    return self;
}
```

```objective-c
@interface BMBaseCertTrustManager : NSObject

+ (NSURLSessionAuthChallengeDisposition
    )authChallengeDisposition:(NSURLSession *)session
challenge:(NSURLAuthenticationChallenge *)challenge
credential:(NSURLCredential * _Nullable __autoreleasing *_Nullable)credential;

@end
```

```objective-c
#import "MyBaseCertTrustManager.h"
#import <AssertMacros.h>
#import "rootcert.h"

static NSString * const kCertDataBegin = @"-----BEGIN CERTIFICATE-----";
static NSString * const kCertDataEnd = @"-----END CERTIFICATE-----";
static NSString * const kDomain1NAME = @".domain1.com";
static NSString * const kDomain2NAME = @".domain2.com";

static BOOL MyBaseServerTrustIsValid(SecTrustRef serverTrust) {
    BOOL isValid = NO;
    SecTrustResultType result;
    __Require_noErr_Quiet(SecTrustEvaluate(serverTrust, &result), _out);
    
    isValid = (result == kSecTrustResultUnspecified || result == kSecTrustResultProceed);
    
_out:
    return isValid;
}

static NSArray * MyBaseCertificateTrustChainForServerTrust(SecTrustRef serverTrust) {
    CFIndex certificateCount = SecTrustGetCertificateCount(serverTrust);
    NSMutableArray *trustChain = [NSMutableArray arrayWithCapacity:(NSUInteger)certificateCount];
    
    for (CFIndex i = 0; i < certificateCount; i++) {
        SecCertificateRef certificate = SecTrustGetCertificateAtIndex(serverTrust, i);
        [trustChain addObject:(__bridge id)certificate];
    }
    
    return [NSArray arrayWithArray:trustChain];
}

static id MyBasePublicKeyForCertificate(NSData *certificate) {
    id allowedPublicKey = nil;
    SecCertificateRef allowedCertificate;
    SecPolicyRef policy = nil;
    SecTrustRef allowedTrust = nil;
    SecTrustResultType result;
    
    allowedCertificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)certificate);
    __Require_Quiet(allowedCertificate != NULL, _out);
    
    policy = SecPolicyCreateBasicX509();
    __Require_noErr_Quiet(SecTrustCreateWithCertificates(allowedCertificate, policy, &allowedTrust),
                          _out);
    __Require_noErr_Quiet(SecTrustEvaluate(allowedTrust, &result), _out);
    
    allowedPublicKey = (__bridge_transfer id)SecTrustCopyPublicKey(allowedTrust);
    
_out:
    if (allowedTrust) {
        CFRelease(allowedTrust);
    }
    
    if (policy) {
        CFRelease(policy);
    }
    
    if (allowedCertificate) {
        CFRelease(allowedCertificate);
    }
    
    return allowedPublicKey;
}

@implementation MyBaseCertTrustManager

+ (NSURLSessionAuthChallengeDisposition
   )authChallengeDisposition:(NSURLSession *)session
challenge:(NSURLAuthenticationChallenge *)challenge
credential:(NSURLCredential *__autoreleasing *)credential {
    if ([challenge.protectionSpace.authenticationMethod
         isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        // Verify server trust
        if (!MyBaseServerTrustIsValid(challenge.protectionSpace.serverTrust)) {
            return NSURLSessionAuthChallengeCancelAuthenticationChallenge;
        }
        
        // Verify trust chain
        NSArray * trustChain =
            MyBaseCertificateTrustChainForServerTrust(challenge.protectionSpace.serverTrust);
        if (!trustChain || trustChain.count == 0) {
            return NSURLSessionAuthChallengeCancelAuthenticationChallenge;
        }
        
        if (![self verifyTrustChain:trustChain]) {
            return NSURLSessionAuthChallengeCancelAuthenticationChallenge;
        }

        // Ignore verifying before iOS 10.3
        BOOL foundRoot = YES;
        if (@available(iOS 10.3, *)) {
            foundRoot = NO;
        }
        if (foundRoot) {
            return NSURLSessionAuthChallengePerformDefaultHandling;
        }
        
        // Find root cert
        SecCertificateRef lastCertRef = (__bridge SecCertificateRef)(trustChain.lastObject);
        NSString *issueSequence = [self issuerSequence:lastCertRef];
        NSArray<id> *rootCerts = [self rootCerts];
        for (id rootCert in rootCerts) {
            SecCertificateRef certRef = (__bridge SecCertificateRef)rootCert;
            NSString *subjectSequence = [self subjectSequence:certRef];
            if ([subjectSequence isEqualToString:issueSequence]) {
                // Root cert public key
                SecKeyRef publicKey =
                (__bridge SecKeyRef
                 )(MyBasePublicKeyForCertificate((__bridge_transfer NSData
                                                  *)SecCertificateCopyData(certRef)));
                if (!publicKey) {
                    return NSURLSessionAuthChallengeCancelAuthenticationChallenge;
                }
                
                // Verify public key in last certificate ref
                SecKeyRef publicKey2 =
                (__bridge SecKeyRef
                 )(MyBasePublicKeyForCertificate((__bridge_transfer NSData
                                                  *)SecCertificateCopyData(lastCertRef)));
                
                if ([(__bridge id)publicKey isEqual:(__bridge id)publicKey2]) {
                    foundRoot = YES;
                }
                break;
            }
        }
        
        // Failed to authentication challenge if root cert not found
        if (!foundRoot) {
            return NSURLSessionAuthChallengeCancelAuthenticationChallenge;
        }
        
        // Credential
        *credential = [NSURLCredential
                      credentialForTrust:challenge.protectionSpace.serverTrust];
        if (credential) {
            return NSURLSessionAuthChallengeUseCredential;
        }
    }
    return NSURLSessionAuthChallengePerformDefaultHandling;
}

+ (BOOL)verifyTrustChain:(NSArray *)trustChain {
    if (@available(iOS 10.3, *)) {
        // Ignore verifying before iOS 10.3
    } else {
        return YES;
    }
    // Previous certificate
    NSString *previousIssuerSequence = nil;
    SecCertificateRef previousCertRef = NULL;

    // Retrive trust chain reversed
    for (id certificate in [trustChain reverseObjectEnumerator]) {
        // Convert to certificate ref
        SecCertificateRef certRef = (__bridge SecCertificateRef)certificate;
        
        // Certificate issuer sequence
        NSString *issuerSequence = [self issuerSequence:certRef];
        
        // Certificate subject sequence
        NSString *subjectSequence = [self subjectSequence:certRef];
        
        // Compare previous subject sequence to current issuer sequence
        if (![NSString isNullOrEmpty:previousIssuerSequence]) {
            if (![issuerSequence isEqualToString:previousIssuerSequence]) {
                // Invalid authentication challenage
                return NO;
            }
            
            // Get previous certificate public key
            SecKeyRef publicKey =
            (__bridge SecKeyRef
             )(MyBasePublicKeyForCertificate((__bridge_transfer NSData
                                              *)SecCertificateCopyData(previousCertRef)));
            if (!publicKey) {
                return NO;
            }
            
            // Verify public key in current certificate
//            SecKeyRef publicKey2 =
//            (__bridge SecKeyRef
//             )(MyBasePublicKeyForCertificate((__bridge_transfer NSData
//                                              *)SecCertificateCopyData(certRef)));
//
//            if (![(__bridge id)publicKey isEqual:(__bridge id)publicKey2]) {
//                // return NO;
//            }
//
//            NSLog(@"######### PublicKey: %@", publicKey);
//            NSLog(@"######### PublicKey: %@", publicKey2);
        }
        
        // Keep previous subject sequence
        previousIssuerSequence = subjectSequence;
        
        // Keep previous cert ref
        previousCertRef = certRef;
    }
    
    // Check the top certificate domain
    SecCertificateRef firstCertRef = (__bridge SecCertificateRef)(trustChain.firstObject);
    CFStringRef subjectRef = SecCertificateCopySubjectSummary(firstCertRef);
    NSString *subject = (__bridge NSString *)subjectRef;
    
    // Check domain for *.domain1.com & *.domin2.com
    if ([NSString isNullOrEmpty:subject] ||
        (![subject contains:kDomain1NAME] &&
        ![subject contains:kDomain2NAME])) {
        return NO;
    }
    
    return YES;
}

+ (NSString *)serialNumber:(SecCertificateRef)certificate {
    CFDataRef serialRef = NULL;
    if (@available(iOS 11.0, *)) {
        CFErrorRef error;
        serialRef = SecCertificateCopySerialNumberData(certificate, &error);
    } else if (@available(iOS 10.3, *)) {
        serialRef = SecCertificateCopySerialNumber(certificate);
    }
    
    if (serialRef) {
        NSData *serialData = (__bridge NSData *)serialRef;
        
        // Return hexed serial
        return [serialData hexString];
    }
    return nil;
}

+ (NSString *)issuerSequence:(SecCertificateRef)certificate {
    if (@available(iOS 10.3, *)) {
        CFDataRef issuerSequenceRef = SecCertificateCopyNormalizedIssuerSequence(certificate);
        return [(__bridge_transfer NSData *)issuerSequenceRef
                base64EncodedStringWithOptions:0];
    }
    return nil;
}

+ (NSString *)subjectSequence:(SecCertificateRef)certificate {
    if (@available(iOS 10.3, *)) {
        CFDataRef subjectSequenceRef = SecCertificateCopyNormalizedSubjectSequence(certificate);
        return [(__bridge_transfer NSData *)subjectSequenceRef
                base64EncodedStringWithOptions:0];
    }
    return nil;
}

+ (NSArray<id> *)rootCerts {
    // Create certs array
    NSMutableArray<id> *rootCerts = [NSMutableArray<id> array];

    // Get whole cert string
    NSString *s = [[self certString] replace:@"\n" withString:@""];
    NSArray<NSString *> *certStrings = [s splitBy:kCertDataEnd];
    for (NSString *certString in certStrings) {
        NSString *s = [certString replace:kCertDataBegin withString:@""];
        if (![NSString isNullOrEmpty:s]) {
            NSData *certData = [[NSData
                                 alloc] initWithBase64EncodedString:s
                                options:NSDataBase64DecodingIgnoreUnknownCharacters];
            [rootCerts addObject:(__bridge id)SecCertificateCreateWithData(NULL,
                                                              (__bridge CFDataRef)certData)];
        }
    }
    
    return rootCerts.copy;
}

+ (NSString *)certString {
    return [NSString
            stringWithFormat:@"%@%@%@%@%@%@",
            certString1,
            certString2,
            certString3,
            certString4,
            certString5,
            certString6];
}

@end
```

