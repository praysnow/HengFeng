 //
//  HFCacheObject.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 24/11/2017.
//  Copyright © 2017 HengFeng. All rights reserved.
//

#import "HFCacheObject.h"
#import "HFClassTestObject.h"
#import "WebServiceModel.h"

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
    
    [self GetStudentListByClassID];
}

- (void)GetStudentListByClassID{
    

    WebServiceModel *model = [WebServiceModel new];
    model.method = @"GetStudentListByClassID";
    
    NSString *classId = [HFCacheObject shardence].classId;
    
    if (classId == nil) {
        NSLog(@"%@",@"classId为空");
        return;
        
    }
    
    if ([HFNetwork network].serverType == ServerTypeBeiJing && classId.length >= 3) {
        classId =  [classId substringWithRange:NSMakeRange(0,3)];
    }
    
    NSString *url = nil;
    if ([HFNetwork network].serverType == ServerTypeBeiJing) {
        model.params = @{@"ClassID" : classId}.mutableCopy;
        url = [NSString stringWithFormat: @"%@%@%@",[HFNetwork network].ServerAddress, [HFNetwork network].WebServicePath, model.method];
    }else{
        model.params = @{@"arg0":classId}.mutableCopy;
        url = [NSString stringWithFormat: @"%@%@",[HFNetwork network].ServerAddress, [HFNetwork network].WebServicePath];
    }
    [[HFNetwork network] SOAPDataWithUrl: url soapBody: [model getRequestParams]  success:^(id responseObject) {
        
        
        NSLog(@"获取学生信息成功");
        [HFCacheObject shardence].studentArray = [[HFStudentModel new] getStudentGroup:responseObject];
        
        
        
    } failure:^(NSError *error) {
        NSLog(@"获取学生信息失败");
    }];
    
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
    NSString *result;
    if (className.length > 0) {
        NSRange range = [className rangeOfString:@"["];
        result = [className substringToIndex: range.location];
    }
    _className = result;
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

- (void)setImageUrl:(NSString *)imageUrl
{
    imageUrl = [NSString stringWithFormat: @"ftp://%@/root%@%@", [HFNetwork network].SocketAddress, imageUrl, @"jpeg"];
    _imageUrl = imageUrl;
    
    // 转换图片
    _imageUrl = [_imageUrl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
//    NSLog(@"图片地址为: %@", _imageUrl);
    [[NSNotificationCenter defaultCenter] postNotificationName: @"imageUrl" object: nil];
}

+ (void)setArrayWithString:(NSString *)string
{
    if (string.length > 0) {
        NSLog(@"学生提交测评: %@", string);
    }
    HFClassTestObject *object = [HFClassTestObject new];
    object.fileName = [HFUtils regulexFromString: string andStartString: @"&name=" andEndString: @"&fileName"];
    object.Name = [HFUtils regulexFromString: string andStartString: @"fileName=" andEndString: @"jpeg"];
    
    //最后需要通过姓名去班级里面渠道USerid 存入name
    
    NSLog(@"正则取学生提交命令成功: %@\n%@", object.fileName, object.Name);
//    [[HFCacheObject shardence].commitViewArray addObject: string];
    //通知测评页面更新 UI
    [[NSNotificationCenter defaultCenter] postNotificationName: @"CommitViewImage=" object: nil];
}
//学生提交测评数组
- (NSMutableArray *)commitViewArray
{
    if (!_commitViewArray) {
        _commitViewArray = [NSMutableArray array];
    }
    return _commitViewArray;
}

@end
