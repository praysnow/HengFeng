//
//  MainTabViewController.m
//  HF_Client_iPhone_Application
//
//  Created by liuyang on 2017/11/10.
//  Copyright © 2017年 HengFeng. All rights reserved.
//

#import "MainTabViewController.h"
#import "HFMyResourceViewController.h"
#import "HFCustomTabBar.h"

@interface MainTabViewController () <HFTabBarViewDelegate>

@end

@implementation MainTabViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupappearance];
    
    [self addAllChildViewController];

//    HFMyResourceViewController *vc = [HFMyResourceViewController new];
//    HFMyResourceViewController *vc1 = [HFMyResourceViewController new];
//    HFMyResourceViewController *vc2 = [HFMyResourceViewController new];
//    HFMyResourceViewController *vc3 = [HFMyResourceViewController new];
//    self.viewControllers = @[vc, vc1, vc2, vc3];
}

- (void)setupappearance
{
    HFCustomTabBar *tabBar = [[HFCustomTabBar alloc] init];
    tabBar.tabBarView.viewDelegate = self;
    [self setValue:tabBar forKey:@"tabBar"];
}

#pragma mark - Private Methods

// 添加全部的 childViewcontroller
- (void)addAllChildViewController
{
    UIViewController *homeVC = [[UIViewController alloc] init];
    homeVC.view.backgroundColor = [UIColor redColor];
    [self addChildViewController:homeVC title:@"首页" imageNamed:@"tabbar_match_selected"];

    UIViewController *activityVC = [[UIViewController alloc] init];
    activityVC.view.backgroundColor = [UIColor yellowColor];
    [self addChildViewController:activityVC title:@"活动" imageNamed:@"tabbar_match_selected"];

    UIViewController *findVC = [[UIViewController alloc] init];
    findVC.view.backgroundColor = [UIColor blueColor];
    [self addChildViewController:findVC title:@"发现" imageNamed:@"tabbar_match_selected"];

    UIViewController *mineVC = [[UIViewController alloc] init];
    mineVC.view.backgroundColor = [UIColor greenColor];
    [self addChildViewController:mineVC title:@"我的" imageNamed:@"tabbar_match_selected"];
}

// 添加某个 childViewController
- (void)addChildViewController:(UIViewController *)vc title:(NSString *)title imageNamed:(NSString *)imageNamed
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    // 如果同时有navigationbar 和 tabbar的时候最好分别设置它们的title
    vc.navigationItem.title = title;
    //    nav.tabBarItem.title = title;
    //    nav.tabBarItem.image = [UIImage imageNamed:imageNamed];

    [self addChildViewController:nav];
}

#pragma mark - MSCustomTabBarViewDelegate

- (void)hfTabBarView:(HFTabBarView *)view didSelectItemAtIndex:(NSInteger)index
{
    // 切换到对应index的viewController
    self.selectedIndex = index;
}

@end

