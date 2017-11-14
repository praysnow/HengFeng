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
        button.layer.masksToBounds = YES;
        button.layer.borderColor = [UIColor grayColor].CGColor;
        button.layer.borderWidth = 0.5f;
    }
}

#pragma mark - Actions

- (IBAction)selectItem:(UIButton *)sender
{
    // button的tag对应tabBarController的selectedIndex
    // 设置选中button的样式
    ;
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
    // 先把上次选择的item设置为可用
    UIButton *lastItem = _items[_selectIndex];
    lastItem.enabled = YES;
//    lastItem.selected = NO;
    // 再把这次选择的item设置为不可用
    UIButton *item = _items[selectIndex];
    item.enabled = NO;
//    item.selected = YES;
    _selectIndex = selectIndex;
}

@end

