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

@end
