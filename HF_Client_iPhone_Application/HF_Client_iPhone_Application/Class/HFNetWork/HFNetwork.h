//
//  HFNetwork.h
//  flippedclassroomstudent
//
//  Created by 陈炳桦 on 2017/11/10.
//  Copyright © 2017年 陈炳桦. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ServerType) {
    ServerTypeBeiJing = 0,      // 北京服务器
    ServerTypeGuangZhou         // 广州服务器
};

@interface HFNetwork : NSObject

//请求成功回调block
typedef void (^requestSuccessBlock)(NSString *resultString);

//请求失败回调block
typedef void (^requestFailureBlock)(NSError *error);

// 单例模式
+ (instancetype)network;

// 获取NSXMLParser中的字符串
- (NSString *)stringInNSXMLParser:(id)XMLParser;

// 发送WebService的接口
- (void)SOAPDataWithUrl:(NSString *)url soapBody:(NSString *)soapBody success:(void (^)(id responseObject))success failure:(void(^)(NSError *error))failure;
// 发送WebService的接口
- (void)xmlSOAPDataWithUrl:(NSString *)url soapBody:(NSString *)soapBody success:(void (^)(id responseObject))success failure:(void(^)(NSError *error))failure;

@property(nonatomic,strong) NSString *ServerAddress;    // 公网服务器地址
@property(nonatomic,strong) NSString *SocketAddress;    // Socket服务器地址
@property(nonatomic,assign) ServerType serverType;      // 服务器类型 北京服务器或者广州服务器
@property(nonatomic,strong) NSString *WebServicePath;   // WebServicePath
@property(nonatomic,strong) NSString *NameSpace;        // WebService的命名空间
@property(nonatomic,strong) NSString *HttpPath;         // http路径
@property (strong, nonatomic)NSMutableArray *studentArray;

@end
