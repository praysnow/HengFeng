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

- (void)setClassId:(NSString *)classId
{
    _classId = classId;
    NSLog(@"测试数据");
    if (_classId.length > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName: @"TEACHER_CTROL" object: nil];
    }
}

- (void)setTeacherName:(NSString *)teacherName
{
    _teacherName = teacherName;
    [[NSNotificationCenter defaultCenter] postNotificationName: @"teacherName" object: nil];
}

- (void)setHandUpUsersList:(NSString *)handUpUsersList
{
    _handUpUsersList = handUpUsersList;
    [[NSNotificationCenter defaultCenter] postNotificationName: @"handUpUsersList" object: nil];
}

- (void)setIsInRacing:(NSString *)isInRacing
{
    _isInRacing = isInRacing;
    [[NSNotificationCenter defaultCenter] postNotificationName: @"isInRacing" object: nil];
}


- (void)setClassName:(NSString *)className
{
    _className = className;
    
    NSLog(@"%@",_className);
    [[NSNotificationCenter defaultCenter] postNotificationName: @"className" object: nil];
}

- (void)setIsInHandup:(NSString *)isInHandup
{
    _isInHandup = isInHandup;
    [[NSNotificationCenter defaultCenter] postNotificationName: @"isInHandup" object: nil];
}

- (void)setShowParamsUrl:(NSString *)showParamsUrl
{
    _showParamsUrl = showParamsUrl;
    [[NSNotificationCenter defaultCenter] postNotificationName: @"showParamsUrl" object: nil];
}

- (void)setPaperInfo:(NSString *)paperInfo
{
    _paperInfo = paperInfo;
    [[NSNotificationCenter defaultCenter] postNotificationName: @"paperInfo" object: nil];
}

- (void)setPadViewImageMsg:(NSString *)padViewImageMsg
{
    _padViewImageMsg = padViewImageMsg;
    [[NSNotificationCenter defaultCenter] postNotificationName: @"padViewImageMsg" object: nil];
}

- (void)setGuidedLearningInfo:(NSString *)guidedLearningInfo
{
    _guidedLearningInfo = guidedLearningInfo;
    [[NSNotificationCenter defaultCenter] postNotificationName: @"guidedLearningInfo" object: nil];
}

- (void)setMicroClassInfo:(NSString *)microClassInfo
{
    _microClassInfo = microClassInfo;
    [[NSNotificationCenter defaultCenter] postNotificationName: @"microClassInfo" object: nil];
}

- (void)setIosLookScreen:(NSString *)iosLookScreen
{
    _iosLookScreen = iosLookScreen;
    [[NSNotificationCenter defaultCenter] postNotificationName: @"iosLookScreen" object: nil];
}

- (void)setVoteMsg:(NSString *)voteMsg
{
    _voteMsg = voteMsg;
    [[NSNotificationCenter defaultCenter] postNotificationName: @"voteMsg" object: nil];
}

@end
