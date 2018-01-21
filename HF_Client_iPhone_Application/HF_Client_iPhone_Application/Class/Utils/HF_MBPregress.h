//
//  HF_MBPregress.h
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 19/01/2018.
//  Copyright © 2018 HengFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface HF_MBPregress : UIView


/**
 * 显示MBProgressHUD指示器
 * api parameters 说明
 * aTitle 标题
 * aMsg 信息
 * aImg 图片, 为nil时,只显示标题
 * d 延时消失时间, 为0时需要主动隐藏
 * blockE 执行的代码快
 * blockF 结束时的代码块
 * 执行时改变hub需要调用Common_MainFun(aFun)
 */
#define HIDDENMBProgressHUD [MBHUDHelper hiddenMBProgressHUD];
+ (void)hiddenMBProgressHUD;

+ (MBProgressHUD *)MBProgressHUD;

#define SHOWMBProgressHUD(aTitle, aMsg, aImg, aDimBG, aDelay) [MBHUDHelper showMBProgressHUDTitle:aTitle msg:aMsg image:aImg dimBG:aDimBG delay:aDelay];
+ (MBProgressHUD *)showMBProgressHUDTitle:(NSString *)aTitle
                                      msg:(NSString *)aMsg
                                    image:(UIImage *)aImg
                                    dimBG:(BOOL)dimBG
                                    delay:(float)d;

#define SHOWMBProgressHUDIndeterminate(aTitle, aMsg, aDimBG ,aDelay) [MBHUDHelper showMBProgressHUDModeIndeterminateTitle:aTitle msg:aMsg dimBG:aDimBG delay:aDelay];
+ (MBProgressHUD *)showMBProgressHUDModeIndeterminateTitle:(NSString *)aTitle
                                                       msg:(NSString *)aMsg
                                                     dimBG:(BOOL)dimBG
                                                     delay:(float)d;




#define SHOWMBProgressHUDCancelIndeterminate(aTitle, aMsg, aDimBG ,aDelay) [MBHUDHelper SHOWMBProgressHUDCancelIndeterminate:aTitle msg:aMsg dimBG:aDimBG delay:aDelay];
+ (MBProgressHUD *)SHOWMBProgressHUDCancelIndeterminate:(NSString *)aTitle
                                                    msg:(NSString *)aMsg
                                                  dimBG:(BOOL)dimBG
                                                  delay:(float)d;

+ (MBProgressHUD *)showMBProgressHUDTitle:(NSString *)aTitle
                                      msg:(NSString *)aMsg
                                    dimBG:(BOOL)dimBG
                             executeBlock:(void(^)(MBProgressHUD *hud))blockE
                              finishBlock:(void(^)(void))blockF;
+ (MBProgressHUD *)showMessag:(NSString *)message;

+ (void)mbpregress;

+ (void)hide_mbpregress;

@end
