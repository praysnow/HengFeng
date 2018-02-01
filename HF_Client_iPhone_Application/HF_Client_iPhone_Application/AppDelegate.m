//
//  AppDelegate.m
//  HF_Client_iPhone_Application
//
//  Created by liuyang on 2017/11/7.
//  Copyright © 2017年 HengFeng. All rights reserved.
//

#import "AppDelegate.h"
#import "HFLoginViewController.h"
#import "MMDrawerController.h"
#import "HFUserInfoViewController.h"
#import "HFNavigationViewController.h"

@interface AppDelegate ()

@property(nonatomic,strong) MMDrawerController * drawerController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 状态栏改为白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.window = [[UIWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    //1、初始化控制器
    MainTabViewController *centerVC = [[MainTabViewController alloc]init];
    self.centerVC = centerVC;
    HFUserInfoViewController *leftVC = [[HFUserInfoViewController alloc]init];
    //2、初始化导航控制器
//    HFNavigationViewController *centerNvaVC = [[HFNavigationViewController alloc]initWithRootViewController:centerVC];
//    centerVC.hideNavigationBar = YES;
//    HFNavigationViewController *leftNvaVC = [[HFNavigationViewController alloc]initWithRootViewController:leftVC];
//    leftNvaVC.hideNavigationBar = YES;
    
    //3、使用MMDrawerController
//    self.drawerController = [[MMDrawerController alloc]initWithCenterViewController:centerNvaVC leftDrawerViewController:leftNvaVC rightDrawerViewController: nil];
        self.drawerController = [[MMDrawerController alloc]initWithCenterViewController:centerVC leftDrawerViewController:leftVC rightDrawerViewController: nil];
    self.drawerController.hideNavigationBar = YES;
    
    //4、设置打开/关闭抽屉的手势
    self.drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    self.drawerController.closeDrawerGestureModeMask =MMCloseDrawerGestureModeAll;
    //5、设置左右两边抽屉显示的多少
    self.drawerController.maximumLeftDrawerWidth = SCREEN_WIDTH * 0.8;
    
//    MainTabViewController *loginView = [[MainTabViewController alloc] init];
//        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController: loginView];
//    navigationController.navigationBar.hidden = YES;
//    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController: navigationController leftMenuViewController: nil rightMenuViewController: nil];
    
    // 开启socket连接
    [[HFSocketService sharedInstance] socketConnectHost];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(startSlide) name: START_SLIDE object: nil];
    self.window.rootViewController = self.drawerController;
    
    
//    self.window.rootViewController = [NSClassFromString(@"HFPPTViewController") new];
    return YES;
}

- (void)startSlide
{
   [self.drawerController toggleDrawerSide: MMDrawerSideLeft animated:YES completion:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
//    NSLog(@"程序变为活跃");
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window

{
    
    if (self.allowRotation == YES) {
        //横屏
        return UIInterfaceOrientationMaskLandscape;
        
    }else{
        //竖屏
        return UIInterfaceOrientationMaskPortrait;
        
    }
    
}


@end
