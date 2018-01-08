//
//  ZSSelectView.h
//  BaibuSeller
//
//  Created by 陈炳桦 on 16/11/24.
//  Copyright © 2016年 whawhawhat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSSelectView : UIWindow


typedef void(^ResultBlock)(NSInteger index,NSString *result);

@property (nonatomic,strong) NSArray *contentArray; // 展示数据数组

@property (nonatomic,copy) ResultBlock resultBlock;

@property (nonatomic,assign) CGPoint point;

- (void)show;

+ (instancetype)selectViewWithTitle:(NSString *)title andContentArray:(NSArray *)contentArray andResultBlock:(ResultBlock) resultBlock;

-(void)tap;

@end
