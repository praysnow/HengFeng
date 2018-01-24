//
//  HFNetwork.m
//  flippedclassroomstudent
//
//  Created by 陈炳桦 on 2017/11/10.
//  Copyright © 2017年 陈炳桦. All rights reserved.
//

#import "HFNetwork.h"
#import "AFHTTPSessionManager.h"
#import "HFDaoxueModel.h"


@interface HFNetwork ()<NSXMLParserDelegate>

@property(strong,nonatomic)AFHTTPSessionManager *manager;

@property(strong, nonatomic)NSString *resultString;
@property (strong, nonatomic)NSMutableArray *studentArray;
@property(strong, nonatomic)NSMutableString *mutableString;
@property(strong, nonatomic)NSString *currentElementName;

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

- (void)SOAPDataWithUrl:(NSString *)url soapBody:(NSString *)soapBody success:(void (^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 设置请求超时时间
    manager.requestSerializer.timeoutInterval = 30;
    
    // 将返回结果解析为XML,responseObject为NSXMLPraser类型
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    // 设置请求头，也可以不设置
//        [manager.requestSerializer setValue: @"application/soap+xml; charset=utf-8;" forHTTPHeaderField:@"Content-Type"];
//    [manager.requestSerializer setValue: @"http://tempuri.org/CheckUser" forHTTPHeaderField:@"action"];
//    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/soap+xml", @"text/html",nil];
    [manager.requestSerializer setValue: @"text/xml;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/soap+xml",@"application/xml", @"text/xml", @"text/html; charset=us-ascii" @"text/javascript", @"text/html", @"text/xml;charset=utf-8", nil];
    // 设置HTTPBody
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return soapBody;
    }];
    NSLog(@"HTTP的请求URL：%@",url);
    
    NSLog(@"HTTP的请求数据：\n%@",soapBody);
//    __weak typeof(self) weakSelf = self;
    [manager POST: url parameters:soapBody progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, NSXMLParser *responseObject) {
        success(responseObject);
        //结束
//        [responseObject setDelegate:weakSelf];
//        [responseObject parse];
//        success([weakSelf.mutableString copy]);
//        weakSelf.mutableString = nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
    }];
}

//#pragma mark - NSXMLParser代理
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{

    [self.mutableString appendString:string];
}

- (void)xmlSOAPDataWithUrl:(NSString *)url soapBody:(NSString *)soapBody success:(void (^)(id responseObject))success failure:(void(^)(NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置请求超时时间
    manager.requestSerializer.timeoutInterval = 30;
    
    // 将返回结果解析txt
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
          // 设置请求头，也可以不设置
//    if ([[HFNetwork network].ServerAddress containsString: @"222"]) {
//        [manager.requestSerializer setValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    } else {
//    [manager.requestSerializer setValue: @"text/html;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//        }
//    [manager.requestSerializer setValue: @"http://tempuri.org/GetDaoXueRenWuByTpID" forHTTPHeaderField:@"action"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/soap+xml",@"application/xml", @"text/xml", @"text/html; charset=us-ascii" @"text/javascript", @"text/html", nil];
    
     [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    // 设置HTTPBody
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return soapBody;
    }];
    NSLog(@"请求url：%@",url);
    NSLog(@"请求数据：%@",soapBody);
    [manager POST: url parameters:soapBody progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, NSXMLParser *responseObject) {
        // 返回字符串
        //存储Cookie

        //结束
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        NSLog(@"%@",error);
    }];
}

// 获取NSXMLParser中的字符串
- (NSString *)stringInNSXMLParser:(id)XMLParser{
    
    if ([XMLParser isKindOfClass:[NSString class]]) {
        return XMLParser;
    }
    
    if ([XMLParser isKindOfClass:[NSXMLParser class]]) {
        [XMLParser setDelegate:self];
        [XMLParser parse];
        
        NSString *string = [self.mutableString copy];
        
        NSLog(@"这里%@",string);
        self.mutableString = nil;
        return string;
    }
    
    return nil;
    
}

#pragma mark - 重写setter、getter
#pragma mark 公网服务器地址
- (void)setServerAddress:(NSString *)ServerAddress{
    
    // 保存到本地
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:ServerAddress forKey:@"ServerAddress"];
}

- (NSString *)ServerAddress{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    return [defaults valueForKey:@"ServerAddress"] ;
}

#pragma mark Socket服务器地址
- (void)setSocketAddress:(NSString *)SocketAddress{
    // 保存到本地
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue: SocketAddress forKey:@"SocketAddress"];
}

- (NSString *)SocketAddress{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:@"SocketAddress"] ;
}

#pragma mark 服务器类型
- (void)setServerType:(ServerType)serverType{
    
    // 保存到本地
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@(serverType) forKey:@"ServerType"];
}

- (ServerType)serverType{
    
    // 默认是北京
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:@"ServerType"] == nil) {
        return ServerTypeBeiJing;
    }
    return [[defaults valueForKey:@"ServerType"] intValue];
}

#pragma mark WebServicePath
- (NSString *)WebServicePath{
    return self.serverType == ServerTypeBeiJing ? WEB_SERVCE_PATH : GZ_WEB_SERVCE_PATH;
}

#pragma mark NameSpace
- (NSString *)NameSpace
{
    return self.serverType == ServerTypeBeiJing ? NAME_SPACE : GZ_NAME_SPACE;
}

#pragma mark HttpPath
- (NSString *)HttpPath{
    return nil;
//    return self.serverType == ServerTypeBeiJing ? HTTP_PATH : GZ_HTTP_PATH;
}

@end
