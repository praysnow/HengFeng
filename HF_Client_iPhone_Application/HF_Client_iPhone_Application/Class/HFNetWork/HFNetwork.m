//
//  HFNetwork.m
//  flippedclassroomstudent
//
//  Created by 陈炳桦 on 2017/11/10.
//  Copyright © 2017年 陈炳桦. All rights reserved.
//

#import "HFNetwork.h"
#import "AFHTTPSessionManager.h"


@interface HFNetwork ()<NSXMLParserDelegate>

@property(strong,nonatomic)AFHTTPSessionManager *manager;

@property(strong,nonatomic)NSString *resultString;

@property(strong,nonatomic)NSMutableString *mutableString;

@end

@implementation HFNetwork

+ (instancetype)network {
    static HFNetwork *network = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        network = [[HFNetwork alloc] init];
        
    });
    return network;
}

- (instancetype)init{
    if (self = [super init]) {
        self.manager = [AFHTTPSessionManager manager];
    }
    return self;
}

- (NSMutableString *)mutableString{
    if (_mutableString == nil) {
        _mutableString = [NSMutableString string];
    }
    
    return _mutableString;
}



- (void)SOAPDataWithSoapBody:(NSString *)soapBody success:(void (^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 设置请求超时时间
    manager.requestSerializer.timeoutInterval = 30;
    
    // 将返回结果解析为XML,responseObject为NSXMLPraser类型
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    // 设置请求头，也可以不设置
    [manager.requestSerializer setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // 设置HTTPBody
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return soapBody;
    }];
    

//    NSLog(@"请求URL：%@",BaseURL);
//    NSLog@"请求数据：%@",soapBody);
    __weak typeof(self) weakSelf = self;
//    NSString *BaseURL;
    [manager POST: @"http://192.168.13.96" parameters:soapBody progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSXMLParser *responseObject) {
        
        

        [responseObject setDelegate:weakSelf];
        [responseObject parse];
        
        // 返回字符串
        NSLog(@"返回的结果：%@",weakSelf.mutableString);
        success(weakSelf.mutableString);
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
            failure(error);
    }];
}

#pragma mark - NSXMLParser代理
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    [self.mutableString appendString:string];
}
@end
