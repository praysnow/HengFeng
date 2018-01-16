//
//  HFVerticalButton.m
//  HF_Client_iPhone_Application
//
//  Created by 陈炳桦 on 2018/1/16.
//  Copyright © 2018年 HengFeng. All rights reserved.
//

#import "HFTeachToolButton.h"

@implementation HFTeachToolButton

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
    self.imageView.x = (self.width - self.imageView.width) * 0.5 + 15;
    self.imageView.y = (self.height - self.imageView.height) * 0.5;
    //    self.imageView.y = 30;
    
    //    self.imageView.width = self.width;
    //    self.imageView.height = self.imageView.width;
    
    // 调整文字
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}



@end
