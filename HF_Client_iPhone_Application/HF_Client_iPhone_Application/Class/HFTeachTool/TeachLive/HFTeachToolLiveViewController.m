//
//  HFTeachToolLiveViewController.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 16/01/2018.
//  Copyright © 2018 HengFeng. All rights reserved.
//

#import "HFTeachToolLiveViewController.h"
#import "TXLiteAVSDK_Smart/TXLivePush.h"
#import "TXLiteAVSDK_Smart/TXLiveBase.h"
#import "HFNetwork.h"

@interface HFTeachToolLiveViewController ()

@property (nonatomic, strong) TXLivePushConfig* config;
@property (nonatomic, strong) TXLivePush* txLivePush;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *stopButton;
@property (nonatomic, strong) UIButton *switchButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, copy)  NSString* rtmpUrl;
@property (nonatomic, strong) UIButton *openLight;
@property (nonatomic, assign) BOOL bEnable;

@end

@implementation HFTeachToolLiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    //   SDK 版本消息
    NSLog(@"SDK Version = %@", [TXLiveBase getSDKVersionStr]);
    [self liveConfigue];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    
    [[HFSocketService sharedInstance] sendCtrolMessage: @[END_LIVE]];
}

- (void)creatBackView
{
    //切换摄像头按钮
    UIButton *switchButton = [[UIButton alloc] initWithFrame: CGRectMake(SCREEN_WIDTH - 14 - 40,  40, 40, 40)];
    [switchButton addTarget: self action: @selector(switchMyCamera) forControlEvents: UIControlEventTouchUpInside];
    switchButton.backgroundColor = [UIColor clearColor];
    [switchButton setTitle: @"O" forState: UIControlStateNormal];
    self.switchButton = switchButton;
    
        //开灯按钮
    UIButton *openLight = [[UIButton alloc] initWithFrame: CGRectMake(SCREEN_WIDTH - 14 - 40,  self.switchButton.bottom + 20, 40, 40)];
    [openLight addTarget: self action: @selector(openOrCloseLight) forControlEvents: UIControlEventTouchUpInside];
    openLight.backgroundColor = [UIColor clearColor];
    [openLight setTitle: @"灯" forState: UIControlStateNormal];
    self.openLight = openLight;

    //返回按钮
    UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(14, 40, 40, 40)];
    [backButton addTarget: self action: @selector(backMainView) forControlEvents: UIControlEventTouchUpInside];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton setTitle: @"<" forState: UIControlStateNormal];
    self.backButton = backButton;

    UIButton *stopButton = [[UIButton alloc] initWithFrame: CGRectMake(SCREEN_WIDTH / 2 - 80,  SCREEN_HEIGHT - 80 - 20, 80 + 40 + 20, 40)];
    [stopButton addTarget: self action: @selector(closeLive:) forControlEvents: UIControlEventTouchUpInside];
    stopButton.backgroundColor = [UIColor greenColor];
    self.stopButton = stopButton;
    [stopButton setTitle: @"关闭" forState: UIControlStateNormal];
    
    [self.backView addSubview: openLight];
    [self.backView addSubview: switchButton];
    [self.backView addSubview: backButton];
    [self.backView addSubview: stopButton];
}

- (void)openOrCloseLight
{
    if (!self.txLivePush.frontCamera) {
        self.bEnable = !self.bEnable;
        //bEnable为YES，打开闪光灯; bEnable为NO，关闭闪光灯
        [_txLivePush toggleTorch: self.bEnable];
        //result为YES，打开成功;result为NO，打开失败
    }
}

- (void)backMainView
{
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)closeLive:(UIButton *)sender
{
    if (!sender.selected) {
        [[HFSocketService sharedInstance] sendCtrolMessage: @[START_LIVE]];
        [self startPush];
    } else {
        [[HFSocketService sharedInstance] sendCtrolMessage: @[END_LIVE]];
        [_txLivePush stopPush];
    }
    [self.stopButton setTitle: @"开始" forState: UIControlStateNormal];
    [self.stopButton setTitle: @"关闭" forState: UIControlStateSelected];
    sender.selected = !sender.selected;
}

- (void)switchMyCamera
{
    [_txLivePush switchCamera];
}

//#define START_LIVE  @"61"
///**
// * 移动直播停止
// */
//#define END_LIVE  @"62"

- (IBAction)startLive:(UIButton *)sender
{
    [self startPush];
}

- (void)startPush
{
    [self.txLivePush startPush: self.rtmpUrl];
}

- (void)liveConfigue
{
    self.txLivePush = [[TXLivePush alloc] initWithConfig: _config];
    self.rtmpUrl = [NSString stringWithFormat: @"rtmp://%@/live/desktopofTeacherCtrl",
                    [HFNetwork network].SocketAddress];
   self.config = [[TXLivePushConfig alloc] init];
   [self.txLivePush startPreview: self.backView];  //myView用来承载我们的渲染控件
    //在 _config中您可以对推流的参数（如：美白，硬件加速，前后置摄像头等）做一些初始化操作，需要注意 _config不能为nil
    [self creatBackView];
}

- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.width, SCREEN_HEIGHT)];
        [self.view addSubview: _backView];
        NSLog(@"Frame: %@", NSStringFromCGRect(_backView.frame));
    }
    return _backView;
}

@end
