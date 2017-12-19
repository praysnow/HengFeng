//
//  HFToolVoteViewController.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 14/12/2017.
//  Copyright © 2017 HengFeng. All rights reserved.
//

#import "HFToolVoteViewController.h"

@interface HFToolVoteViewController ()

@end

@implementation HFToolVoteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"教学工具-投票";
    [self showBackButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

@end
