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
#import "HFTeachShareViewController.h"
#import "ZSVerticalButton.h"
#import "HFLoginViewController.h"

@interface HFTeachToolViewController ()

@property (nonatomic, assign) BOOL isBuzing;

@end

@implementation HFTeachToolViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.stopButton.layer.masksToBounds = YES;
    self.stopButton.layer.cornerRadius = self.stopButton.height / 2;
}

#pragma mark - tapped

- (IBAction)tappedTeachToolsButton:(ZSVerticalButton *)sender
{
    [self changeButtonStatus: sender];
}

- (void)changeButtonStatus:(ZSVerticalButton *)sender
{
    switch (sender.tag) {
        case 0:
        {
            [self.navigationController pushViewController: VIEW_CONTROLLER_FROM_XIB(HFToolVoteViewController) animated: YES];
        }
            break;
        case 1:
        {
            [self.navigationController pushViewController: VIEW_CONTROLLER_FROM_XIB(HFTeachShareViewController) animated: YES];
        }
            break;
        case 2:
        {
            sender.selected = !sender.selected;
            [[HFSocketService sharedInstance] sendCtrolMessage: @[sender.selected ? UNLOCK_SCREEN : LOCK_SCREEN]];
            if (sender.selected) {
                [self setUpShowStatus: @"解锁" andDetail: @"锁屏中..."];
            } else {
                [self setUpShowStatus: nil andDetail: nil];
            }
        }
            break;
        case 3:
        {
            NSLog(@"录屏");
        }
            break;
        case 4:
        {
            sender.selected = !sender.selected;
            [[HFSocketService sharedInstance] sendCtrolMessage: @[sender.selected ? END_ASK_RANDOM : START_ASK_RANDOM]];
            if (sender.selected) {
                [self setUpShowStatus: @"停止" andDetail: @"随机提问中..."];
            } else {
                [self setUpShowStatus: nil andDetail: nil];
            }
        }
            break;
        case 5:
        {
            sender.selected = !sender.selected;
            [[HFSocketService sharedInstance] sendCtrolMessage: @[sender.selected ? END_AWSER : START_AWSER]];
            if (sender.selected) {
                [self setUpShowStatus: @"停止" andDetail: @"抢答中..."];
            } else {
                [self setUpShowStatus: nil andDetail: nil];
            }
        }
            break;
        case 6:
        {
            NSLog(@"移动直播");
            HFLoginViewController *vc = [[HFLoginViewController alloc] init];
            [self.navigationController pushViewController: vc animated: YES];
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
    [sender isShowPointView: !sender.selected];
}

- (void)setUpShowStatus:(NSString *)title andDetail:(NSString *)detail
{
    self.stopButton.hidden = title.length == 0;
    [self.stopButton setTitle: title forState: UIControlStateNormal];
    self.statusLabel.text = detail;
}

- (IBAction)stopButton:(ZSVerticalButton *)sender
{
    sender.selected = !sender.selected;
    [self changeButtonStatus: sender];
}

@end
