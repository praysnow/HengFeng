//
//  HFLoginViewController.m
//  HF_Client_iPhone_Application
//
//  Created by liuyang on 2017/11/9.
//  Copyright © 2017年 HengFeng. All rights reserved.
//

#import "HFLoginViewController.h"
#import "MainTabViewController.h"
#import "WebServiceModel.h"
#import "HFNetwork.h"
#import "HFLoginConfigueView.h"
#import "JZAlertWindow.h"
#import "CBAlertWindow.h"

@interface HFLoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *configueButton;
@property (weak, nonatomic) IBOutlet UIButton *wlanButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *backGroundView;
@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordFeild;
@property (strong, nonatomic) HFLoginConfigueView *configueView;

@end

@implementation HFLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupView];
    [self configuebutton];
    self.userNameTextField.text = @"wanglixia";
    self.passWordFeild.text = @"888888";
}

- (void)configuebutton
{
    [self.closeButton setBackgroundImage: [UIImage imageNamed: @"system_close"] forState: UIControlStateNormal];
    [self.configueButton setBackgroundImage: [UIImage imageNamed: @"ic_set"] forState: UIControlStateNormal];
    [self.wlanButton setBackgroundImage: [UIImage imageNamed: @"wifi2"] forState: UIControlStateNormal];
    [self.loginButton setBackgroundImage: [UIImage imageNamed: @"login_button_bg"] forState: UIControlStateNormal];
    
}

- (void)setupView
{
    self.loginView.layer.masksToBounds = YES;
    self.loginView.layer.cornerRadius = 10;
}

#pragma mark - Tapped Button

- (IBAction)tappedLoginButton:(UIButton *)sender
{
        WebServiceModel *model = [WebServiceModel new];
        model.method = @"CheckUser";
        NSString *userName = self.userNameTextField.text.length == 0 ? @"" : self.userNameTextField.text;
        NSString *passWord = self.userNameTextField.text.length == 0 ? @"" : self.passWordFeild.text;
        model.params = (NSMutableDictionary *)@{@"userLoginName": userName.length != 0 ? userName : @"",@"userPassword": passWord.length != 0 ? passWord: @"", @"userType":@"教师"};
        if (userName.length == 0) {
            NSLog(@"账号不能为空");
        } else if (passWord == 0) {
            NSLog(@"密码不能为空");
        } else {
            [[HFNetwork network] SOAPDataWithUrl: [NSString stringWithFormat: @"%@%@", HOST, LOGIN_INTERFACE] soapBody: [model getRequestParams] success:^(NSString * responseObject) {
                if ([responseObject containsString: @"true"]) {
                    
                    [HFUtils setCookieWithCookieName: @"ASP.NET_SessionId" andValue: @"ht2dhn51h3iq4endlkld0qma"];
                    [HFCacheObject setUserDefaultData: @{@"username":userName, @"passWord":passWord}  andKey: LOGIN_INFO_CACHE];
                }
            } failure:^(NSError *error) {
                NSLog(@"%@",error.userInfo);
            }];
        }
}

- (IBAction)tappedSystemConfigue:(UIButton *)sender
{
    HFLoginConfigueView *configueView = [[NSBundle mainBundle] loadNibNamed: NSStringFromClass(HFLoginConfigueView.class) owner: nil options: nil].lastObject;
    self.configueView = configueView;
    [configueView.layer setCornerRadius: 10];
    configueView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    configueView.layer.masksToBounds = YES;
    [CBAlertWindow jz_showView: configueView animateType: CBShowAnimateTypeCenter];
}

- (IBAction)tappedWifiConfigue:(UIButton *)sender
{
    NSString * urlString = @"App-Prefs:root=WIFI"; //
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
            // iOS10之后不允许跳转到设置的子页面，只允许跳转到设置界面(首页)，据说跳转到系统设置子页面，但同时会加大遇到审核被拒的可能性
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
        }
    }
}

@end
