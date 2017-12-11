//
//  CBAlertWindow.h
//  flippedclassroomstudent
//
//  Created by 陈炳桦 on 2017/11/23.
//  Copyright © 2017年 陈炳桦. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CBShowAnimateType) {
    CBShowAnimateTypeCenter = 0,    // 中间
    CBShowAnimateTypeBottom,    // 底部
};

@interface CBAlertWindow : NSObject

+ (void)jz_showView:(UIView *)view animateType:(CBShowAnimateType)type;
+ (void)jz_hide;


@end
