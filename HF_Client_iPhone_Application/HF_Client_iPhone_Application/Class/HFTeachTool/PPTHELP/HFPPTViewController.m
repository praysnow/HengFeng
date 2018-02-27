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

@property(nonatomic,strong)UIButton *button; // 返回按钮


@property(nonatomic,strong)NSMutableArray *pointArray; // 点的数组

@property(nonatomic,assign)CGFloat XRatio;// x轴上的比例
@property(nonatomic,assign)CGFloat YRatio;// y轴上的比例

@property (weak, nonatomic) IBOutlet UIButton *remarkButton; // 批注按钮
@property (weak, nonatomic) IBOutlet UIView *muneView; // 菜单视图

@property (weak, nonatomic) IBOutlet UIButton *blackButton;
@property (weak, nonatomic) IBOutlet UIButton *whiteButton;
@property (weak, nonatomic) IBOutlet UIButton *blueButton;
@property (weak, nonatomic) IBOutlet UIButton *greenButton;
@property (weak, nonatomic) IBOutlet UIButton *redButton;

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
    self.muneView.hidden = YES;
    
    // 左上角的退出按钮
    _button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    
    [_button addTarget:self action:@selector(dismissController) forControlEvents:UIControlEventTouchUpInside];
    [_button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [_button setBackgroundColor:[UIColor blackColor]];
    _button.alpha = 0.5;
    [self.view addSubview:_button];
    
    [self buttonInit:self.blackButton];
    [self buttonInit:self.whiteButton];
    [self buttonInit:self.blueButton];
    [self buttonInit:self.greenButton];
    [self buttonInit:self.redButton];
}

// 设置button的圆环
- (void)buttonInit:(UIButton *)button{
    button.layer.borderWidth = 2;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.cornerRadius = 2;
    button.layer.masksToBounds = YES;
    
    if(button == self.redButton){
        button.superview.backgroundColor = MainColor;
    }
    
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClick:(UIButton *)button{
    
    self.blackButton.superview.backgroundColor = [UIColor whiteColor];
    self.whiteButton.superview.backgroundColor = [UIColor whiteColor];
    self.blueButton.superview.backgroundColor = [UIColor whiteColor];
    self.greenButton.superview.backgroundColor = [UIColor whiteColor];
    self.redButton.superview.backgroundColor = [UIColor whiteColor];
    
    button.superview.backgroundColor = MainColor;
    
    // （0 红色，1黑色，2蓝色，3白色， 4绿色
    if (button == self.redButton) {
        self.imageView.style.lineColor = [UIColor redColor];
        [[HFSocketService sharedInstance] sendCtrolMessage: @[WRITER_RECOMMEND,@"4",@"0",@"",@""]];
    }else if(button == self.blackButton){
        self.imageView.style.lineColor = [UIColor blackColor];
        [[HFSocketService sharedInstance] sendCtrolMessage: @[WRITER_RECOMMEND,@"4",@"1",@"",@""]];
    }else if(button == self.blueButton){
        self.imageView.style.lineColor = [UIColor blueColor];
        [[HFSocketService sharedInstance] sendCtrolMessage: @[WRITER_RECOMMEND,@"4",@"2",@"",@""]];
        
    }else if(button == self.whiteButton){
        self.imageView.style.lineColor = [UIColor purpleColor];
        [[HFSocketService sharedInstance] sendCtrolMessage: @[WRITER_RECOMMEND,@"4",@"3",@"",@""]];
        
    }else if(button == self.greenButton){
        self.imageView.style.lineColor = [UIColor greenColor];
        [[HFSocketService sharedInstance] sendCtrolMessage: @[WRITER_RECOMMEND,@"4",@"4",@"",@""]];
        
    }
    
}

- (void)sendMessage{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.userInteractionEnabled = NO;
    
    // 发送截屏指令
    [[HFSocketService sharedInstance] sendCtrolMessage:@[SCREEN_CAPTURE]];
}

- (void)action:(NSNotification *)notification {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSLog(@"通知我啦！%@",[HFCacheObject shardence].imageUrl);
    
    NSString *string = [HFCacheObject shardence].imageUrl;


    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:string] options:nil progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {

    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {

        _XRatio = image.size.width / (SCREEN_WIDTH - 44);
        _YRatio = image.size.height / SCREEN_HEIGHT;

        // 压缩图片
        NSData *udata = UIImageJPEGRepresentation(image, 0.25);
        UIImage *uimage = [UIImage imageWithData:udata];
        self.imageView.image = uimage;

    }];
    
//    self.imageView.image = nil;
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:string]  completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//
//        NSLog(@"图片大小 %f %f",image.size.width,image.size.height);
//
//        _XRatio = image.size.width / (SCREEN_WIDTH - 44);
//        _YRatio = image.size.height / SCREEN_HEIGHT;
//
//        NSLog(@"图片比例 %f %f",_XRatio,_YRatio);
//    }];
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
    
    // 发送结束批注的指令
    [[HFSocketService sharedInstance] sendCtrolMessage:@[CLOSE_RECOMMEND]];
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = NO;//关闭横屏仅允许竖屏
    //切换到竖屏
    [UIDevice switchNewOrientation:UIInterfaceOrientationPortrait];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)upPage:(id)sender {
    NSLog(@"上一页");
    [[HFSocketService sharedInstance] sendCtrolMessage: @[PPT_LEFT_PAGE]];
    
    self.imageView.brush = nil;
    
    // 撤销所有笔画
    while ([self.imageView canRevoke]){
        [self.imageView revoke];
    }
    
    // 发送结束批注的指令
    [[HFSocketService sharedInstance] sendCtrolMessage:@[CLOSE_RECOMMEND]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 发送刷新的指令
        [self sendMessage];
    });
    
    
    self.remarkButton.selected = NO;
    self.remarkButton.backgroundColor = [UIColor whiteColor];
}

- (IBAction)downPage:(id)sender {
    NSLog(@"下一页");
    
    
    
    // 发送结束批注的指令
    [[HFSocketService sharedInstance] sendCtrolMessage:@[CLOSE_RECOMMEND]];
    
    // 发送下一步的指令
    [[HFSocketService sharedInstance] sendCtrolMessage: @[PPT_RIGHT_PAGE]];
    
    self.imageView.brush = nil;
    
    // 撤销所有笔画
    while ([self.imageView canRevoke]){
        [self.imageView revoke];
    }
        
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 发送刷新的指令
        [self sendMessage];
    });
    
    self.remarkButton.selected = NO;
    self.remarkButton.backgroundColor = [UIColor whiteColor];
}


- (IBAction)remark:(id)sender {
    NSLog(@"批注");
    
    [[HFSocketService sharedInstance] sendCtrolMessage: @[RECOMMEND]];

    if(self.imageView.brush == nil){
        self.imageView.brush = [LXFPencilBrush new];
        self.imageView.style.lineColor = [UIColor redColor]; // 默认是红色
        self.imageView.style.lineWidth = 2;
        self.imageView.delegate = self;
    }
    
   
    
    self.remarkButton.selected = YES;
    self.remarkButton.backgroundColor = MainColor;
    self.muneView.hidden = NO;
    
}
- (IBAction)refresh:(id)sender {
    NSLog(@"刷新");
    
    // 发送刷新的指令
    [self sendMessage];
    
   
}

- (IBAction)cancel:(id)sender {
    NSLog(@"撤销");
    
    [self.imageView revoke];
    
    [[HFSocketService sharedInstance] sendCtrolMessage: @[WRITER_RECOMMEND,@"2",@"",@"",@""]];
}

- (IBAction)clear:(id)sender {
    NSLog(@"清除");
    
    // 撤销所有
    while ([self.imageView canRevoke]){
        [self.imageView revoke];
    }
    
    [[HFSocketService sharedInstance] sendCtrolMessage: @[WRITER_RECOMMEND,@"3",@"",@"",@""]];
}



#pragma mark - LXFDrawBoardDelegate
- (NSString *)LXFDrawBoard:(LXFDrawBoard *)drawBoard textForDescLabel:(UILabel *)descLabel{
    return @"";
}
- (void)LXFDrawBoard:(LXFDrawBoard *)drawBoard clickDescLabel:(UILabel *)descLabel{
    
}
- (void)touchesBeganWithLXFDrawBoard:(LXFDrawBoard *)drawBoard{
//    NSLog(@"开始触摸");
    
    self.pointArray = nil;

    self.muneView.hidden = YES;
}

- (void)touchesMovedWithLXFDrawBoard:(LXFDrawBoard *)drawBoard{
//    NSLog(@"开始移动");
    if (self.imageView.brush != nil) {
        LXFBaseBrush *brush =  self.imageView.brush;
        [self.pointArray addObject:@"1"];
        [self.pointArray addObject:@(brush.endPoint.x * _XRatio)];
        [self.pointArray addObject:@(brush.endPoint.y * _YRatio)];
        [self.pointArray addObject:@"0.5"];
    }
    
//    self.muneView.hidden = YES;
}

- (void)touchesEndedWithLXFDrawBoard:(LXFDrawBoard *)drawBoard{
//    NSLog(@"停止移动");
    if (self.imageView.brush != nil) {
        LXFBaseBrush *brush =  self.imageView.brush;
        [self.pointArray addObject:@"1"];
        [self.pointArray addObject:@(brush.endPoint.x * _XRatio)];
        [self.pointArray addObject:@(brush.endPoint.y * _YRatio)];
        [self.pointArray addObject:@"0.5"];
        
        NSMutableArray *messageArray = [NSMutableArray array];
        [messageArray addObject:WRITER_RECOMMEND];
        [messageArray addObjectsFromArray:self.pointArray];
        
        [[HFSocketService sharedInstance] sendCtrolMessage: messageArray];
    }
    
//    self.muneView.hidden = NO;
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
