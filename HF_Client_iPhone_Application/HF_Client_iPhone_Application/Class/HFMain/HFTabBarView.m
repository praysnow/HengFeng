//
//  HFTabBarView.m
//  HF_Client_iPhone_Application
//
//  Created by liuyang on 2017/11/13.
//  Copyright © 2017年 HengFeng. All rights reserved.
//

#import "HFTabBarView.h"

@interface HFTabBarView ()

@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *items;
@property (nonatomic, strong) UIButton *sender;
@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation HFTabBarView

#pragma mark - Life Cycle

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self setupButtons];
    self.selectIndex = 0;
}

- (void)setupButtons
{
    for (UIButton *button in _items) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (button.tag == 0) {
                [button setBackgroundColor: [UIColor blueColor]];
            }
        });
        button.layer.masksToBounds = YES;
        button.layer.borderColor = [UIColor grayColor].CGColor;
        button.layer.borderWidth = 0.5f;
    }
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

#pragma mark - Actions

- (IBAction)selectItem:(UIButton *)sender
{
    if (self.sender) {
        [self.sender setBackgroundColor: [UIColor whiteColor]];
    }
    self.sender = sender;
         [sender setBackgroundColor: [UIColor blueColor]];
    self.selectIndex = sender.tag;
    ;
    // 让代理来处理切换viewController的操作
    if ([self.viewDelegate respondsToSelector:@selector(hfTabBarView: didSelectItemAtIndex:)]) {
        [self.viewDelegate hfTabBarView:self didSelectItemAtIndex:sender.tag];
    }
}

#pragma mark - Setter

- (void)setSelectIndex:(NSInteger)selectIndex
{
//    // 先把上次选择的item设置为可用
//    UIButton *lastItem = _items[_selectIndex];
////    lastItem.enabled = YES;
//    lastItem.highlighted = NO;
//    // 再把这次选择的item设置为不可用
//    UIButton *item = _items[selectIndex];
////    item.enabled = NO;
//    item.highlighted = YES;
//    _selectIndex = selectIndex;
}

@end

