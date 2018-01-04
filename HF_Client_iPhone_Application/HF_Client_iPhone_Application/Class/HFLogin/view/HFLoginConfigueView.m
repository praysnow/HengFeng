//
//  HFLoginConfigueView.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 11/12/2017.
//  Copyright © 2017 HengFeng. All rights reserved.
//

#import "HFLoginConfigueView.h"
#import "CBAlertWindow.h"
#import "HFSocketService.h"

@interface HFLoginConfigueView ()

@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UITextField *service_addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *socket_addressTextField;

@end

@implementation HFLoginConfigueView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.centerView.layer setCornerRadius: 10];
    self.centerView.layer.masksToBounds = YES;
    
    [self.closeButton.layer setCornerRadius: self.closeButton.frame.size.height / 2];
    self.closeButton.layer.masksToBounds = YES;
    NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] valueForKey: ADDRESS_HOST];
    if ([dictionary.allKeys containsObject: @"service_host"] || [dictionary.allKeys containsObject: @"socket_address"]) {
        self.service_addressTextField.text = [dictionary valueForKey: @"service_host"];
        self.socket_addressTextField.text = [dictionary valueForKey: @"socket_address"];
    }
}

- (void)cacheUserDefautlInfo
{
   NSUserDefaults *address = [NSUserDefaults standardUserDefaults];
//    [address setObject: @{@"service_host": self.service_addressTextField.text, @"socket_address" : self.socket_addressTextField.text} forKey: ADDRESS_HOST];
    [address setObject: @{@"service_host": @"http://222.16.80.43/", @"socket_address" : @"192.168.15.222"} forKey: ADDRESS_HOST];
//    [address setObject: @{@"service_host": @"http://222.16.80.43/", @"socket_address" : @"192.168.1.106"} forKey: ADDRESS_HOST];
    [address synchronize];
}

- (IBAction)tapCloseView:(UIButton *)sender
{
    [HFSocketService sharedInstance].service_host  = self.service_addressTextField.text;
    [HFSocketService sharedInstance].socket_host  = self.socket_addressTextField.text;
    [self cacheUserDefautlInfo];
    [CBAlertWindow jz_hide];
}

@end
