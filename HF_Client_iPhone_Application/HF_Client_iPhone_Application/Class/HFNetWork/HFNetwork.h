//
//  HFNetwork.h
//  flippedclassroomstudent
//
//  Created by 陈炳桦 on 2017/11/10.
//  Copyright © 2017年 陈炳桦. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface HFNetwork : NSObject

//请求成功回调block
typedef void (^requestSuccessBlock)(NSString *resultString);

//请求失败回调block
typedef void (^requestFailureBlock)(NSError *error);


// 单例模式
+ (instancetype)network;

// 发送WebService的接口
- (void)SOAPDataWithUrl:(NSString *)url soapBody:(NSString *)soapBody success:(void (^)(id responseObject))success failure:(void(^)(NSError *error))failure;
// 发送WebService的接口
- (void)xmlSOAPDataWithUrl:(NSString *)url soapBody:(NSString *)soapBody success:(void (^)(id responseObject))success failure:(void(^)(NSError *error))failure;
@end
