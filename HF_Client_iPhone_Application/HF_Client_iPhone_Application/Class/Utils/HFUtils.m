//
//  HFUtils.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 24/11/2017.
//  Copyright © 2017 HengFeng. All rights reserved.
//

#import "HFUtils.h"
#import "AppDelegate.h"
#import "MainTabViewController.h"

@implementation HFUtils

+ (void)selectTabBarControllerIndexAndShowRootViewController:(NSInteger)index
{
    MainTabViewController *tabBarController = (MainTabViewController *)((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
    if ([tabBarController isKindOfClass: [MainTabViewController class]]) {
        NSMutableArray *array = [NSMutableArray arrayWithArray: tabBarController.viewControllers];
        if (index < [array count]) {
            tabBarController.selectedIndex = index;
            UINavigationController *navigationController = tabBarController.selectedViewController;
            if ([navigationController isKindOfClass: [UINavigationController class]]) {
                [navigationController popToRootViewControllerAnimated: YES];
            }
        }
    }
}

// json字符串转为OC对象
+ (id)jsonStringToObject:(NSString *)jsonString
{
    
    // 一定要先把jsonString 转为NSMutableString,否则报错
    NSMutableString *jsonDataString=[NSMutableString string];
    [jsonDataString setString:jsonString];
    
    NSData *nsData=[jsonDataString dataUsingEncoding:NSUTF8StringEncoding];
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:nsData options:kNilOptions error:nil];
    
    return jsonObject;
}

+ (void)teacherControl
{
        NSString *loginStatus = @"Login?name=TeacherCtrl&os=android&class=defaultEx";
    
    NSString *resultStr = @"<?xml version=\"1.0\" encoding=\"utf-16\"?>\
    <XmlPkHeader xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" From=\"TeacherCtrl\" To=\"=\" CommandCode=\"CtrlCmd\" Channel=\"\" PKID=\"e1963ff6-0c5e-4ad1-a523-4b9dadf50b19\" />{7A76F682-6058-4EBC-A5AF-013A4369EE0E}111";
    NSLog(@"教师端发送命令为: %@",resultStr);
}

@end
