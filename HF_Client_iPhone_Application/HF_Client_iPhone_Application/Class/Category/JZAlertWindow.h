//
//  JZAlertWindow.h
//  JZAppDemo
//
//  Created by Zengyijie' Com  on 2017/8/21.
//  Copyright © 2017年 Zengyijie' Com . All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JZShowAnimateType) {
    JZShowAnimateTypeCenter = 0,    // 中间
    JZShowAnimateTypeBottom,    // 底部
};

@interface JZAlertWindow : NSObject

+ (void)jz_showView:(UIView *)view animateType:(JZShowAnimateType)type;
+ (void)jz_hide;



@end
