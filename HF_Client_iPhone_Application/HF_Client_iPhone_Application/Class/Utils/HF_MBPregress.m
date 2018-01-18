//
//  HF_MBPregress.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 19/01/2018.
//  Copyright © 2018 HengFeng. All rights reserved.
//

#import "HF_MBPregress.h"

@implementation HF_MBPregress

static MBProgressHUD *HUD = nil;

+ (void)hiddenMBProgressHUD
{
    [HUD hideAnimated: YES];
    
}

+ (MBProgressHUD *)MBProgressHUD
{
    return HUD;
}

+ (MBProgressHUD *)showMessag:(NSString *)message
{
    UIViewController *vc = [self topMostController];
    
    if (vc == nil)
    {
        return nil;
    }
    
    if (nil == HUD)
    {
        HUD = [[MBProgressHUD alloc] initWithView:vc.view];
    }
    
    [vc.view addSubview:HUD];
    
    
    HUD.detailsLabel.text = message;
    HUD.detailsLabel.font = [UIFont systemFontOfSize:15];
    HUD.mode = MBProgressHUDModeText;
    HUD.removeFromSuperViewOnHide = YES;
    HUD.margin = 10.f;
    //hud.lineBreakMode = UILineBreakModeWordWrap;
    
    [HUD showAnimated:YES];
    [HUD hideAnimated: YES afterDelay: 1];
    return HUD;
}

+ (UIViewController*) topMostController

{
    
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        
        topController = topController.presentedViewController;
        
    }
    
    return topController;
    
}

@end
