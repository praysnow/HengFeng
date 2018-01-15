//
//  ZSVerticalButton.m
//  百布招商
//
//  Created by 陈炳桦 on 15/12/29.
//  Copyright © 2015年 陈炳桦. All rights reserved.
//

#import "ZSVerticalButton.h"

@interface ZSVerticalButton ()

@property (nonatomic, strong) UIView *pointView;

@end

@implementation ZSVerticalButton

- (void)isShowPointView:(BOOL)isShow
{
    self.pointView.hidden = isShow;
}

- (void)setup
{
    self.titleLabel.x = self.x;
    self.titleLabel.width = self.width;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize: 16];
    
    [self.titleLabel sizeToFit];
    self.pointView = [[UIView alloc] initWithFrame: CGRectMake(self.width - 25, 25, 20, 20)];
    self.pointView.hidden = YES;
    self.pointView.backgroundColor = [UIColor redColor];
    self.pointView.layer.masksToBounds = YES;
    self.pointView.layer.cornerRadius = self.pointView.width / 2;
    [self addSubview: self.pointView];
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
    self.imageView.x = self.x;
    self.imageView.y = (self.height - self.imageView.height) * 0.5 - 5;
//    self.imageView.y = 30;

//    self.imageView.width = self.width;
//    self.imageView.height = self.imageView.width;
    
    // 调整文字
    self.titleLabel.x = self.x;
//    self.titleLabel.top = self.imageView.bottom + 20;
    self.titleLabel.width = self.width;
//    self.titleLabel.height = self.height - self.titleLabel.y;
}


@end
