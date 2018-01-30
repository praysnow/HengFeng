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
#import "HFFileUploadViewController.h"
#import "HFTeachToolLiveViewController.h"
#import "HFFileUploadViewController.h"

@interface HFTeachToolViewController ()

@property (nonatomic, assign) BOOL isBuzing;
@property (nonatomic, assign) BOOL allowClick;
@property (nonatomic, strong) ZSVerticalButton *selectedButton;

@property (strong, nonatomic) IBOutletCollection(ZSVerticalButton) NSArray *buttonArray;
@property (weak, nonatomic) IBOutlet ZSVerticalButton *voteButton;
@property (weak, nonatomic) IBOutlet ZSVerticalButton *shareButton;
@property (weak, nonatomic) IBOutlet ZSVerticalButton *lockButton;
@property (weak, nonatomic) IBOutlet ZSVerticalButton *recordingButton;
@property (weak, nonatomic) IBOutlet ZSVerticalButton *randomButton;
@property (weak, nonatomic) IBOutlet ZSVerticalButton *fastButton;
@property (weak, nonatomic) IBOutlet ZSVerticalButton *mobileButton;
@property (weak, nonatomic) IBOutlet ZSVerticalButton *fileUploadButton;
@property (weak, nonatomic) IBOutlet ZSVerticalButton *pphelper;

@end

@implementation HFTeachToolViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.stopButton.layer.masksToBounds = YES;
    self.stopButton.layer.cornerRadius = self.stopButton.height / 2;
    //接收教学工具状态返回通知
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(changeTescherStatus) name: CHANGE_TEACHER_STATUS  object: nil];
}

- (void)changeTescherStatus
{
    [MBProgressHUD hideHUDForView: self.view animated: YES];
    NSLog(@"锁屏返回的指令是: %zi", [HFCacheObject shardence].isLockScreen);
    self.lockButton.selected = [HFCacheObject shardence].isLockScreen;
    self.shareButton.selected = [HFCacheObject shardence].BrocastDesktop;
    self.fastButton.selected = [HFCacheObject shardence].Racing;
    if (self.lockButton.selected) {
        [self setUpShowStatus: @"停止锁屏" andDetail: @"锁屏中..."];
    } else if (self.shareButton.selected) {
        [self setUpShowStatus: @"停止教学分享" andDetail: @"教学分享中..."];
    } else if (self.fastButton.selected) {
        [self setUpShowStatus: @"停止抢答" andDetail: @"抢答中..."];
    }  else if (self.randomButton.selected) {
            [self setUpShowStatus: @"停止随机提问" andDetail: @"随机提中..."];
    } else {
        self.stopButton.hidden = YES;
        self.statusLabel.hidden = YES;
    }
//    self.lockButton.selected = [HFCacheObject shardence].isLockScreen;
//    self.lockButton.selected = [HFCacheObject shardence].isLockScreen;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

///////////////////////////////////重写逻辑

#pragma mark - click button
- (IBAction)voteButton:(id)sender {
  [self.navigationController pushViewController: VIEW_CONTROLLER_FROM_XIB(HFToolVoteViewController) animated: YES];
    NSLog(@"投票");
}

- (IBAction)shareButton:(ZSVerticalButton *)sender {
    NSLog(@"教学分享");
//    [MBProgressHUD showHUDAddedTo: self.view animated: YES];
    [[HFSocketService sharedInstance] sendCtrolMessage: @[sender.selected ? END_TESCHER_SHARE : START_TESCH_SHARE]];
}

- (IBAction)lockButton:(ZSVerticalButton *)sender {
    NSLog(@"锁屏");
//    [MBProgressHUD showHUDAddedTo: self.view animated: YES];
    [[HFSocketService sharedInstance] sendCtrolMessage: @[sender.selected ? UNLOCK_SCREEN : LOCK_SCREEN]];
}

- (IBAction)recoddingButton:(ZSVerticalButton *)sender {
    NSLog(@"录屏");
    [HF_MBPregress showMessag: @"服务端未支持"];
    [[HFSocketService sharedInstance] sendCtrolMessage: @[sender.selected ? END_RECORDING : START_RECORDING]];
}

- (IBAction)randomButton:(ZSVerticalButton *)sender {
    NSLog(@"随机提问");
    [[HFSocketService sharedInstance] sendCtrolMessage: @[sender.selected ? END_ASK_RANDOM : START_ASK_RANDOM]];
    sender.selected = !sender.selected;
    if (self.fastButton.selected) {
        [self setUpShowStatus: @"停止抢答" andDetail: @"抢答中..."];
    } else {
        [self setUpShowStatus: nil andDetail: nil];
    }
}

- (IBAction)fastAnswerButton:(ZSVerticalButton *)sender {
    NSLog(@"抢答");
//    [MBProgressHUD showHUDAddedTo: self.view animated: YES];
    [[HFSocketService sharedInstance] sendCtrolMessage: @[sender.selected ? END_AWSER : START_AWSER]];
}

- (IBAction)mobileLiveButton:(id)sender {
    NSLog(@"移动直播");
    HFTeachToolLiveViewController *vc = [[HFTeachToolLiveViewController alloc] init];
    [self.navigationController pushViewController: vc animated: YES];
}

- (IBAction)fileUploadButton:(id)sender {
    NSLog(@"文件上传");
    HFFileUploadViewController *vc = [HFFileUploadViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)pptHelperButton:(id)sender {
    NSLog(@"PPT助手");
    HFPPTViewController *vc = [[HFPPTViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}


///////////////////////////////////
- (void)setUpShowStatus:(NSString *)title andDetail:(NSString *)detail
{
    self.stopButton.hidden = title.length == 0;
    [self.stopButton setTitle: title forState: UIControlStateNormal];
    self.statusLabel.text = detail;
}

- (IBAction)stopButton:(ZSVerticalButton *)sender
{
    NSString *text = sender.titleLabel.text;
    if ([text containsString: @"教学分享"]) {
        [[HFSocketService sharedInstance] sendCtrolMessage: @[END_TESCHER_SHARE]];
    } else if ([text containsString: @"录屏"]){
        [[HFSocketService sharedInstance] sendCtrolMessage: @[END_RECORDING]];
    } else if ([text containsString: @"随机提问"]){
        [[HFSocketService sharedInstance] sendCtrolMessage: @[END_ASK_RANDOM]];
    } else if ([text containsString: @"抢答"]){
        [[HFSocketService sharedInstance] sendCtrolMessage: @[END_AWSER]];
    } else if ([text containsString: @"锁"]){
        [[HFSocketService sharedInstance] sendCtrolMessage: @[UNLOCK_SCREEN]];
    }
}

@end
