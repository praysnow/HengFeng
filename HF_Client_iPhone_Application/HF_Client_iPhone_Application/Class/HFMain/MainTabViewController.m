//
//  MainTabViewController.m
//  HF_Client_iPhone_Application
//
//  Created by liuyang on 2017/11/10.
//  Copyright © 2017年 HengFeng. All rights reserved.
//

#import "MainTabViewController.h"
#import "HFMyResourceViewController.h"
#import "HFTeachToolViewController.h"
#import "HFStutentStatusViewController.h"
#import "HFCustomTabBar.h"

@interface MainTabViewController () <HFTabBarViewDelegate>

@end

@implementation MainTabViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupappearance];
    
    [self addAllChildViewController];
}

- (void)setupappearance
{
    HFCustomTabBar *tabBar = [[HFCustomTabBar alloc] init];
    tabBar.tabBarView.viewDelegate = self;
    [self setValue:tabBar forKey:@"tabBar"];
    if ([tabBar.subviews count] == 5 && [tabBar.subviews[4] isKindOfClass: [UIImageView class]]) {
        tabBar.subviews[4].backgroundColor = [UIColor clearColor];
    }
}

#pragma mark - Private Methods

// 添加全部的 childViewcontroller
- (void)addAllChildViewController
{
    HFMyResourceViewController *homeVC = [[HFMyResourceViewController alloc] init];
    [self addChildViewController:homeVC title:@"首页" imageNamed:@"tabbar_match_selected"];

    HFStutentStatusViewController *findVC = [[HFStutentStatusViewController alloc] init];
    [self addChildViewController:findVC title:@"教学工具" imageNamed:@"tabbar_match_selected"];

    UIViewController *mineVC = [[UIViewController alloc] init];
    mineVC.view.backgroundColor = [UIColor greenColor];
    [self addChildViewController:mineVC title:@"我的" imageNamed:@"tabbar_match_selected"];
    HFTeachToolViewController *activityVC = [[HFTeachToolViewController alloc] init];
    [self addChildViewController:activityVC title:@"学生状态" imageNamed:@"tabbar_match_selected"];
}

// 添加某个 childViewController
- (void)addChildViewController:(UIViewController *)vc title:(NSString *)title imageNamed:(NSString *)imageNamed
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.navigationItem.title = title;
    vc.navigationController.navigationBar.hidden = YES;
    [self addChildViewController:nav];
}

#pragma mark - MSCustomTabBarViewDelegate

- (void)hfTabBarView:(HFTabBarView *)view didSelectItemAtIndex:(NSInteger)index
{
    // 切换到对应index的viewController
    self.selectedIndex = index;
}

@end

