//
//  JZAlertWindow.m
//  JZAppDemo
//
//  Created by Zengyijie' Com  on 2017/8/21.
//  Copyright © 2017年 Zengyijie' Com . All rights reserved.
//

#import "JZAlertWindow.h"
#import "JZAlertViewController.h"

@interface JZAlertWindow ()

@property (nonatomic,strong) UIWindow *alertWindow;
@property (nonatomic,strong) JZAlertViewController *alertVc;

@end

@implementation JZAlertWindow

+ (instancetype)shareInstance{
    static JZAlertWindow *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JZAlertWindow alloc] init];
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

+ (void)jz_showView:(UIView *)view animateType:(JZShowAnimateType)type{
    
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
    JZAlertWindow *v = [self shareInstance];
    v.alertWindow.hidden = NO;
    v.alertWindow.rootViewController = vc;
    [v.alertWindow makeKeyAndVisible];
}

+ (void)jz_hide{
    JZAlertWindow *v = [self shareInstance];
    v.alertWindow.hidden = YES;
    v.alertWindow.rootViewController = nil;
    [v.alertWindow resignKeyWindow];
}

@end




