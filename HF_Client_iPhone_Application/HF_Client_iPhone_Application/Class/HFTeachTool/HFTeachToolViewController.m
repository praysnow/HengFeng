//
//  HFStutentStatusViewController.m
//  HF_Client_iPhone_Application
//
//  Created by liuyang on 2017/11/17.
//  Copyright © 2017年 HengFeng. All rights reserved.
//

#import "HFTeachToolViewController.h"
#import "HFToolVoteViewController.h"
#import "HFPPTViewController.h"

@interface HFTeachToolViewController ()

@end

@implementation HFTeachToolViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - tapped


- (IBAction)tappedTeachToolsButton:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
        {
            HFToolVoteViewController *vc = [[HFToolVoteViewController alloc] init];
            [self.navigationController pushViewController: vc animated: YES];
        }
            break;
        case 1:
        {
            NSLog(@"教学分享");
        }
            break;
        case 2:
        {
            NSLog(@"锁屏");
        }
            break;
        case 3:
        {
            NSLog(@"录屏");
        }
            break;
        case 4:
        {
            NSLog(@"随机提问");
        }
            break;
        case 5:
        {
            NSLog(@"抢答");
        }
            break;
        case 6:
        {
            NSLog(@"移动直播");
        }
            break;
        case 7:
        {
            NSLog(@"文件上传");
        }
            break;
        case 8:
        {
            HFPPTViewController *vc = [[HFPPTViewController alloc] init];
            [self.navigationController pushViewController: vc animated: YES];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - tapped action

- (IBAction)tappedLockScreen:(UIButton *)sender
{
    [[HFSocketService sharedInstance] sendCtrolMessage: @[UNLOCK_SCREEN]];
//    sender.selected = !sender.selected;
//    [[HFSocketService sharedInstance] sendCtrolMessage: @[sender.selected ? UNLOCK_SCREEN : LOCK_SCREEN]];
}


@end
