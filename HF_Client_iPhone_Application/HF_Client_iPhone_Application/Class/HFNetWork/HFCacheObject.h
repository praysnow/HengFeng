//
//  HFCacheObject.h
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 24/11/2017.
//  Copyright © 2017 HengFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFCacheObject : NSObject

/* 存入和覆盖数据 */

+ (void)setUserDefaultData:(NSDictionary *)value andKey:(NSString *)key;

/* 取出数据 */

+ (NSString *)getUserName:(NSString *)value andKey:(NSString *)key;

+ (NSString *)getPassWord:(NSString *)value andKey:(NSString *)key;

@end
