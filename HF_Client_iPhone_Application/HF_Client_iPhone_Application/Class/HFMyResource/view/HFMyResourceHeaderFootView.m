//
//  HFMyResourceHeaderFootView.m
//  HF_Client_iPhone_Application
//
//  Created by liuyang on 2017/11/15.
//  Copyright © 2017年 HengFeng. All rights reserved.
//

#import "HFMyResourceHeaderFootView.h"

@implementation HFMyResourceHeaderFootView

- (IBAction)sendAway:(id)sender
{
    if ([self.delegate respondsToSelector: @selector(headerFooterSend)]) {
        [self.delegate headerFooterSend];
    }
}

- (IBAction)downLoad:(id)sender
{
    if ([self.delegate respondsToSelector: @selector(headerFooterDownLoad)]) {
        [self.delegate headerFooterDownLoad];
    }
}

@end
