//
//  SystemSettingView.m
//  flippedclassroomstudent
//
//  Created by 陈炳桦 on 2017/11/10.
//  Copyright © 2017年 陈炳桦. All rights reserved.
//

#import "SystemSettingView.h"
#import "CBAlertWindow.h"
#import "HFNetwork.h"

@interface SystemSettingView()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *domainTextField;

@property (weak, nonatomic) IBOutlet UITextField *IPAdressTextField;
@property (weak, nonatomic) IBOutlet UIView *serverTypeView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *serverType;

@end

@implementation SystemSettingView


- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.domainTextField.delegate = self;
    self.IPAdressTextField.delegate = self;
    
    self.domainTextField.text = [HFNetwork network].ServerAddress; // 公网服务器
    self.IPAdressTextField.text = [HFNetwork network].SocketAddress;// socket服务器
    
    // 默认隐藏
    self.serverTypeView.hidden = YES;
    
    
    // 标题长按
    self.titleLabel.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.titleLabel addGestureRecognizer:tap];
    
    self.serverType.selectedSegmentIndex = [HFNetwork network].serverType;
    
}

- (void)longPress:(UILongPressGestureRecognizer *)tap{
    self.serverTypeView.hidden = NO;
}

- (IBAction)cancelButton:(id)sender {
    NSLog(@"取消");
    [CBAlertWindow jz_hide];
}
- (IBAction)sureButton:(id)sender {
    NSLog(@"确定");
    [CBAlertWindow jz_hide];
    
    // 保存公网服务器地址
    [HFNetwork network].ServerAddress = self.domainTextField.text;
    // 保存Socket服务器地址
    [HFNetwork network].SocketAddress = self.IPAdressTextField.text;
    // 保存服务器类型
    [HFNetwork network].serverType = self.serverType.selectedSegmentIndex;
    
    
    // 先断开后连接
    [[HFSocketService sharedInstance] cutOffSocket];
    [[HFSocketService sharedInstance] socketConnectHost];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    CGFloat duration = 0.25; // 0.25是键盘弹出的时间
    [UIView animateWithDuration:duration animations:^{
        self.y = self.y - 200;
    }];
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    CGFloat duration = 0.25; // 0.25是键盘弹出的时间
    [UIView animateWithDuration:duration animations:^{
        self.y = self.y + 200;
    }];
    return YES;
}

@end
