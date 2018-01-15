//
//  HFStudentModel.h
//  HF_Client_iPhone_Application
//
//  Created by 陈炳桦 on 2017/12/21.
//  Copyright © 2017年 HengFeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm.h>

@interface HFStudentModel : RLMObject

@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSString *userRealName;
@property (nonatomic,strong) NSString *userLoginName;

// 小组需要的字段 PeopleGroupNum PeopleGroupID
@property (nonatomic,strong) NSString *PeopleGroupNum;
@property (nonatomic,strong) NSString *PeopleGroupID;

// 分数
@property (nonatomic,assign) NSInteger point;

// 学生状态-小组返回的数组
- (NSMutableArray<HFStudentModel *> *)getStudentGroup:(NSXMLParser *)xmlParser;

@end
