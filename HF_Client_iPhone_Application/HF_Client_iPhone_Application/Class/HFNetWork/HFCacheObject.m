//
//  HFCacheObject.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 24/11/2017.
//  Copyright © 2017 HengFeng. All rights reserved.
//

#import "HFCacheObject.h"

@implementation HFCacheObject

/* 存入和覆盖数据 */

+ (void)setUserDefaultData:(NSDictionary *)value andKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject: value forKey: key];
}

/* 取出数据 */

+ (NSString *)getUserName:(NSString *)value andKey:(NSString *)key
{
    NSString *info = @"";
   NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey: key];
    if ([dictionary.allKeys containsObject: @"userName"]) {
        info = [dictionary valueForKey: @"userName"];
    }
    return info;
}

+ (NSString *)getPassWord:(NSString *)value andKey:(NSString *)key
{
    NSString *info = @"";
    NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey: key];
    if ([dictionary.allKeys containsObject: @"password"]) {
        info = [dictionary valueForKey: @"password"];
    }
    return info;
}

+ (instancetype)shardence
{
    static HFCacheObject *object;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        object = [[HFCacheObject alloc] init];
    });
    return object;
}

- (void)setSubjectId:(NSString *)subjectId
{
    _subjectId = subjectId;
    NSLog(@"测试数据");
    _subjectId = @"8926";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TEACHER_CTROL" object: nil];
}

@end
