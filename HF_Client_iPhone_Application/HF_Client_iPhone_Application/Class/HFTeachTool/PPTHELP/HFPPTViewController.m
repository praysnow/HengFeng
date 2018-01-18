//
//  HFPPTViewController.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 19/12/2017.
//  Copyright © 2017 HengFeng. All rights reserved.
//

#import "HFPPTViewController.h"
#import "HFNavigationViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIDevice+TFDevice.h"

@interface HFPPTViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property(nonatomic,strong)UIButton *button;

@end

@implementation HFPPTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSString *string = @"ftp://192.168.15.194/root/cut_screen_temp/20180118102014.jpeg";
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"black.jpg"]];
    
    _button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 125, 44)];
    
    [_button addTarget:self action:@selector(dismissController) forControlEvents:UIControlEventTouchUpInside];
    [_button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.view addSubview:_button];
    
    // 旋转屏幕
    [self rotationScreen];
    
    // 发送截屏指令
   [[HFSocketService sharedInstance] sendCtrolMessage:@[SCREEN_CAPTURE]];
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(action:) name:@"imageUrl" object:nil];
}

- (void)action:(NSNotification *)notification {
    NSLog(@"通知我啦！%@",notification.object);
}

// 旋转屏幕
- (void)rotationScreen{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //允许转成横屏
    appDelegate.allowRotation = YES;
    //调用转屏代码
    [UIDevice switchNewOrientation:UIInterfaceOrientationLandscapeRight];
}



- (void)dismissController{
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = NO;//关闭横屏仅允许竖屏
    //切换到竖屏
    [UIDevice switchNewOrientation:UIInterfaceOrientationPortrait];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



//- (IBAction)tpppedPptHelpAction:(UIButton *)sender
//{
//    switch (sender.tag) {
//        case 0:
//            {
//                [[HFSocketService sharedInstance] sendCtrolMessage: @[PPT_LEFT_PAGE]];
//            }
//            break;
//        case 1:
//        {
//            [[HFSocketService sharedInstance] sendCtrolMessage: @[PPT_CLOSE_PAGE]];
//        }
//            break;
//        case 2:
//        {
//            [[HFSocketService sharedInstance] sendCtrolMessage: @[PPT_RIGHT_PAGE]];
//        }
//            break;
//        default:
//            break;
//    }
//}

//MARK:状态栏的显示（横屏系统默认会隐藏的）
- (BOOL)prefersStatusBarHidden{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    NSLog(@"HFPPTViewController delloc");
}

@end
