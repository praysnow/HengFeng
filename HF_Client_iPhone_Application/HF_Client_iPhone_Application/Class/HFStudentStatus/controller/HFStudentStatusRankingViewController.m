//
//  HFStudentStatusRankingViewController.m
//  HF_Client_iPhone_Application
//
//  Created by 陈炳桦 on 2018/1/4.
//  Copyright © 2018年 HengFeng. All rights reserved.
//

#import "HFStudentStatusRankingViewController.h"
#import "HFPersonRankingViewController.h"
#import "HFGroupRankingViewController.h"

@interface HFStudentStatusRankingViewController ()

@end

@implementation HFStudentStatusRankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"排行榜";
    
    // 添加所有子控制器
    [self setUpAllViewController];
    
    // 设置标题字体
    // 推荐方式
    [self setUpTitleEffect:^(UIColor *__autoreleasing *titleScrollViewColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIFont *__autoreleasing *titleFont, CGFloat *titleHeight,CGFloat *titleWidth) {
        
        // 设置标题字体
        *titleFont = [UIFont systemFontOfSize:16];
        
        *titleScrollViewColor = MainColor;
        
        *norColor = [UIColor grayColor];
        *selColor = [UIColor whiteColor];
        
    }];
    
    // 推荐方式（设置下标）
    [self setUpUnderLineEffect:^(BOOL *isUnderLineDelayScroll, CGFloat *underLineH, UIColor *__autoreleasing *underLineColor,BOOL *isUnderLineEqualTitleWidth) {
        // 标题填充模式
        *underLineColor = [UIColor whiteColor];
    }];
    
    // 设置全屏显示
    // 如果有导航控制器或者tabBarController,需要设置tableView额外滚动区域,详情请看FullChildViewController
    self.isfullScreen = YES;
    self.dragingFollow = YES;
    
    if ([self.rankType isEqualToString:@"个人"]){
        self.selectIndex = 0;
    }else{
        self.selectIndex = 1;
    }
}

// 添加所有子控制器
- (void)setUpAllViewController
{
    
    HFPersonRankingViewController *personVC = [HFPersonRankingViewController new];
    personVC.title = @"个人";
    [self addChildViewController:personVC];
    
    
    HFGroupRankingViewController *groupVC = [HFGroupRankingViewController new];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *PeopleGroupName = [defaults valueForKey:@"PeopleGroupName"];
    groupVC.title = [NSString stringWithFormat:@"小组(%@)",PeopleGroupName];
    [self addChildViewController:groupVC];
    
    
}




@end
