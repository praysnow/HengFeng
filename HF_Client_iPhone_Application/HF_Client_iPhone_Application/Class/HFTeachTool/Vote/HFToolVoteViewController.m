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
    
    [[HFSocketService sharedInstance] sendCtrolMessage: @[RECOMMEND_VOTE]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    
    [[HFSocketService sharedInstance] sendCtrolMessage: @[STOP_VOTE_STATUE]];
}

- (IBAction)tappedToolButton:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
        {
            [[HFSocketService sharedInstance] sendCtrolMessage: @[SINGLE_OR_DOUBLE_CHANGLE]];
        }
            break;
        case 1:
        {
                        [[HFSocketService sharedInstance] sendCtrolMessage: @[SINGLE_OR_DOUBLE_CHANGLE]];
        }
            break;
        case 2:
        {
                        [[HFSocketService sharedInstance] sendCtrolMessage: @[START_OR_RESTART_VOTE]];
        }
            break;
        case 3:
        {
                        [[HFSocketService sharedInstance] sendCtrolMessage: @[STOP_VOTE_STATUE]];
        }
            break;
            
        default:
            break;
    }
}


@end
