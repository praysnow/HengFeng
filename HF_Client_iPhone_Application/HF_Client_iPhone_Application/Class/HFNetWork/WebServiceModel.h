//
//  WebServiceModel.h
//  flippedclassroomstudent
//
//  Created by 陈炳桦 on 2017/11/10.
//  Copyright © 2017年 陈炳桦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServiceModel : NSObject

@property(strong,nonatomic) NSString *method;

@property(strong,nonatomic) NSMutableDictionary *params;

// 获取拼接的参数
- (NSString *)getRequestParams;

@end
