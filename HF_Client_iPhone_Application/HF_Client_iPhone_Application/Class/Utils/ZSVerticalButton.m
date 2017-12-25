//
//  ZSVerticalButton.m
//  百布招商
//
//  Created by 陈炳桦 on 15/12/29.
//  Copyright © 2015年 陈炳桦. All rights reserved.
//

#import "ZSVerticalButton.h"

@implementation ZSVerticalButton

- (void)setup
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整图片
    self.imageView.x = (self.width - self.imageView.width) * 0.5;
    self.imageView.y = (self.height - self.imageView.height) * 0.5 - 30;
//    self.imageView.y = 30;

//    self.imageView.width = self.width;
//    self.imageView.height = self.imageView.width;
    
    // 调整文字
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
}


@end
