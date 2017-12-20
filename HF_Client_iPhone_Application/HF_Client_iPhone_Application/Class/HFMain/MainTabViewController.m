//
//  MainTabViewController.m
//  HF_Client_iPhone_Application
//
//  Created by liuyang on 2017/11/10.
//  Copyright © 2017年 HengFeng. All rights reserved.
//

#import "MainTabViewController.h"
#import "HFMyResourceViewController.h"
#import "HFStutentStatusViewController.h"
#import "HFTeachToolViewController.h"
#import "HFClassTestViewController.h"
#import "HFNewStudentStatusViewController.h"
#import "HFNavigationViewController.h"

@interface MainTabViewController ()

@end

@implementation MainTabViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addAllChildViewController];
}


+ (void)initialize
{
    // 通过appearance统一设置所有UITabBarItem的文字属性
    // 后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象来统一设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = UICOLOR_RGB(0xff54BAA6);
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

#pragma mark - Private Methods

// 添加全部的 childViewcontroller
- (void)addAllChildViewController
{
    HFMyResourceViewController *homeVC = [[HFMyResourceViewController alloc] init];
    [self addChildViewController:homeVC title:@"我的资源" image:@"my_source_unselected" selectedImage:@"my_source_selected"];
    
    HFTeachToolViewController *findVC = [[HFTeachToolViewController alloc] init];
    [self addChildViewController:findVC title:@"教学工具" image:@"teach_tool_unselected" selectedImage:@"teach_tool_selected"];
    
    HFClassTestViewController *mineVC = [[HFClassTestViewController alloc] init];
    [self addChildViewController:mineVC title:@"课堂测试" image:@"class_test_unselected" selectedImage:@"class_test_selected"];
    
    HFNewStudentStatusViewController *activityVC = [[HFNewStudentStatusViewController alloc] init];
     [self addChildViewController:activityVC title:@"学生状态" image:@"student_status_unselected" selectedImage:@"student_status_selected"];
    
}



/**
 * 初始化子控制器
 */
- (void)addChildViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置文字和图片
    vc.navigationItem.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    
    // 包装一个导航控制器, 添加导航控制器为tabbarcontroller的子控制器
    HFNavigationViewController *nav = [[HFNavigationViewController alloc] initWithRootViewController:vc];
    nav.navigationBar.barTintColor = UICOLOR_ARGB(0x59c6ce);
    [self addChildViewController:nav];
}

@end

