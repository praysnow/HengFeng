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

// 判断数组是否可用
+ (BOOL)NSArrayUseable:(NSArray *)array{
    
    if (array != nil && [array isKindOfClass:[NSArray class]] ){
        return YES;
    }
    
    return NO;
}

// 判断字典是否可用
+ (BOOL)NSDictionaryUseable:(NSDictionary *)dict{
    
    if (dict != nil && [dict isKindOfClass:[NSDictionary class]] ){
        return YES;
    }
    return NO;
}

+ (void)setCookieWithCookieName:(NSString *)name andValue:(NSString *)value
{
    NSMutableDictionary *cookiePropertyDictionary = [NSMutableDictionary dictionary];
    cookiePropertyDictionary[NSHTTPCookieName] = name;
    cookiePropertyDictionary[NSHTTPCookieValue] = value;
    cookiePropertyDictionary[NSHTTPCookieDomain] = @"http://222.16.80.43";
    cookiePropertyDictionary[NSHTTPCookiePath] = @"/";
    cookiePropertyDictionary[NSHTTPCookieMaximumAge] = @"99999999";
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties: cookiePropertyDictionary];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie: cookie];
}

+ (void)teacherControl
{
//        NSString *loginStatus = @"Login?name=TeacherCtrl&os=android&class=defaultEx";
    
    NSString *resultStr = @"<?xml version=\"1.0\" encoding=\"utf-16\"?>\
    <XmlPkHeader xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" From=\"TeacherCtrl\" To=\"=\" CommandCode=\"CtrlCmd\" Channel=\"\" PKID=\"e1963ff6-0c5e-4ad1-a523-4b9dadf50b19\" />{7A76F682-6058-4EBC-A5AF-013A4369EE0E}111";
    NSLog(@"教师端发送命令为: %@",resultStr);
}

+ (NSString *)regulexFromString:(NSString *)mainString
                 andStartString:(NSString *)startString
                   andEndString:(NSString *)endString
{
    NSString *url = mainString;
    NSError *error;
    NSString *result;
    // 创建NSRegularExpression对象并指定正则表达式
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern: [NSString stringWithFormat: @"(?<=%@).*(?=%@)", startString, endString]
                                  options:0
                                  error:&error];
    if (!error) { // 如果没有错误
        // 获取特特定字符串的范围
        NSTextCheckingResult *match = [regex firstMatchInString:url
                                                        options:0
                                                          range:NSMakeRange(0, [url length])];
        if (match) {
            // 截获特定的字符串
            result = [url substringWithRange:match.range];
        }
    } else { // 如果有错误，则把错误打印出来
        NSLog(@"正则取值错误为: error - %@", error);
    }
    return result;
}

+ (UIViewController *)topViewController
{
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

@end
