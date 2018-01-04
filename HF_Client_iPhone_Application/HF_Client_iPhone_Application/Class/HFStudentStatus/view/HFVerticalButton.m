//
//  HFVerticalButton.m
//  flippedclassroomstudent
//
//  Created by 陈炳桦 on 2017/11/16.
//  Copyright © 2017年 陈炳桦. All rights reserved.
//

#import "HFVerticalButton.h"

@implementation HFVerticalButton

- (void)setup
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:10];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    // hightlight状态
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [self setBackgroundImage:[self imageWithColor:UICOLOR_ARGB(0xff54BAA6) size:self.size] forState:UIControlStateHighlighted];
    
    
    // 选中状态
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self setBackgroundImage:[self imageWithColor:UICOLOR_ARGB(0xff54BAA6) size:self.size] forState:UIControlStateSelected];

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

// 根据颜色和大小获取Image
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整图片
//    self.imageView.width = 30;
//    self.imageView.height = 30;
    
    
    self.imageView.x = (self.width - self.imageView.width) * 0.5;
    self.imageView.y = (self.height - self.imageView.height) * 0.5 - 5;
    
    
    // 调整文字
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height + self.imageView.y;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
}


@end
