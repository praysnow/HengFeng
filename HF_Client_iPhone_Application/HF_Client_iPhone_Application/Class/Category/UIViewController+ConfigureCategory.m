//
//  UIViewController+ConfigureCategory.m
//  jihai
//
//  Created by Caesar on 16/8/11.
//  Copyright © 2016年 haiqiukeji. All rights reserved.
//

#import <objc/runtime.h>

NSString * const viewControllerHideNavigationBarKey = @"viewControllerHideNavigationBarKey";
NSString * const viewControllerHasViewDidAppearedKey = @"viewControllerHasViewDidAppearedKey";

@implementation UIViewController(ConfigureCategory)


- (void)showBackButton
{
    //给返回按钮增加一个 super view 是为了解决默认情况下，返回按钮触发区域太宽的问题
//    UIView *view = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 44, 44)];
//    UIButton *leftButton = [UIButton buttonWithType: UIButtonTypeCustom];
//    leftButton.titleLabel.font = [UIFont systemFontOfSize: 17.0f];
//    [leftButton setTitle: @"返回" forState: UIControlStateNormal];
//    leftButton.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
//    [leftButton addTarget: self action: @selector(tappedBackButton:) forControlEvents: UIControlEventTouchUpInside];
//    [leftButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
//    [view addSubview: leftButton];
//    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: view];
//    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target: nil action: nil];
//    fixedSpaceBarButtonItem.width = -19.5;
//    self.navigationItem.leftBarButtonItems = @[fixedSpaceBarButtonItem, leftBarButtonItem];
}

- (void)tappedBackButton:(id)sender
{
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count > 1) {
            [self.navigationController popViewControllerAnimated: YES];
        } else {
            [self.navigationController dismissViewControllerAnimated: YES completion: nil];
        }
    } else {
        [self dismissViewControllerAnimated: YES completion: nil];
    }
}

- (void)showRightTextButton:(NSString *)text
{
}

- (void)handleRightButtonAction:(id)sender
{
    if ([self respondsToSelector: NSSelectorFromString(@"tappedRightButton:")]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector: NSSelectorFromString(@"tappedRightButton:") withObject: sender];
#pragma clang diagnostic pop
    }
}

- (void)showRightShareButton
{
}

- (void)handleShareButtonAction:(id)sender
{
    if ([self respondsToSelector: NSSelectorFromString(@"tappedShareButton:")]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector: NSSelectorFromString(@"tappedShareButton:") withObject: sender];
#pragma clang diagnostic pop
    }
}

- (void)showJihaiNavigationTitle
{
    UILabel *navigationTitleLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 100, 44)];
    navigationTitleLabel.textAlignment = NSTextAlignmentCenter;
    navigationTitleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = navigationTitleLabel;
}

- (void)scrollViewPanGestureRecognizerRequireScreenEdgePanGestureRecognizerToFail:(UIScrollView *)scrollView
{
    for (UIGestureRecognizer *gestureRecognizer in self.navigationController.view.gestureRecognizers) {
        if ([gestureRecognizer isKindOfClass: [UIScreenEdgePanGestureRecognizer class]]) {
            [scrollView.panGestureRecognizer requireGestureRecognizerToFail: gestureRecognizer];
            break;
        }
    }
}

#pragma mark - life cycle

- (void)bogusViewDidLoad
{
    [self bogusViewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)bogusViewWillAppear:(BOOL)animated
{
    [self bogusViewWillAppear: animated];
    [self.navigationController setNavigationBarHidden: self.hideNavigationBar animated: YES];
    //避免出现 view controller 还没完全展示出来，用户已经点击了 navigaiton bar 上的按钮进行下一次跳转了。
    self.navigationController.navigationBar.userInteractionEnabled = NO;
}

- (void)bogusViewDidAppear:(BOOL)animated
{
    [self bogusViewDidAppear: animated];
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    self.hasViewDidAppeared = YES;
}

#pragma mark - getter & setter

- (void)setHideNavigationBar:(BOOL)hideNavigationBar
{
    objc_setAssociatedObject(self, &viewControllerHideNavigationBarKey, @(hideNavigationBar), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hideNavigationBar
{
    return [objc_getAssociatedObject(self, &viewControllerHideNavigationBarKey) boolValue];
}

- (void)setHasViewDidAppeared:(BOOL)hasViewDidAppeared
{
    objc_setAssociatedObject(self, &viewControllerHasViewDidAppearedKey, @(hasViewDidAppeared), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hasViewDidAppeared
{
    return [objc_getAssociatedObject(self, &viewControllerHasViewDidAppearedKey) boolValue];
}

- (BOOL)loadDataIfHaveNoneWithCompletion:(void (^)(void))completion
{
    return YES;
}

#pragma mark - MBProgressHUD相关

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController == nil || self.navigationController.viewControllers.count > 1) {
        //避免在 navigation controller 的根 view controller 时右滑导致程序卡死的情况出现；
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (void)showText:(NSString *)text{
    [self showText:text afterDelay:2.f];
}

- (void)showText:(NSString *)text afterDelay:(NSTimeInterval)delay{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    
    // Move to bottm center.
    //    hud.offset = CGPointMake(0.f, 100);
    
    
    
    [hud hideAnimated:YES afterDelay:delay];
}

@end
