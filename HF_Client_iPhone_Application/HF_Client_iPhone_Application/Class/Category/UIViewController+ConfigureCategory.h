//
//  UIViewController+ConfigureCategory.h
//  jihai
//
//  Created by Caesar on 16/8/11.
//  Copyright © 2016年 haiqiukeji. All rights reserved.
//

@interface UIViewController(ConfigureCategory)

/** 设置本 view controller 是否要隐藏 navigation bar */
@property (nonatomic, assign) BOOL hideNavigationBar;
@property (nonatomic, assign, readonly) BOOL hasViewDidAppeared;

- (void)showBackButton;
- (void)tappedBackButton:(id)sender;
/** 调用此方法生成的按钮的响应方法为 tappedRightButton: */
- (void)showRightTextButton:(NSString *)text;
- (void)showRightShareButton;
- (void)showJihaiNavigationTitle;
/** 使得右滑弹出当前 view controller 效果不受 scroll view 影响 */
- (void)scrollViewPanGestureRecognizerRequireScreenEdgePanGestureRecognizerToFail:(UIScrollView *)scrollView;
/** 如果有数据则返回 YES；如果无数据，则返回 NO 并加载数据 */
- (BOOL)loadDataIfHaveNoneWithCompletion:(void (^)(void))completion;


- (void)showText:(NSString *)text;
- (void)showText:(NSString *)text afterDelay:(NSTimeInterval)delay;
@end
