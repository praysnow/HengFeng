//
//  HFUtils.h
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 24/11/2017.
//  Copyright © 2017 HengFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFUtils : NSObject

// json字符串转为OC对象
+ (id)jsonStringToObject:(NSString *)jsonString;
//保存Cookie
+ (void)setCookieWithCookieName:(NSString *)name andValue:(NSString *)value;

//控制指令

+ (void)teacherControl;

+ (void)selectTabBarControllerIndexAndShowRootViewController:(NSInteger)index;

@end
