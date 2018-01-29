//
//  HFToolVoteViewController.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 14/12/2017.
//  Copyright © 2017 HengFeng. All rights reserved.
//

#import "HFToolVoteViewController.h"

@interface HFToolVoteViewController ()

@property (nonatomic,strong) UIImageView *coverImageView;

@end

@implementation HFToolVoteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"教学工具-投票";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    self.coverImageView.hidden = NO;
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

- (UIImageView *)coverImageView
{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"尚未投票"]];
        _coverImageView.contentMode = UIViewContentModeCenter;
        _coverImageView.backgroundColor = [UIColor whiteColor];
        _coverImageView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 60);
        [self.view addSubview: _coverImageView];
        _coverImageView.hidden = YES;
    }
    return _coverImageView;
}

@end
