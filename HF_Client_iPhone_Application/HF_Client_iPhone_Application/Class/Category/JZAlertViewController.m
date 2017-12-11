//
//  JZAlertViewController.m
//  JZAppDemo
//
//  Created by Zengyijie' Com  on 2017/8/21.
//  Copyright © 2017年 Zengyijie' Com . All rights reserved.
//

#import "JZAlertViewController.h"
// View

// Controller

// Tool

@interface JZAlertViewController ()
/** 遮盖 */
@property (nonatomic,strong) UIButton *cover;
/** frame */
@property (nonatomic,assign) CGRect contentRect;
@end

@implementation JZAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupInit];
    
    [self setupContentUI];
}

#pragma mark - =========================== Inial Method ====================================
- (void)setupInit{
    
}

- (void)setupContentUI{
    
    // coverView
    [self.view addSubview:self.cover];
    
    // contentView
    [self.view addSubview:self.contentView];
    CGRect contentRect = self.contentView.frame;
    self.contentRect = contentRect;
    CGFloat contentX = contentRect.origin.x;
    CGFloat contentW = contentRect.size.width;
    CGFloat contentH = contentRect.size.height;
    if (self.animateType == JZShowAnimateTypeBottom) {
        self.contentView.frame = CGRectMake(contentX, self.view.frame.size.height, contentW, contentH);
        [UIView animateWithDuration:0.25 animations:^{
            self.contentView.frame = self.contentRect;
        }];
    }else if (self.animateType == JZShowAnimateTypeCenter){
        self.contentView.frame = CGRectMake(0, 0, contentW, contentH);
        self.contentView.center = self.view.center;
        [self shakeToShow:self.contentView];
    }
}

#pragma mark - =========================== Private Method ===================================
- (void)shakeToShow:(UIView *)aView{
    CAKeyframeAnimation * popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.35;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05f, 1.05f, 1.0f)],
                            //                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.5f, /*@0.75f,*/ @0.8f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     //                                    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
          
    [aView.layer addAnimation:popAnimation forKey:nil];
}

#pragma mark - =========================== Touch Event ======================================
- (void)coverDidClick{
    
    // 点击空白是否隐藏
    if (_coverClickHide) {
        return;
    }
    
    if (self.animateType == JZShowAnimateTypeBottom) {
        CGFloat h = self.view.frame.size.height;
        [UIView animateWithDuration:0.25 animations:^{
            self.contentView.frame = CGRectMake(self.contentRect.origin.x, h, self.contentRect.size.width, self.contentRect.size.height);
            _cover.alpha = 0;
        } completion:^(BOOL finished) {
            [self.contentView removeFromSuperview];
            [_cover removeFromSuperview];
            self.contentView = nil;
            self.cover = nil;
            [JZAlertWindow jz_hide];
        }];
    }else if (self.animateType == JZShowAnimateTypeCenter){
        [UIView animateWithDuration:0.15 animations:^{
            _cover.alpha = 0;
        } completion:^(BOOL finished) {
            [self.contentView removeFromSuperview];
            [_cover removeFromSuperview];
            self.contentView = nil;
            self.cover = nil;
            [JZAlertWindow jz_hide];
        }];
    }
}


#pragma mark - =========================== Setter/Getter ====================================
- (UIButton *)cover{
    if (!_cover) {
        _cover = [UIButton buttonWithType:UIButtonTypeCustom];
        _cover.frame = self.view.bounds;
        _cover.backgroundColor = [UIColor blackColor];
        _cover.alpha = 0.7;
        [_cover addTarget:self action:@selector(coverDidClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cover;
}

@end
