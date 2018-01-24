//
//  HFNewStudentStatusViewController.m
//  HF_Client_iPhone_Application
//
//  Created by 陈炳桦 on 2017/12/19.
//  Copyright © 2017年 HengFeng. All rights reserved.
//

#import "HFNewStudentStatusViewController.h"
#import "HFStudentStatusPersonViewController.h"
#import "HFStudentStatusGroupViewController.h"
#import "HFStudentStatusRankingViewController.h"


@interface HFNewStudentStatusViewController ()

@end

@implementation HFNewStudentStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)个人模式:(id)sender {
    HFStudentStatusPersonViewController *vc = [HFStudentStatusPersonViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)小组模式:(id)sender {
    HFStudentStatusGroupViewController *vc = [HFStudentStatusGroupViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)排行榜:(id)sender {
    HFStudentStatusRankingViewController *vc = [HFStudentStatusRankingViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
