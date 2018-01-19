//
//  AppDelegate.h
//  HF_Client_iPhone_Application
//
//  Created by liuyang on 2017/11/7.
//  Copyright © 2017年 HengFeng. All rights reserved.
//

#import "MainTabViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MainTabViewController *centerVC;

// 是否允许转向
@property(nonatomic,assign)BOOL allowRotation;


@end

