//
//  HFLoginViewController.m
//  HF_Client_iPhone_Application
//
//  Created by liuyang on 2017/11/9.
//  Copyright © 2017年 HengFeng. All rights reserved.
//

#import "HFLoginViewController.h"
#import "MainTabViewController.h"

@interface HFLoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *configueButton;
@property (weak, nonatomic) IBOutlet UIButton *wlanButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation HFLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupView];
    [self configuebutton];
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
    MainTabViewController *vc = [[MainTabViewController alloc] init];
    [self presentViewController: vc animated: YES completion:^{
        ;
    }];
//    [self.navigationController pushViewController: vc animated: YES];
}


@end
