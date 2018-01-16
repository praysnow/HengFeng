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
#import "HFTeachToolButton.h"
#import "HFTeachToolLiveViewController.h"
#import "HFFileUploadViewController.h"
#import "HFTeachToolButton.h"

@interface HFTeachToolViewController ()

@property (nonatomic, assign) BOOL isBuzing;
@property (strong, nonatomic) IBOutletCollection(ZSVerticalButton) NSArray *buttonArray;


@end

@implementation HFTeachToolViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.stopButton.layer.masksToBounds = YES;
    self.stopButton.layer.cornerRadius = self.stopButton.height / 2;
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(changeTescherStatus) name: CHANGE_TEACHER_STATUS object: nil];
    
   
}

//- (void)viewWillLayoutSubviews{
//    [super viewWillLayoutSubviews];
//
//    [self initUI];
//}


- (void)initUI{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor redColor];
    bgView.x = 10;
    bgView.y = 64 + 10;
    bgView.width = SCREEN_WIDTH - 20;
    bgView.height = bgView.width;
    
    bgView.layer.borderWidth = 2;
    bgView.layer.borderColor = [UIColor greenColor].CGColor;
    
    [self.view addSubview:bgView];
   
    
    // 添加按钮
    NSInteger rowCount = 3;   // 一排三个
    CGFloat space = 2;
    CGFloat buttonW = (bgView.width - 4)/ rowCount;
    CGFloat buttonH = buttonW;
    
    
    for (int i = 0; i < 9; i++) {
        CGFloat buttonX = (i % rowCount)  * (buttonW + space);
        CGFloat buttonY = (i / rowCount)  * (buttonH + space);
        
        HFTeachToolButton *button = [[HFTeachToolButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
        button.tag = i;
        
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitle:@"测试" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"vote"] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        
//        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [bgView addSubview:button];
	    }
	}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)changeTescherStatus
{
    for (ZSVerticalButton *button in self.buttonArray) {
        switch (button.tag) {
            case 0:
                {
                    button.selected = [HFCacheObject shardence].voteMsg.length != 0;
                }
                break;
            case 1:
            {
                button.selected = [HFCacheObject shardence].guidedLearningInfo.length != 0;
            }
                break;
            case 2:
            {
                button.selected = [[HFCacheObject shardence].iosLookScreen isEqualToString: @"true"];
            }
                break;
            case 3:
            {
                //录屏
//                button.selected = [HFCacheObject shardence].voteMsg.length != 0;
            }
                break;
            case 4:
            {
                //随机提问
                //                button.selected = [HFCacheObject shardence].voteMsg.length != 0;
            }
                break;
            case 5:
            {
                //抢答
                //                button.selected = [HFCacheObject shardence].voteMsg.length != 0;
            }
                break;
            case 6:
            {
                //移动直播
                //                button.selected = [HFCacheObject shardence].voteMsg.length != 0;
            }
                break;
            case 7:
            {
                //文件传输助手
                //                button.selected = [HFCacheObject shardence].voteMsg.length != 0;
            }
                break;
            case 8:
            {
                //PPT助手
                //                button.selected = [HFCacheObject shardence].voteMsg.length != 0;
            }
                break;
                
            default:
                break;
        }
    }
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
            sender.selected = !sender.selected;
            [[HFSocketService sharedInstance] sendCtrolMessage: @[sender.selected ? UP_SCREEN : STOP_UP_SCREEN]];
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
            HFTeachToolLiveViewController *vc = [[HFTeachToolLiveViewController alloc] init];
            [self.navigationController pushViewController: vc animated: YES];
        }
            break;
        case 7:
        {
            NSLog(@"文件上传");
            HFFileUploadViewController *vc = [HFFileUploadViewController new];
            [self.navigationController pushViewController:vc animated:YES];
            
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
