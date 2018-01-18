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
#import "LXFDrawBoard.h"

@interface HFPPTViewController ()<LXFDrawBoardDelegate>

@property (weak, nonatomic) IBOutlet LXFDrawBoard *imageView;

@property(nonatomic,strong)UIButton *button;

@property(nonatomic,strong)NSMutableArray *pointArray; // 点的数组

@property(nonatomic,assign)CGFloat XRatio;// x轴上的比例
@property(nonatomic,assign)CGFloat YRatio;// y轴上的比例

@end

@implementation HFPPTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    
    // 旋转屏幕
    [self rotationScreen];
    
    // 发送截屏指令
    [self sendMessage];
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(action:) name:@"imageUrl" object:nil];
    
    
}

- (void)initUI{
    
    _button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
    
    [_button addTarget:self action:@selector(dismissController) forControlEvents:UIControlEventTouchUpInside];
    [_button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.view addSubview:_button];
}

- (void)sendMessage{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // 发送截屏指令
    [[HFSocketService sharedInstance] sendCtrolMessage:@[SCREEN_CAPTURE]];
}

- (void)action:(NSNotification *)notification {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSLog(@"通知我啦！%@",[HFCacheObject shardence].imageUrl);
    
    NSString *string = [HFCacheObject shardence].imageUrl;

//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"black.jpg"]];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:string]  completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        NSLog(@"图片大小 %f %f",image.size.width,image.size.height);
        
        _XRatio = image.size.width / (SCREEN_HEIGHT - 44);
        _YRatio = image.size.height / SCREEN_WIDTH;
        
        NSLog(@"图片比例 %f %f",_XRatio,_YRatio);
    }];
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

- (IBAction)upPage:(id)sender {
    NSLog(@"上一页");
    [[HFSocketService sharedInstance] sendCtrolMessage: @[PPT_LEFT_PAGE]];
}
- (IBAction)remark:(id)sender {
    NSLog(@"批注");
    
    [[HFSocketService sharedInstance] sendCtrolMessage: @[RECOMMEND]];
    
    [[HFSocketService sharedInstance] sendCtrolMessage: @[WRITER_RECOMMEND,@"1",@"0",@"0",@"0.5",@"1",@"100",@"100",@"0.5"]];
    
    self.imageView.brush = [LXFPencilBrush new];
    self.imageView.style.lineColor = [UIColor redColor]; // 默认是红色
    self.imageView.style.lineWidth = 2;
    self.imageView.delegate = self;
}
- (IBAction)refresh:(id)sender {
    NSLog(@"刷新");
}
- (IBAction)downPage:(id)sender {
    NSLog(@"下一页");
    [[HFSocketService sharedInstance] sendCtrolMessage: @[PPT_RIGHT_PAGE]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    self.pointArray = nil;
    if (self.imageView.brush != nil) {
        LXFBaseBrush *brush =  self.imageView.brush;
        [self.pointArray addObject:@"1"];
        [self.pointArray addObject:@(brush.endPoint.x)];
        [self.pointArray addObject:@(brush.endPoint.y)];
        [self.pointArray addObject:@"0.5"];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.imageView.brush != nil) {
        LXFBaseBrush *brush =  self.imageView.brush;
        [self.pointArray addObject:@"1"];
        [self.pointArray addObject:@(brush.endPoint.x)];
        [self.pointArray addObject:@(brush.endPoint.y)];
        [self.pointArray addObject:@"0.5"];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.imageView.brush != nil) {
        LXFBaseBrush *brush =  self.imageView.brush;
        [self.pointArray addObject:@"1"];
        [self.pointArray addObject:@(brush.endPoint.x)];
        [self.pointArray addObject:@(brush.endPoint.y)];
        [self.pointArray addObject:@"0.5"];
        
        NSMutableArray *messageArray = [NSMutableArray array];
        [messageArray addObject:WRITER_RECOMMEND];
        [messageArray addObjectsFromArray:self.pointArray];
        
        [[HFSocketService sharedInstance] sendCtrolMessage: messageArray];
    }
    
}


#pragma mark - LXFDrawBoardDelegate
- (NSString *)LXFDrawBoard:(LXFDrawBoard *)drawBoard textForDescLabel:(UILabel *)descLabel{
    return @"";
}
- (void)LXFDrawBoard:(LXFDrawBoard *)drawBoard clickDescLabel:(UILabel *)descLabel{
    
}
- (void)touchesBeganWithLXFDrawBoard:(LXFDrawBoard *)drawBoard{
    NSLog(@"开始触摸");
    
    self.pointArray = nil;
//    if (self.imageView.brush != nil) {
//        LXFBaseBrush *brush =  self.imageView.brush;
//        [self.pointArray addObject:@"1"];
//        [self.pointArray addObject:@(brush.endPoint.x)];
//        [self.pointArray addObject:@(brush.endPoint.y)];
//        [self.pointArray addObject:@"0.5"];
//    }
}

- (void)touchesMovedWithLXFDrawBoard:(LXFDrawBoard *)drawBoard{
    NSLog(@"开始移动");
    if (self.imageView.brush != nil) {
        LXFBaseBrush *brush =  self.imageView.brush;
        [self.pointArray addObject:@"1"];
        [self.pointArray addObject:@(brush.endPoint.x)];
        [self.pointArray addObject:@(brush.endPoint.y)];
        [self.pointArray addObject:@"0.5"];
    }
}

- (void)touchesEndedWithLXFDrawBoard:(LXFDrawBoard *)drawBoard{
    NSLog(@"停止移动");
    if (self.imageView.brush != nil) {
        LXFBaseBrush *brush =  self.imageView.brush;
        [self.pointArray addObject:@"1"];
        [self.pointArray addObject:@(brush.endPoint.x)];
        [self.pointArray addObject:@(brush.endPoint.y)];
        [self.pointArray addObject:@"0.5"];
        
        NSMutableArray *messageArray = [NSMutableArray array];
        [messageArray addObject:WRITER_RECOMMEND];
        [messageArray addObjectsFromArray:self.pointArray];
        
        [[HFSocketService sharedInstance] sendCtrolMessage: messageArray];
    }
}


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

- (NSMutableArray *)pointArray{
    if (_pointArray == nil) {
        _pointArray = [NSMutableArray array];
    }
    
    return _pointArray;
}

@end
