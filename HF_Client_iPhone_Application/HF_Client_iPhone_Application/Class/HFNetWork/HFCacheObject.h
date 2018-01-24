//
//  HFCacheObject.h
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 24/11/2017.
//  Copyright © 2017 HengFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HFStudentModel.h"

@interface HFCacheObject : NSObject

/* 存入和覆盖数据 */

+ (void)setUserDefaultData:(NSDictionary *)value andKey:(NSString *)key;

/* 取出数据 */

+ (NSString *)getUserName:(NSString *)value andKey:(NSString *)key;

+ (NSString *)getPassWord:(NSString *)value andKey:(NSString *)key;

+ (instancetype)shardence;
//接收学生举手
+ (void)sendArrayWithString:(NSString *)string;

// 请求学生信息
- (void)GetStudentListByClassID;

// TeacherInfo

@property (nonatomic, copy) NSString *courseId;
@property (nonatomic, copy) NSString *subjectId;
@property (nonatomic, copy) NSString *classId;

@property (nonatomic, copy) NSString *teacherName;
@property (nonatomic, copy) NSString *handUpUsersList;
@property (nonatomic, copy) NSString *className;
@property (nonatomic, copy) NSString *isInRacing;
@property (nonatomic, copy) NSString *isInHandup;
@property (nonatomic, copy) NSString *showParamsUrl;
@property (nonatomic, copy) NSString *paperInfo;
@property (nonatomic, copy) NSString *padViewImageMsg;
@property (nonatomic, copy) NSString *guidedLearningInfo;
@property (nonatomic, copy) NSString *microClassInfo;
@property (nonatomic, copy) NSString *isCanQuit;
@property (nonatomic, copy) NSString *iosLookScreen;
@property (nonatomic, copy) NSString *voteMsg;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, strong) NSMutableArray<HFStudentModel *> *studentArray;

//学生提交的数据
@property (nonatomic, strong) NSMutableArray *commitViewArray;

@end
