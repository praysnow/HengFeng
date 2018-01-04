//
//  HFUserInfoViewController.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 02/01/2018.
//  Copyright © 2018 HengFeng. All rights reserved.
//

#import "HFUserInfoViewController.h"
#import "HFUserInfocellTableViewCell.h"
#import "CBAlertWindow.h"
#import "HFLoginConfigueView.h"

@interface HFUserInfoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (strong, nonatomic) NSArray *array;
@property (strong, nonatomic) HFLoginConfigueView *configueView;

@end

@implementation HFUserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib: [UINib nibWithNibName: NSStringFromClass([HFUserInfocellTableViewCell class]) bundle: nil] forCellReuseIdentifier: @"cell"];
    self.avatarImage.layer.masksToBounds = YES;
    self.avatarImage.layer.cornerRadius = self.avatarImage.width / 2;
    [self setdata];
}

- (void)setdata
{
    self.array = @[@{@"name":@"课程", @"content" : @"五年级语文"},
                   @{@"name":@"班级学情", @"image" : @"back"},
                   @{@"name":@"我的备课", @"image" : @"back"},
                   @{@"name":@"WIFI连接", @"image" : @"back"},
                   @{@"name":@"系统配置", @"image" : @"back"}];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HFUserInfocellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"cell"];
    cell.dictioanry = self.array[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    switch (indexPath.row) {
        case 0:
        {
        }
            break;
        case 1:
        {
        }
            break;
        case 2:
        {
        }
            break;
        case 3:
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
            break;
        case 4:
        {
            HFLoginConfigueView *configueView = [[NSBundle mainBundle] loadNibNamed: NSStringFromClass(HFLoginConfigueView.class) owner: nil options: nil].lastObject;
            self.configueView = configueView;
            [configueView.layer setCornerRadius: 10];
            configueView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            configueView.layer.masksToBounds = YES;
            [CBAlertWindow jz_showView: configueView animateType: CBShowAnimateTypeCenter];
        }
            break;
            
        default:
            break;
    }
}

@end
