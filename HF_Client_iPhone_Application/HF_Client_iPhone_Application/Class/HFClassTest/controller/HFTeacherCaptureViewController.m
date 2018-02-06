//
//  HFTeacherCaptureViewController.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 17/01/2018.
//  Copyright © 2018 HengFeng. All rights reserved.
//

#import "HFTeacherCaptureViewController.h"
#import "UIImageView+WebCache.h"
#import "UIDevice+TFDevice.h"
#import "TKImageView.h"
#import "SCRFTPRequest.h"
#import "HFCountTimeView.h"
#import "CBAlertWindow.h"
#import "HFClassTestShowViewController.h"

@interface HFTeacherCaptureViewController () <SCRFTPRequestDelegate, HFCountTimeViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageVIew;
@property (weak, nonatomic) IBOutlet TKImageView *tkImageView;
@property (weak, nonatomic) IBOutlet UIButton *unlimiteTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *wrongButton;
@property (strong, nonatomic)  NSString *filePath;
@property (nonatomic, strong) HFCountTimeView *countView;
@property (nonatomic, strong) UINavigationController *hf_vagationcontroller;
@property (nonatomic, copy) NSString *updatePath;

@property (strong, nonatomic)  SCRFTPRequest *ftpRequest;


@end

@implementation HFTeacherCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"截屏测验";
    self.hf_vagationcontroller = self.navigationController;
    [self setUpTKImageView];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reveviedImageFromNotifaiction) name: @"imageUrl" object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reveviedPadViewImageView) name: @"reveviedPadViewImageView" object: nil];
    self.imageVIew.contentMode = UIViewContentModeCenter;
    [self.imageVIew sd_setImageWithURL: nil placeholderImage: [UIImage imageNamed: @"guide_capture"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    [self rotationScreen: YES];
    [self.navigationController setNavigationBarHidden: YES animated: animated];
//    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    
    [self rotationScreen: NO];
    [self.navigationController setNavigationBarHidden: NO animated: animated];
    
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        [self.mm_drawerController setRightDrawerViewController:nil];
    }];
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;

}

- (void)setUpTKImageView
{
    _tkImageView.showMidLines = YES;
    _tkImageView.needScaleCrop = YES;
    _tkImageView.showCrossLines = YES;
    _tkImageView.cornerBorderInImage = YES;
    _tkImageView.cropAreaCornerWidth = 44;
    _tkImageView.cropAreaCornerHeight = 44;
    _tkImageView.minSpace = 30;
    _tkImageView.cropAreaCornerLineColor = [UIColor clearColor];
    _tkImageView.cropAreaBorderLineColor = UICOLOR_RGB(0xff53baa6);
    _tkImageView.cropAreaCornerLineWidth = 6;
    _tkImageView.cropAreaBorderLineWidth = 4;
    _tkImageView.cropAreaMidLineWidth = 20;
    _tkImageView.cropAreaMidLineHeight = 6;
    _tkImageView.cropAreaMidLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaCrossLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaCrossLineWidth = 4;
    _tkImageView.initialScaleFactor = .8f;
}

// 旋转屏幕
- (void)rotationScreen: (BOOL)rata
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //允许转成横屏
    appDelegate.allowRotation = rata;
    //调用转屏代码
    if (rata) {
        [UIDevice switchNewOrientation:UIInterfaceOrientationLandscapeRight];
    } else {
        [UIDevice switchNewOrientation:UIInterfaceOrientationPortrait];
    }
}

- (IBAction)dismissCOntroll:(UIButton *)sender
{
    [self rotationScreen: NO];
    [self dismissController];
}

- (void)dismissController
{
    [self.navigationController popViewControllerAnimated: YES];
}

#pragma mark - notifacation

- (void)reveviedPadViewImageView
{
    [self.navigationController pushViewController: VIEW_CONTROLLER_FROM_XIB(HFClassTestShowViewController) animated: YES];
}

- (void)reveviedImageFromNotifaiction
{
    [self.imageVIew sd_setImageWithURL: [NSURL URLWithString: [HFCacheObject shardence].imageUrl]
                      placeholderImage: [UIImage imageNamed: @"guide_capture"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                          self.tkImageView.hidden = NO;
                          self.tkImageView.toCropImage = image;
                          [HF_MBPregress hide_mbpregress];
                      }];
        [MBProgressHUD hideHUDForView: self.view animated: YES];
}

#pragma mark - Tapped

- (IBAction)sendAway:(UIButton *)sender
{
    HFCountTimeView *view = [[[NSBundle mainBundle] loadNibNamed:@"HFCountTimeView" owner:nil options:nil] lastObject];
    self.countView = view;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius  = 5;
    view.delegate = self;
    [CBAlertWindow jz_showView: view animateType: CBShowAnimateTypeCenter];
    NSLog(@"");
}

- (IBAction)unlimitSendAway:(UIButton *)sender
{
    [[HFSocketService sharedInstance] sendCtrolMessage: @[STOP_SCREEN_CAPTURE]];
}

- (IBAction)captureScreen:(UIButton *)sender
{
    [HF_MBPregress mbpregress];
    self.tkImageView.hidden = YES;
    [[HFSocketService sharedInstance] sendCtrolMessage: @[SCREEN_CAPTURE]];
}

- (void)openShowViewController
{
//    [[NSNotificationCenter defaultCenter] postNotificationName: @"reveviedPadViewImageView" object: nil];
//    NSLog(@"测试发通知跳转，正式删掉");
    [CBAlertWindow jz_hide];
}

- (IBAction)ensureButton:(UIButton *)sender
{
    if (self.tkImageView.currentCroppedImage) {
        [self handleImage: self.tkImageView.currentCroppedImage];
    }
    self.tkImageView.hidden = YES;
    self.imageVIew.image
    = self.tkImageView.currentCroppedImage;
}
- (IBAction)cancelButton:(UIButton *)sender
{
    [HF_MBPregress hide_mbpregress];
    self.tkImageView.hidden = YES;
    self.imageVIew.image = [UIImage imageNamed: @"guide_capture"];
    [HF_MBPregress showMessag: @"取消裁剪"];
}

- (void)handleImage:(UIImage *)image{
    _filePath = [NSString stringWithFormat:@"%@%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/classTest"],@"iOS.jpg"];
    
    BOOL isDir = NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/classTest"] isDirectory:&isDir] || isDir == NO) {
        
        [fileManager createDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/classTest"] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // 存储到沙盒
    NSData *data = UIImageJPEGRepresentation(image, 1);
    [fileManager createFileAtPath:_filePath contents:data attributes:nil];
    
    // 上传到ftp
    NSString *urlString = [NSString stringWithFormat:@"ftp://%@/root/uploadtemp/",[HFNetwork network].SocketAddress];
    ;
    _updatePath = [NSString stringWithFormat: @"root/uploadtemp/%@", @"classTestiOS.jpg"];
    _ftpRequest = [[SCRFTPRequest alloc] initWithURL:[NSURL URLWithString:urlString] toUploadFile:_filePath];
    
    _ftpRequest.delegate = self;
    [_ftpRequest startRequest];
    
}

#pragma mark - Limint time Delegate

- (void)limitTimeSend:(NSString *)count
{
    [[HFSocketService sharedInstance] sendCtrolMessage: @[CLOSE_CAPTURE_WINDOW]];
    [self openShowViewController];
    if (_updatePath.length == 0) {
        [HF_MBPregress showMessag: @"请先提交截屏"];
    } else {
    int point = [SCREEN_CAPTURE_TIME intValue] * 10000 + [count intValue] * 10 + 1;
    //+1 是否需要录制、
    [[HFSocketService sharedInstance] sendCtrolMessage: @[@(point), _updatePath]];
    [self openShowViewController];
    }
}

- (void)unlimitTimeSend:(NSString *)count
{
    [[HFSocketService sharedInstance] sendCtrolMessage: @[CLOSE_CAPTURE_WINDOW]];
    if (_updatePath.length == 0) {
        [HF_MBPregress showMessag: @"请先提交截屏"];
    } else {
    int point = [SCREEN_CAPTURE_UNTIME intValue] * 10000 + 1;
    [[HFSocketService sharedInstance] sendCtrolMessage: @[@(point), _updatePath]];
    [self openShowViewController];
    }
}

#pragma mark - SCRFTPRequestDelegate
- (void)ftpRequestDidFinish:(SCRFTPRequest *)request{
    NSLog(@"上传成功");
    [HF_MBPregress showMessag: @"请先提交截屏"];
    [HF_MBPregress hide_mbpregress];
    //    [self showText:@"上传成功"];
    // 删掉本地图片
    
    // 发送指令
    NSString *filePath = [NSString stringWithFormat:@"/root/uploadtemp/classTestiOS.jpg"];
    NSLog(@"ftp路径%@",filePath);
}

- (void)ftpRequest:(SCRFTPRequest *)request didFailWithError:(NSError *)error{
    [HF_MBPregress hide_mbpregress];
    NSLog(@"上传失败");
}

- (void)ftpRequestWillStart:(SCRFTPRequest *)request
{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

@end
