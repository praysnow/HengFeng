//
//  HFOnLineStudent.h
//  HF_Client_iPhone_Application
//
//  Created by 陈炳桦 on 2018/3/5.
//  Copyright © 2018年 HengFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFOnLineStudent : NSObject

@property (nonatomic,strong) NSString *stuName; //学生名字

-(NSArray<HFOnLineStudent *>*) getOnLineStudnentArray:(NSString *)string;  // 返回学生数组

@end
