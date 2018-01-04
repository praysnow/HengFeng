//
//  HFNavigationViewController.m
//  HF_Client_iPhone_Application
//
//  Created by 陈炳桦 on 2017/12/19.
//  Copyright © 2017年 HengFeng. All rights reserved.
//

#import "HFNavigationViewController.h"

@interface HFNavigationViewController ()

@end

@implementation HFNavigationViewController


+ (void)initialize
{
    // 当导航栏用在HFNavigationController中, appearance设置才会生效
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:[self class], nil];
//    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:20]}];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    bar.barTintColor = UICOLOR_ARGB(0xff53BAA6);
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) { // 如果push进来的不是第一个控制器
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            [button setTitle:@"返回" forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];

            button.frame = CGRectMake(0, 0, 70, 30);
            // 让按钮内部的所有内容左对齐
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            //        [button sizeToFit];
            // 让按钮的内容往左边偏移10
//            button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
            // 修改导航栏左边的item
            viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        // 隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    // 这句super的push要放在后面, 让viewController可以覆盖上面设置的leftBarButtonItem
    [super pushViewController:viewController animated:animated];
    
}

- (void)back{
    

    [self popViewControllerAnimated:YES];
}




@end
