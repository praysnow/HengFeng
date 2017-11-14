//
//  HFTabBarView.h
//  HF_Client_iPhone_Application
//
//  Created by liuyang on 2017/11/13.
//  Copyright © 2017年 HengFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HFTabBarView;

@protocol HFTabBarViewDelegate <NSObject>

@optional

- (void)hfTabBarView:(HFTabBarView *)view didSelectItemAtIndex:(NSInteger)index;

@end

@interface HFTabBarView : UIView

@property (nonatomic, weak) id<HFTabBarViewDelegate> viewDelegate;

@end

