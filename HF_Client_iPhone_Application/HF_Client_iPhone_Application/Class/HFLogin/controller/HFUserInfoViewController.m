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
#import "AppDelegate.h"
#import "SystemSettingView.h"
#import "HFNavigationViewController.h"
#import "HFClassSituationViewController.h"

@interface HFUserInfoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (strong, nonatomic) NSArray *array;
@property (strong, nonatomic) SystemSettingView *systemSettingView;

@end

@implementation HFUserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib: [UINib nibWithNibName: NSStringFromClass([HFUserInfocellTableViewCell class]) bundle: nil] forCellReuseIdentifier: @"cell"];
    self.avatarImage.layer.masksToBounds = YES;
    self.avatarImage.layer.cornerRadius = self.avatarImage.width / 2;
    [self setdata];
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(action:) name:@"className" object:nil];
}

- (void)action:(NSNotification *)notification {
    NSLog(@"通知我啦！");
    
    [self setdata];
    [self.tableView reloadData];
}

- (void)setdata
{
    NSString *className = [HFCacheObject shardence].className;
    className = className == nil?  @"未获取到课程信息":className;
    self.array = @[@{@"name":@"课程", @"image" : @"课程",@"content" : className},
//                   @{@"name":@"班级学情", @"image" : @"back"},
// 暂时去掉                  @{@"name":@"我的备课", @"image" : @"back"},
                   @{@"name":@"wifi确认", @"image" : @"wifi确认",@"content" : @""},
                   @{@"name":@"系统配置", @"image" : @"系统配置",@"content" : @""}];
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
    
    NSString *name = self.array[indexPath.row][@"name"];
    if ([name isEqualToString:@"课程"]){
        
    }else if ([name isEqualToString:@"班级学情"]){
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIViewController *rootVC = appDelegate.window.rootViewController;
        
        
        HFClassSituationViewController *vc = [HFClassSituationViewController new];
        vc.view.backgroundColor = [UIColor redColor];
        
        HFNavigationViewController *nav = [[HFNavigationViewController alloc] initWithRootViewController:vc];
        [rootVC presentViewController:nav animated:YES completion:nil];
        
    }else if ([name isEqualToString:@"wifi确认"]){
        
        NSString * urlString = @"App-Prefs:root=WIFI"; //
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
                // iOS10之后不允许跳转到设置的子页面，只允许跳转到设置界面(首页)，据说跳转到系统设置子页面，但同时会加大遇到审核被拒的可能性
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
            }
        }
    }else if ([name isEqualToString:@"系统配置"]){
        SystemSettingView *systemSettingView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(SystemSettingView.class) owner:nil options:nil].lastObject;
        self.systemSettingView = systemSettingView;
        systemSettingView.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.9, SCREEN_HEIGHT / 2);
        [systemSettingView.layer setCornerRadius:10];
        systemSettingView.layer.masksToBounds = YES;
        [CBAlertWindow jz_showView:systemSettingView animateType:CBShowAnimateTypeCenter];
        
    }
    

}


- (void)dealloc{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
