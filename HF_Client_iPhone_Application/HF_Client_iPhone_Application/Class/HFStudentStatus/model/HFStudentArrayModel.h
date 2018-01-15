//
//  HFStudentArrayModel.h
//  HF_Client_iPhone_Application
//
//  Created by 陈炳桦 on 2018/1/7.
//  Copyright © 2018年 HengFeng. All rights reserved.
//  学生小组模型

#import <Foundation/Foundation.h>
#import "HFStudentModel.h"
#import <Realm.h>

@interface HFStudentArrayModel : RLMObject

@property(assign,nonatomic) BOOL isShow; // 是否展示
@property (nonatomic,strong) NSString *PeopleGroupID; // 分组模式的ID PeopleGroupID
@property (nonatomic,strong) NSString *PeopleGroupNum; // 小组号 PeopleGroupNum

@property (nonatomic,strong) NSString *keyID; // 主键

// 分数
@property (nonatomic,assign) NSInteger point;

@property(strong,nonatomic) NSMutableArray<HFStudentModel *> *studentArray; // 学生数组

@end
