//
//  HFStudentArrayModel.m
//  HF_Client_iPhone_Application
//
//  Created by 陈炳桦 on 2018/1/7.
//  Copyright © 2018年 HengFeng. All rights reserved.
//  学生小组模型

#import "HFStudentArrayModel.h"

@implementation HFStudentArrayModel

-(NSMutableArray<HFStudentModel *> *)studentArray{
    if (_studentArray == nil) {
        _studentArray = [NSMutableArray array];
    }
    
    return _studentArray;
}

// 指定主键
+ (NSString *)primaryKey {
    return @"keyID";
}

// 指定忽略的属性
+ (NSArray *)ignoredProperties {
    return @[@"isShow",@"studentArray"];
}

// 指定默认属性
+ (NSDictionary *)defaultPropertyValues {
    return @{@"point" : @0};
}

- (NSString *)keyID{
    return [NSString stringWithFormat:@"%@%@",_PeopleGroupID,_PeopleGroupNum];
}

@end
