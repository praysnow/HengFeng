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

@interface HFLoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *configueButton;
@property (weak, nonatomic) IBOutlet UIButton *wlanButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *backGroundView;
@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordFeild;

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
        [[HFNetwork network] SOAPDataWithSoapBody:[model getRequestParams] success:^(NSString * responseObject) {
            if ([responseObject containsString: @"true"]) {
                [HFCacheObject setUserDefaultData: @{@"username":userName, @"passWord":passWord}  andKey: LOGIN_INFO_CACHE];
                MainTabViewController *vc = [[MainTabViewController alloc] init];
                [self presentViewController: vc animated: YES completion:^{
                    ;
                }];
                [self.navigationController pushViewController: vc animated: YES];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error.userInfo);
        }];
    }
}


@end
