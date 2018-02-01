//
//  HFMyResourceHeaderFootView.m
//  HF_Client_iPhone_Application
//
//  Created by liuyang on 2017/11/15.
//  Copyright © 2017年 HengFeng. All rights reserved.
//

#import "HFMyResourceHeaderFootView.h"

@interface HFMyResourceHeaderFootView ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *clickButtonArray;

@end

@implementation HFMyResourceHeaderFootView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupButtonArray];
}

- (void)setupButtonArray
{
    for (UIButton *button in self.clickButtonArray) {
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 4;
        button.layer.borderColor = UICOLOR_RGB(0xffe0e0e0).CGColor;
        button.layer.borderWidth = 1;
    }
}

- (IBAction)sendAway:(id)sender
{
    NSLog(@"停止");
    if ([self.delegate respondsToSelector: @selector(headerFooterSend)]) {
        [self.delegate headerFooterSend];
    }
}

- (IBAction)downLoad:(id)sender
{
    NSLog(@"下发");
    if ([self.delegate respondsToSelector: @selector(headerFooterDownLoad)]) {
        [self.delegate headerFooterDownLoad];
    }
}
- (IBAction)stopSendDocument:(UIButton *)sender
{
    if ([self.delegate respondsToSelector: @selector(headerFooterStop)]) {
        [self.delegate headerFooterStop];
    }
}

@end
