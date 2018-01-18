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

@interface HFTeacherCaptureViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageVIew;
@property (weak, nonatomic) IBOutlet TKImageView *tkImageView;
@property (weak, nonatomic) IBOutlet UIButton *unlimiteTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *wrongButton;

@end

@implementation HFTeacherCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"截屏测验";
    [self rotationScreen];
    [self setUpTKImageView];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reveviedImageFromNotifaiction) name: @"imageUrl" object: nil];
    [self.imageVIew sd_setImageWithURL: nil placeholderImage: [UIImage imageNamed: @"guide_capture"]];
}

- (void)setUpTKImageView
{
//    _rightButton setImage: [] forState:<#(UIControlState)#>
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
- (void)rotationScreen{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //允许转成横屏
    appDelegate.allowRotation = YES;
    //调用转屏代码
    [UIDevice switchNewOrientation:UIInterfaceOrientationLandscapeRight];
}
- (IBAction)dismissCOntroll:(UIButton *)sender
{
    [self.view bringSubviewToFront: sender];
    [self dismissController];
}

- (void)dismissController{
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = NO;//关闭横屏仅允许竖屏
    //切换到竖屏
    [UIDevice switchNewOrientation:UIInterfaceOrientationPortrait];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)reveviedImageFromNotifaiction
{
    [self.imageVIew sd_setImageWithURL: [NSURL URLWithString: [HFCacheObject shardence].imageUrl]
                      placeholderImage: [UIImage imageNamed: @"tkImageView"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                          self.tkImageView.hidden = NO;
                          self.tkImageView.toCropImage = image;
                      }];
    [MBProgressHUD hideHUDForView: self.view animated: YES];
}

#pragma mark - Tapped

- (IBAction)sendAway:(UIButton *)sender
{
//    [[HFSocketService sharedInstance] sendCtrolMessage: @[SCREEN_CAPTURE_UNTIME]];
    [[HFSocketService sharedInstance] sendCtrolMessage: @[@"80"]];
    
//    [MBProgressHUD showHUDAddedTo: self.view animated: YES];
}

- (IBAction)unlimitSendAway:(UIButton *)sender
{
    [[HFSocketService sharedInstance] sendCtrolMessage: @[SCREEN_CAPTURE_TIME]];
//    [MBProgressHUD showHUDAddedTo: self.view animated: YES];
}
- (IBAction)captureScreen:(UIButton *)sender
{
    self.tkImageView.hidden = YES;
    [MBProgressHUD showHUDAddedTo: self.view animated: YES];
    [[HFSocketService sharedInstance] sendCtrolMessage: @[SCREEN_CAPTURE]];
}
- (IBAction)ensureButton:(UIButton *)sender
{
    [HF_MBPregress showMessag: @"裁剪成功"];
}
- (IBAction)cancelButton:(UIButton *)sender
{
    [HF_MBPregress showMessag: @"取消裁剪"];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

@end
