/* If implemented, when a connection level authentication challenge
 * has occurred, this delegate will be given the opportunity to
 * provide authentication credentials to the underlying
 * connection. Some types of authentication will apply to more than
 * one request on a given connection to a server (SSL Server Trust
 * challenges).  If this delegate message is not implemented, the 
 * behavior will be to use the default handling, which may involve user
 * interaction. 
 */
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
                                             completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler;


/* The task has received a request specific authentication challenge.
 * If this delegate is not implemented, the session specific authentication challenge
 * will *NOT* be called and the behavior will be the same as using the default handling
 * disposition. 
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
                            didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge 
                              completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler;

https://github.com/openhab/openhab-ios

根:
(subject)主题密钥标识符 60:7B:66:1A:45:0D:97:CA:89:50:2F:7D:04:CD:34:A8:FF:FC:FD:4B   

二级证书
(issuer)颁发机构密钥标识符  60:7B:66:1A:45:0D:97:CA:89:50:2F:7D:04:CD:34:A8:FF:FC:FD:4B
(subject)主题密钥标识符 96:DE:61:F1:BD:1C:16:29:53:1C:C0:CC:7D:3B:83:00:40:E6:1A:7C

百度
(issuer)颁发机构密钥标识符 96:DE:61:F1:BD:1C:16:29:53:1C:C0:CC:7D:3B:83:00:40:E6:1A:7C
(subject)主题密钥标识符 76:B5:E6:D6:49:F8:F8:36:EA:75:A9:6D:5E:4D:55:5B:37:5C:FD:C7

+ (NSURLSessionAuthChallengeDisposition
   )authChallengeDisposition:(NSURLSession *)session
challenge:(NSURLAuthenticationChallenge *)challenge
credential:(NSURLCredential *__autoreleasing *)credential {
	NSLog(@"host: %@", challenge.protectionSpace.host);  
	// host: bmopen-api-test.ebanma.com

    if ([challenge.protectionSpace.authenticationMethod
         isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        // Verify server trust
        if (!BMBaseServerTrustIsValid(challenge.protectionSpace.serverTrust)) {
            return NSURLSessionAuthChallengeCancelAuthenticationChallenge;
        }
        
        // Verify trust chain
        // po trustChain.count   3
        NSArray * trustChain =
            BMBaseCertificateTrustChainForServerTrust(challenge.protectionSpace.serverTrust);
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
        // 根证书
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
                 )(BMBasePublicKeyForCertificate((__bridge_transfer NSData
                                                  *)SecCertificateCopyData(certRef)));
                if (!publicKey) {
                    return NSURLSessionAuthChallengeCancelAuthenticationChallenge;
                }
                
                // Verify public key in last certificate ref
                SecKeyRef publicKey2 =
                (__bridge SecKeyRef
                 )(BMBasePublicKeyForCertificate((__bridge_transfer NSData
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


BMBaseCertTrustManager

第一步: 验证通过
static BOOL BMBaseServerTrustIsValid(SecTrustRef serverTrust) {
    BOOL isValid = NO;
    SecTrustResultType result;
    __Require_noErr_Quiet(SecTrustEvaluate(serverTrust, &result), _out);
    
    isValid = (result == kSecTrustResultUnspecified || result == kSecTrustResultProceed);
    
_out:
    return isValid;
}

第二步: 
1. 验证证书链中sequence: subject == 下一个证书的issuer
2. 验证叶子证书的域名
+ (BOOL)verifyTrustChain:(NSArray *)trustChain {
    if (@available(iOS 10.3, *)) {
        // Ignore verifying before iOS 10.3
    } else {
        return YES;
    }
    // Previous certificate
    NSString *previousIssuerSequence = nil; // 这样理解较合理: 上一个subject
    SecCertificateRef previousCertRef = NULL;

    // Retrive trust chain reversed
    // 注: 默认情况下[叶证书, 中间证书, 根证书] 
    // 此处反序了一下, 即变成了[根证书, 中间证书, 叶证书]
    for (id certificate in [trustChain reverseObjectEnumerator]) {
        // Convert to certificate ref
        SecCertificateRef certRef = (__bridge SecCertificateRef)certificate;
        
        // Certificate issuer sequence
        // 获取数据之后Base64化
        // 第一次获取为: MFcxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHTE9CQUxTSUdOIE5WLVNBMRAwDgYDVQQLEwdST09UIENBMRswGQYDVQQDExJHTE9CQUxTSUdOIFJPT1QgQ0E=
        // 第二次获取为: MFcxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHTE9CQUxTSUdOIE5WLVNBMRAwDgYDVQQLEwdST09UIENBMRswGQYDVQQDExJHTE9CQUxTSUdOIFJPT1QgQ0E=
        // 第三次获取为: MGYxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHTE9CQUxTSUdOIE5WLVNBMTwwOgYDVQQDEzNHTE9CQUxTSUdOIE9SR0FOSVpBVElPTiBWQUxJREFUSU9OIENBIC0gU0hBMjU2IC0gRzI=
        NSString *issuerSequence = [self issuerSequence:certRef];
        
        // Certificate subject sequence
        // 第一次获取为: MFcxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHTE9CQUxTSUdOIE5WLVNBMRAwDgYDVQQLEwdST09UIENBMRswGQYDVQQDExJHTE9CQUxTSUdOIFJPT1QgQ0E=
        // 第二次获取为: MGYxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHTE9CQUxTSUdOIE5WLVNBMTwwOgYDVQQDEzNHTE9CQUxTSUdOIE9SR0FOSVpBVElPTiBWQUxJREFUSU9OIENBIC0gU0hBMjU2IC0gRzI=
        // 第三次获取为: MIGAMQswCQYDVQQGEwJDTjERMA8GA1UECBMIU0hBTkdIQUkxETAPBgNVBAcTCFNIQU5HSEFJMQswCQYDVQQLEwJJVDEnMCUGA1UECgwe5paR6ams572R57uc5oqA5pyv5pyJ6ZmQ5YWs5Y+4MRUwEwYDVQQDDAwqLmViYW5tYS5jb20=
        // 即根证书的 issuer 和 subject 是相同的
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
             )(BMBasePublicKeyForCertificate((__bridge_transfer NSData
                                              *)SecCertificateCopyData(previousCertRef)));
            if (!publicKey) {
                return NO;
            }
            
            // Verify public key in current certificate
//            SecKeyRef publicKey2 =
//            (__bridge SecKeyRef
//             )(BMBasePublicKeyForCertificate((__bridge_transfer NSData
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
    // 这是叶子证书
    SecCertificateRef firstCertRef = (__bridge SecCertificateRef)(trustChain.firstObject);
    CFStringRef subjectRef = SecCertificateCopySubjectSummary(firstCertRef);
    // 注, SecCertificateCopyNormalizedSubjectSequence 是获取subject sequence
    // 而此处的 SecCertificateCopySubjectSummary 获取的是域名, 打印出来是: *.ebanma.com
    NSString *subject = (__bridge NSString *)subjectRef;
    
    // Check domain for *.zebred.com & *.ebanma.com
    // static NSString * const kZebraCN_NAME = @".zebred.com";
	// static NSString * const kBanmaCN_NAME = @".ebanma.com";
    if ([NSString isNullOrEmpty:subject] ||
        (![subject contains:kZebraCN_NAME] &&
        ![subject contains:kBanmaCN_NAME])) {
        return NO;
    }
    
    return YES;
}

总结: 这个方法主要做了两件事情:
1. 验证证书链中sequence: subject == 下一个证书的issuer
2. 验证叶子证书的域名


-------------------------------------------------------


-------------- 第 1 次 ----------------
issuer: MFcxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHTE9CQUxTSUdOIE5WLVNBMRAwDgYDVQQLEwdST09UIENBMRswGQYDVQQDExJHTE9CQUxTSUdOIFJPT1QgQ0E=
subject: MFcxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHTE9CQUxTSUdOIE5WLVNBMRAwDgYDVQQLEwdST09UIENBMRswGQYDVQQDExJHTE9CQUxTSUdOIFJPT1QgQ0E=

-------------- 第 2 次 ----------------
issuer: MFcxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHTE9CQUxTSUdOIE5WLVNBMRAwDgYDVQQLEwdST09UIENBMRswGQYDVQQDExJHTE9CQUxTSUdOIFJPT1QgQ0E=
subject: MGYxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHTE9CQUxTSUdOIE5WLVNBMTwwOgYDVQQDEzNHTE9CQUxTSUdOIE9SR0FOSVpBVElPTiBWQUxJREFUSU9OIENBIC0gU0hBMjU2IC0gRzI=

-------------- 第 3 次 ----------------
issuer: MGYxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHTE9CQUxTSUdOIE5WLVNBMTwwOgYDVQQDEzNHTE9CQUxTSUdOIE9SR0FOSVpBVElPTiBWQUxJREFUSU9OIENBIC0gU0hBMjU2IC0gRzI=
subject: MIGAMQswCQYDVQQGEwJDTjERMA8GA1UECBMIU0hBTkdIQUkxETAPBgNVBAcTCFNIQU5HSEFJMQswCQYDVQQLEwJJVDEnMCUGA1UECgwe5paR6ams572R57uc5oqA5pyv5pyJ6ZmQ5YWs5Y+4MRUwEwYDVQQDDAwqLmViYW5tYS5jb20=

*.ebanma.com


根证书 issue sequence: MFcxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHTE9CQUxTSUdOIE5WLVNBMRAwDgYDVQQLEwdST09UIENBMRswGQYDVQQDExJHTE9CQUxTSUdOIFJPT1QgQ0E=

共166次, 遍历到第74次, 匹配成功

--> 1: MEQxFjAUBgNVBAMMDUFDRURJQ09NIFJvb3QxDDAKBgNVBAsMA1BLSTEPMA0GA1UECgwGRURJQ09NMQswCQYDVQQGEwJFUw==
--> 2: MHsxCzAJBgNVBAYTAkNPMUcwRQYDVQQKDD5Tb2NpZWRhZCBDYW1lcmFsIGRlIENlcnRpZmljYWNpw7NuIERpZ2l0YWwgLSBDZXJ0aWPDoW1hcmEgUy5BLjEjMCEGA1UEAwwaQUMgUmHDrXogQ2VydGljw6FtYXJhIFMuQS4=
--> 3: MGsxCzAJBgNVBAYTAklUMQ4wDAYDVQQHDAVNaWxhbjEjMCEGA1UECgwaQWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxJzAlBgNVBAMMHkFjdGFsaXMgQXV0aGVudGljYXRpb24gUm9vdCBDQQ==
--> 4: MG8xCzAJBgNVBAYTAlNFMRQwEgYDVQQKEwtBRERUUlVTVCBBQjEmMCQGA1UECxMdQUREVFJVU1QgRVhURVJOQUwgVFRQIE5FVFdPUksxIjAgBgNVBAMTGUFERFRSVVNUIEVYVEVSTkFMIENBIFJPT1Q=
--> 5: MGUxCzAJBgNVBAYTAlNFMRQwEgYDVQQKEwtBRERUUlVTVCBBQjEdMBsGA1UECxMUQUREVFJVU1QgVFRQIE5FVFdPUksxITAfBgNVBAMTGEFERFRSVVNUIENMQVNTIDEgQ0EgUk9PVA==
--> 6: MGQxCzAJBgNVBAYTAlNFMRQwEgYDVQQKEwtBRERUUlVTVCBBQjEdMBsGA1UECxMUQUREVFJVU1QgVFRQIE5FVFdPUksxIDAeBgNVBAMTF0FERFRSVVNUIFBVQkxJQyBDQSBST09U
--> 7: MGcxCzAJBgNVBAYTAlNFMRQwEgYDVQQKEwtBRERUUlVTVCBBQjEdMBsGA1UECxMUQUREVFJVU1QgVFRQIE5FVFdPUksxIzAhBgNVBAMTGkFERFRSVVNUIFFVQUxJRklFRCBDQSBST09U
--> 8: MEQxCzAJBgNVBAYTAlVTMRQwEgYDVQQKDAtBZmZpcm1UcnVzdDEfMB0GA1UEAwwWQWZmaXJtVHJ1c3QgQ29tbWVyY2lhbA==
--> 9: MEQxCzAJBgNVBAYTAlVTMRQwEgYDVQQKDAtBZmZpcm1UcnVzdDEfMB0GA1UEAwwWQWZmaXJtVHJ1c3QgTmV0d29ya2luZw==
--> 10: MEExCzAJBgNVBAYTAlVTMRQwEgYDVQQKDAtBZmZpcm1UcnVzdDEcMBoGA1UEAwwTQWZmaXJtVHJ1c3QgUHJlbWl1bQ==
--> 11: MEUxCzAJBgNVBAYTAlVTMRQwEgYDVQQKDAtBZmZpcm1UcnVzdDEgMB4GA1UEAwwXQWZmaXJtVHJ1c3QgUHJlbWl1bSBFQ0M=
--> 12: MGMxCzAJBgNVBAYTAlVTMRwwGgYDVQQKExNBTUVSSUNBIE9OTElORSBJTkMuMTYwNAYDVQQDEy1BTUVSSUNBIE9OTElORSBST09UIENFUlRJRklDQVRJT04gQVVUSE9SSVRZIDE=
--> 13: MGMxCzAJBgNVBAYTAlVTMRwwGgYDVQQKExNBTUVSSUNBIE9OTElORSBJTkMuMTYwNAYDVQQDEy1BTUVSSUNBIE9OTElORSBST09UIENFUlRJRklDQVRJT04gQVVUSE9SSVRZIDI=
--> 14: MEMxCzAJBgNVBAYTAkpQMRwwGgYDVQQKExNKQVBBTkVTRSBHT1ZFUk5NRU5UMRYwFAYDVQQLEw1BUFBMSUNBVElPTkNB
--> 15: MIGNMQswCQYDVQQGEwJBVDFIMEYGA1UECgw/QS1UcnVzdCBHZXMuIGYuIFNpY2hlcmhlaXRzc3lzdGVtZSBpbSBlbGVrdHIuIERhdGVudmVya2VociBHbWJIMRkwFwYDVQQLDBBBLVRydXN0LW5RdWFsLTAzMRkwFwYDVQQDDBBBLVRydXN0LW5RdWFsLTAz
--> 16: MFExCzAJBgNVBAYTAkVTMUIwQAYDVQQDDDlBdXRvcmlkYWQgZGUgQ2VydGlmaWNhY2lvbiBGaXJtYXByb2Zlc2lvbmFsIENJRiBBNjI2MzQwNjg=
--> 17: MFoxCzAJBgNVBAYTAklFMRIwEAYDVQQKEwlCQUxUSU1PUkUxEzARBgNVBAsTCkNZQkVSVFJVU1QxIjAgBgNVBAMTGUJBTFRJTU9SRSBDWUJFUlRSVVNUIFJPT1Q=
--> 18: MEsxCzAJBgNVBAYTAk5PMR0wGwYDVQQKDBRCdXlwYXNzIEFTLTk4MzE2MzMyNzEdMBsGA1UEAwwUQnV5cGFzcyBDbGFzcyAyIENBIDE=
--> 19: ME4xCzAJBgNVBAYTAk5PMR0wGwYDVQQKDBRCdXlwYXNzIEFTLTk4MzE2MzMyNzEgMB4GA1UEAwwXQnV5cGFzcyBDbGFzcyAyIFJvb3QgQ0E=
--> 20: MEsxCzAJBgNVBAYTAk5PMR0wGwYDVQQKDBRCdXlwYXNzIEFTLTk4MzE2MzMyNzEdMBsGA1UEAwwUQnV5cGFzcyBDbGFzcyAzIENBIDE=
--> 21: ME4xCzAJBgNVBAYTAk5PMR0wGwYDVQQKDBRCdXlwYXNzIEFTLTk4MzE2MzMyNzEgMB4GA1UEAwwXQnV5cGFzcyBDbGFzcyAzIFJvb3QgQ0E=
--> 22: MEoxCzAJBgNVBAYTAlNLMRMwEQYDVQQHEwpCUkFUSVNMQVZBMRMwEQYDVQQKEwpESVNJRyBBLlMuMREwDwYDVQQDEwhDQSBESVNJRw==
--> 23: MFIxCzAJBgNVBAYTAlNLMRMwEQYDVQQHEwpCUkFUSVNMQVZBMRMwEQYDVQQKEwpESVNJRyBBLlMuMRkwFwYDVQQDExBDQSBESVNJRyBST09UIFIx
--> 24: MFIxCzAJBgNVBAYTAlNLMRMwEQYDVQQHEwpCUkFUSVNMQVZBMRMwEQYDVQQKEwpESVNJRyBBLlMuMRkwFwYDVQQDExBDQSBESVNJRyBST09UIFIy
--> 25: MH8xCzAJBgNVBAYTAkVVMScwJQYDVQQKEx5BQyBDQU1FUkZJUk1BIFNBIENJRiBBODI3NDMyODcxIzAhBgNVBAsTGkhUVFA6Ly9XV1cuQ0hBTUJFUlNJR04uT1JHMSIwIAYDVQQDExlDSEFNQkVSUyBPRiBDT01NRVJDRSBST09U
--> 26: MH0xCzAJBgNVBAYTAkVVMScwJQYDVQQKEx5BQyBDQU1FUkZJUk1BIFNBIENJRiBBODI3NDMyODcxIzAhBgNVBAsTGkhUVFA6Ly9XV1cuQ0hBTUJFUlNJR04uT1JHMSAwHgYDVQQDExdHTE9CQUwgQ0hBTUJFUlNJR04gUk9PVA==
--> 27: MDQxCzAJBgNVBAYTAkZSMRIwEAYDVQQKDAlEaGlteW90aXMxETAPBgNVBAMMCENlcnRpZ25h
--> 28: MGMxCzAJBgNVBAYTAkZSMRMwEQYDVQQKEwpDRVJUSU5PTUlTMRcwFQYDVQQLEw4wMDAyIDQzMzk5ODkwMzEmMCQGA1UEAwwdQ2VydGlub21pcyAtIEF1dG9yaXTDqSBSYWNpbmU=
--> 29: MD0xCzAJBgNVBAYTAkZSMREwDwYDVQQKEwhDRVJUUExVUzEbMBkGA1UEAxMSQ0xBU1MgMiBQUklNQVJZIENB
--> 30: MDsxCzAJBgNVBAYTAlJPMREwDwYDVQQKEwhDRVJUU0lHTjEZMBcGA1UECxMQQ0VSVFNJR04gUk9PVCBDQQ==
--> 31: MD4xCzAJBgNVBAYTAlBMMRswGQYDVQQKExJVTklaRVRPIFNQLiBaIE8uTy4xEjAQBgNVBAMTCUNFUlRVTSBDQQ==
--> 32: MH4xCzAJBgNVBAYTAlBMMSIwIAYDVQQKExlVTklaRVRPIFRFQ0hOT0xPR0lFUyBTLkEuMScwJQYDVQQLEx5DRVJUVU0gQ0VSVElGSUNBVElPTiBBVVRIT1JJVFkxIjAgBgNVBAMTGUNFUlRVTSBUUlVTVEVEIE5FVFdPUksgQ0E=
--> 33: MIGuMQswCQYDVQQGEwJFVTFDMEEGA1UEBxM6TUFEUklEIChTRUUgQ1VSUkVOVCBBRERSRVNTIEFUIFdXVy5DQU1FUkZJUk1BLkNPTS9BRERSRVNTKTESMBAGA1UEBRMJQTgyNzQzMjg3MRswGQYDVQQKExJBQyBDQU1FUkZJUk1BIFMuQS4xKTAnBgNVBAMTIENIQU1CRVJTIE9GIENPTU1FUkNFIFJPT1QgLSAyMDA4
--> 34: MIGKMQswCQYDVQQGEwJDTjEyMDAGA1UECgwpQ2hpbmEgSW50ZXJuZXQgTmV0d29yayBJbmZvcm1hdGlvbiBDZW50ZXIxRzBFBgNVBAMMPkNoaW5hIEludGVybmV0IE5ldHdvcmsgSW5mb3JtYXRpb24gQ2VudGVyIEVWIENlcnRpZmljYXRlcyBSb290
--> 35: MDIxCzAJBgNVBAYTAkNOMQ4wDAYDVQQKEwVDTk5JQzETMBEGA1UEAxMKQ05OSUMgUk9PVA==
--> 36: MHsxCzAJBgNVBAYTAkdCMRswGQYDVQQIDBJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcMB1NhbGZvcmQxGjAYBgNVBAoMEUNvbW9kbyBDQSBMaW1pdGVkMSEwHwYDVQQDDBhBQUEgQ2VydGlmaWNhdGUgU2VydmljZXM=
--> 37: MIGBMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR1JFQVRFUiBNQU5DSEVTVEVSMRAwDgYDVQQHEwdTQUxGT1JEMRowGAYDVQQKExFDT01PRE8gQ0EgTElNSVRFRDEnMCUGA1UEAxMeQ09NT0RPIENFUlRJRklDQVRJT04gQVVUSE9SSVRZ
--> 38: MIGFMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR1JFQVRFUiBNQU5DSEVTVEVSMRAwDgYDVQQHEwdTQUxGT1JEMRowGAYDVQQKExFDT01PRE8gQ0EgTElNSVRFRDErMCkGA1UEAxMiQ09NT0RPIEVDQyBDRVJUSUZJQ0FUSU9OIEFVVEhPUklUWQ==
--> 39: MH4xCzAJBgNVBAYTAkdCMRswGQYDVQQIDBJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcMB1NhbGZvcmQxGjAYBgNVBAoMEUNvbW9kbyBDQSBMaW1pdGVkMSQwIgYDVQQDDBtTZWN1cmUgQ2VydGlmaWNhdGUgU2VydmljZXM=
--> 40: MH8xCzAJBgNVBAYTAkdCMRswGQYDVQQIDBJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcMB1NhbGZvcmQxGjAYBgNVBAoMEUNvbW9kbyBDQSBMaW1pdGVkMSUwIwYDVQQDDBxUcnVzdGVkIENlcnRpZmljYXRlIFNlcnZpY2Vz
--> 41: MDQxEzARBgNVBAMTCkNPTVNJR04gQ0ExEDAOBgNVBAoTB0NPTVNJR04xCzAJBgNVBAYTAklM
--> 42: MDwxGzAZBgNVBAMTEkNPTVNJR04gU0VDVVJFRCBDQTEQMA4GA1UEChMHQ09NU0lHTjELMAkGA1UEBhMCSUw=
--> 43: MDsxGDAWBgNVBAoTD0NZQkVSVFJVU1QsIElOQzEfMB0GA1UEAxMWQ1lCRVJUUlVTVCBHTE9CQUwgUk9PVA==
--> 44: MHExCzAJBgNVBAYTAkRFMRwwGgYDVQQKExNERVVUU0NIRSBURUxFS09NIEFHMR8wHQYDVQQLExZULVRFTEVTRUMgVFJVU1QgQ0VOVEVSMSMwIQYDVQQDExpERVVUU0NIRSBURUxFS09NIFJPT1QgQ0EgMg==
--> 45: MGUxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxESUdJQ0VSVCBJTkMxGTAXBgNVBAsTEFdXVy5ESUdJQ0VSVC5DT00xJDAiBgNVBAMTG0RJR0lDRVJUIEFTU1VSRUQgSUQgUk9PVCBDQQ==
--> 46: MGExCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxESUdJQ0VSVCBJTkMxGTAXBgNVBAsTEFdXVy5ESUdJQ0VSVC5DT00xIDAeBgNVBAMTF0RJR0lDRVJUIEdMT0JBTCBST09UIENB
--> 47: MGwxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxESUdJQ0VSVCBJTkMxGTAXBgNVBAsTEFdXVy5ESUdJQ0VSVC5DT00xKzApBgNVBAMTIkRJR0lDRVJUIEhJR0ggQVNTVVJBTkNFIEVWIFJPT1QgQ0E=
--> 48: MEYxCzAJBgNVBAYTAlVTMSQwIgYDVQQKExtESUdJVEFMIFNJR05BVFVSRSBUUlVTVCBDTy4xETAPBgNVBAsTCERTVENBIEUx
--> 49: MEYxCzAJBgNVBAYTAlVTMSQwIgYDVQQKExtESUdJVEFMIFNJR05BVFVSRSBUUlVTVCBDTy4xETAPBgNVBAsTCERTVENBIEUy
--> 50: MFsxCzAJBgNVBAYTAlVTMSAwHgYDVQQKExdESUdJVEFMIFNJR05BVFVSRSBUUlVTVDERMA8GA1UECxMIRFNUIEFDRVMxFzAVBgNVBAMTDkRTVCBBQ0VTIENBIFg2
--> 51: MD8xJDAiBgNVBAoTG0RJR0lUQUwgU0lHTkFUVVJFIFRSVVNUIENPLjEXMBUGA1UEAxMORFNUIFJPT1QgQ0EgWDM=
--> 52: ME0xCzAJBgNVBAYTAkRFMRUwEwYDVQQKDAxELVRydXN0IEdtYkgxJzAlBgNVBAMMHkQtVFJVU1QgUm9vdCBDbGFzcyAzIENBIDIgMjAwOQ==
--> 53: MFAxCzAJBgNVBAYTAkRFMRUwEwYDVQQKDAxELVRydXN0IEdtYkgxKjAoBgNVBAMMIUQtVFJVU1QgUm9vdCBDbGFzcyAzIENBIDIgRVYgMjAwOQ==
--> 54: MIGAMTgwNgYDVQQDDC9FQkcgRWxla3Ryb25payBTZXJ0aWZpa2EgSGl6bWV0IFNhxJ9sYXnEsWPEsXPEsTE3MDUGA1UECgwuRUJHIEJpbGnFn2ltIFRla25vbG9qaWxlcmkgdmUgSGl6bWV0bGVyaSBBLsWeLjELMAkGA1UEBhMCVFI=
--> 55: MIHzMQswCQYDVQQGEwJFUzE7MDkGA1UEChMyQUdFTkNJQSBDQVRBTEFOQSBERSBDRVJUSUZJQ0FDSU8gKE5JRiBRLTA4MDExNzYtSSkxKDAmBgNVBAsTH1NFUlZFSVMgUFVCTElDUyBERSBDRVJUSUZJQ0FDSU8xNTAzBgNVBAsTLFZFR0VVIEhUVFBTOi8vV1dXLkNBVENFUlQuTkVUL1ZFUkFSUkVMIChDKTAzMTUwMwYDVQQLEyxKRVJBUlFVSUEgRU5USVRBVFMgREUgQ0VSVElGSUNBQ0lPIENBVEFMQU5FUzEPMA0GA1UEAxMGRUMtQUND
--> 56: MHUxCzAJBgNVBAYTAkVFMSIwIAYDVQQKDBlBUyBTZXJ0aWZpdHNlZXJpbWlza2Vza3VzMSgwJgYDVQQDDB9FRSBDZXJ0aWZpY2F0aW9uIENlbnRyZSBSb290IENBMRgwFgYJKoZIhvcNAQkBFglwa2lAc2suZWU=
--> 57: MHUxCzAJBgNVBAYTAlRSMSgwJgYDVQQKEx9FTEVLVFJPTklLIEJJTEdJIEdVVkVOTElHSSBBLlMuMTwwOgYDVQQDEzNFLUdVVkVOIEtPSyBFTEVLVFJPTklLIFNFUlRJRklLQSBISVpNRVQgU0FHTEFZSUNJU0k=
--> 58: MIG0MRQwEgYDVQQKEwtFTlRSVVNULk5FVDFAMD4GA1UECxQ3d3d3LmVudHJ1c3QubmV0L0NQU18yMDQ4IGluY29ycC4gYnkgcmVmLiAobGltaXRzIGxpYWIuKTElMCMGA1UECxMcKEMpIDE5OTkgRU5UUlVTVC5ORVQgTElNSVRFRDEzMDEGA1UEAxMqRU5UUlVTVC5ORVQgQ0VSVElGSUNBVElPTiBBVVRIT1JJVFkgKDIwNDgp
--> 59: MIHDMQswCQYDVQQGEwJVUzEUMBIGA1UEChMLRU5UUlVTVC5ORVQxOzA5BgNVBAsTMldXVy5FTlRSVVNULk5FVC9DUFMgSU5DT1JQLiBCWSBSRUYuIChMSU1JVFMgTElBQi4pMSUwIwYDVQQLExwoQykgMTk5OSBFTlRSVVNULk5FVCBMSU1JVEVEMTowOAYDVQQDEzFFTlRSVVNULk5FVCBTRUNVUkUgU0VSVkVSIENFUlRJRklDQVRJT04gQVVUSE9SSVRZ
--> 60: MIGwMQswCQYDVQQGEwJVUzEWMBQGA1UEChMNRU5UUlVTVCwgSU5DLjE5MDcGA1UECxMwV1dXLkVOVFJVU1QuTkVUL0NQUyBJUyBJTkNPUlBPUkFURUQgQlkgUkVGRVJFTkNFMR8wHQYDVQQLExYoQykgMjAwNiBFTlRSVVNULCBJTkMuMS0wKwYDVQQDEyRFTlRSVVNUIFJPT1QgQ0VSVElGSUNBVElPTiBBVVRIT1JJVFk=
--> 61: MF4xCzAJBgNVBAYTAlRXMSMwIQYDVQQKDBpDaHVuZ2h3YSBUZWxlY29tIENvLiwgTHRkLjEqMCgGA1UECwwhZVBLSSBSb290IENlcnRpZmljYXRpb24gQXV0aG9yaXR5
--> 62: ME4xCzAJBgNVBAYTAlVTMRAwDgYDVQQKEwdFUVVJRkFYMS0wKwYDVQQLEyRFUVVJRkFYIFNFQ1VSRSBDRVJUSUZJQ0FURSBBVVRIT1JJVFk=
--> 63: MFMxCzAJBgNVBAYTAlVTMRwwGgYDVQQKExNFUVVJRkFYIFNFQ1VSRSBJTkMuMSYwJAYDVQQDEx1FUVVJRkFYIFNFQ1VSRSBFQlVTSU5FU1MgQ0EtMQ==
--> 64: MFoxCzAJBgNVBAYTAlVTMRwwGgYDVQQKExNFUVVJRkFYIFNFQ1VSRSBJTkMuMS0wKwYDVQQDEyRFUVVJRkFYIFNFQ1VSRSBHTE9CQUwgRUJVU0lORVNTIENBLTE=
--> 65: MIGdMQswCQYDVQQGEwJFUzEiMCAGA1UEBxMZQy8gTVVOVEFORVIgMjQ0IEJBUkNFTE9OQTFCMEAGA1UEAxM5QVVUT1JJREFEIERFIENFUlRJRklDQUNJT04gRklSTUFQUk9GRVNJT05BTCBDSUYgQTYyNjM0MDY4MSYwJAYJKoZIhvcNAQkBFhdjYUBmaXJtYXByb2Zlc2lvbmFsLmNvbQ==
--> 66: MEQxCzAJBgNVBAYTAlVTMRYwFAYDVQQKEw1HRU9UUlVTVCBJTkMuMR0wGwYDVQQDExRHRU9UUlVTVCBHTE9CQUwgQ0EgMg==
--> 67: MEIxCzAJBgNVBAYTAlVTMRYwFAYDVQQKEw1HRU9UUlVTVCBJTkMuMRswGQYDVQQDExJHRU9UUlVTVCBHTE9CQUwgQ0E=
--> 68: MFgxCzAJBgNVBAYTAlVTMRYwFAYDVQQKEw1HRU9UUlVTVCBJTkMuMTEwLwYDVQQDEyhHRU9UUlVTVCBQUklNQVJZIENFUlRJRklDQVRJT04gQVVUSE9SSVRZ
--> 69: MIGYMQswCQYDVQQGEwJVUzEWMBQGA1UEChMNR0VPVFJVU1QgSU5DLjE5MDcGA1UECxMwKEMpIDIwMDcgR0VPVFJVU1QgSU5DLiAtIEZPUiBBVVRIT1JJWkVEIFVTRSBPTkxZMTYwNAYDVQQDEy1HRU9UUlVTVCBQUklNQVJZIENFUlRJRklDQVRJT04gQVVUSE9SSVRZIC0gRzI=
--> 70: MIGYMQswCQYDVQQGEwJVUzEWMBQGA1UEChMNR0VPVFJVU1QgSU5DLjE5MDcGA1UECxMwKEMpIDIwMDggR0VPVFJVU1QgSU5DLiAtIEZPUiBBVVRIT1JJWkVEIFVTRSBPTkxZMTYwNAYDVQQDEy1HRU9UUlVTVCBQUklNQVJZIENFUlRJRklDQVRJT04gQVVUSE9SSVRZIC0gRzM=
--> 71: MEcxCzAJBgNVBAYTAlVTMRYwFAYDVQQKEw1HRU9UUlVTVCBJTkMuMSAwHgYDVQQDExdHRU9UUlVTVCBVTklWRVJTQUwgQ0EgMg==
--> 72: MEUxCzAJBgNVBAYTAlVTMRYwFAYDVQQKEw1HRU9UUlVTVCBJTkMuMR4wHAYDVQQDExVHRU9UUlVTVCBVTklWRVJTQUwgQ0E=
--> 73: MIGsMQswCQYDVQQGEwJFVTFDMEEGA1UEBxM6TUFEUklEIChTRUUgQ1VSUkVOVCBBRERSRVNTIEFUIFdXVy5DQU1FUkZJUk1BLkNPTS9BRERSRVNTKTESMBAGA1UEBRMJQTgyNzQzMjg3MRswGQYDVQQKExJBQyBDQU1FUkZJUk1BIFMuQS4xJzAlBgNVBAMTHkdMT0JBTCBDSEFNQkVSU0lHTiBST09UIC0gMjAwOA==
--> 74: MFcxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHTE9CQUxTSUdOIE5WLVNBMRAwDgYDVQQLEwdST09UIENBMRswGQYDVQQDExJHTE9CQUxTSUdOIFJPT1QgQ0E=










