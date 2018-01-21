//
//  CBAlertWindow.m
//  flippedclassroomstudent
//
//  Created by 陈炳桦 on 2017/11/23.
//  Copyright © 2017年 陈炳桦. All rights reserved.
//

#import "CBAlertWindow.h"
#import "JZAlertViewController.h"

@interface CBAlertWindow ()

@property (nonatomic,strong) UIWindow *alertWindow;
@property (nonatomic,strong) JZAlertViewController *alertVc;

@end

@implementation CBAlertWindow

+ (instancetype)shareInstance{
    static CBAlertWindow *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CBAlertWindow alloc] init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        CGRect windowRect = CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
        _alertWindow = [[UIWindow alloc] initWithFrame:windowRect];
        _alertWindow.hidden = YES;
        [_alertWindow makeKeyAndVisible];
    }
    return self;
}

+ (void)jz_showView:(UIView *)view animateType:(CBShowAnimateType)type{
    
    if (!view) {
        return;
    }
    
    if (CGRectIsNull(view.frame) || CGRectIsEmpty(view.frame)) {
        NSLog(@"viwe.frame is null or is empty");
        return;
    }
    
    JZAlertViewController *vc = [[JZAlertViewController alloc] init];
    vc.contentView = view;
    vc.animateType = type;
    vc.coverClickHide = YES;
    CBAlertWindow *v = [self shareInstance];
    v.alertWindow.hidden = NO;
    v.alertWindow.rootViewController = vc;
    [v.alertWindow makeKeyAndVisible];
}

+ (void)jz_hide{
    CBAlertWindow *v = [self shareInstance];
    v.alertWindow.hidden = YES;
    [v.alertWindow resignKeyWindow];
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window makeKeyWindow];
    v.alertWindow.rootViewController = nil;
}

@end
