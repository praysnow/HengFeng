//
//  JZAlertViewController.h
//  JZAppDemo
//
//  Created by Zengyijie' Com  on 2017/8/21.
//  Copyright © 2017年 Zengyijie' Com . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JZAlertWindow.h"

@interface JZAlertViewController : UIViewController

/** contentView */
@property (nonatomic,strong) UIView *contentView;
/** animateType */
@property (nonatomic,assign) JZShowAnimateType animateType;

// 点击空白是否隐藏
@property(assign,nonatomic)BOOL coverClickHide;

@end
