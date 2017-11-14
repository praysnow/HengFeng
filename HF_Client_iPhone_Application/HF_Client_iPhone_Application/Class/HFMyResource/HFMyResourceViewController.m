//
//  HFMyResourceViewController.m
//  HF_Client_iPhone_Application
//
//  Created by liuyang on 2017/11/10.
//  Copyright © 2017年 HengFeng. All rights reserved.
//

#import "HFMyResourceViewController.h"

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]

#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface HFMyResourceViewController ()

@end

@implementation HFMyResourceViewController

- (instancetype)init
{
    if (self = [super init]) {
        // 设置标题
        self.tabBarItem.title = @"界面1";
        // 设置图片,只有设置图片的渲染模式，才能看到图片
        self.tabBarItem.image = [[UIImage imageNamed:@"tabbar_match_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        // 设置角标,如果没有设置图片，角标默认显示在左上角，设置了图片就会在图片的右上角显示
//        self.tabBarItem.badgeValue = @"10";

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = randomColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
