//
//  HFStudentArrayModel.h
//  HF_Client_iPhone_Application
//
//  Created by 陈炳桦 on 2018/1/7.
//  Copyright © 2018年 HengFeng. All rights reserved.
//  学生小组模型

#import <Foundation/Foundation.h>
#import "HFStudentModel.h"

@interface HFStudentArrayModel : NSObject

@property(assign,nonatomic) BOOL isShow; // 是否展示
@property (nonatomic,strong) NSString *PeopleGroupNum; // 小组号
@property(strong,nonatomic) NSMutableArray<HFStudentModel *> *studentArray; // 学生数组

@end
