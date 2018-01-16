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

@interface HFTeachToolViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, assign) BOOL isBuzing;
@property (strong, nonatomic) IBOutletCollection(ZSVerticalButton) NSArray *buttonArray;

@property (strong, nonatomic)  UIImagePickerController *imagePickerVC; // 相片选择控制器

@end

@implementation HFTeachToolViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.stopButton.layer.masksToBounds = YES;
    self.stopButton.layer.cornerRadius = self.stopButton.height / 2;
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(changeTescherStatus) name: CHANGE_TEACHER_STATUS object: nil];
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
            [self presentViewController:self.imagePickerVC animated:YES completion:nil];
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

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [self.imagePickerVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.imagePickerVC dismissViewControllerAnimated:YES completion:nil];
    
}

- (UIImagePickerController *)imagePickerVC{
    if (_imagePickerVC == nil) {
        _imagePickerVC = [[UIImagePickerController alloc] init];
        // 只选择本地图片
        _imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePickerVC.delegate = self;
        _imagePickerVC.allowsEditing = YES;
    }
    
    return _imagePickerVC;
}

@end
