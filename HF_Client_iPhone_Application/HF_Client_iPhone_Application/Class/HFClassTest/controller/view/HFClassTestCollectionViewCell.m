//
//  HFClassTestCollectionViewCell.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 23/01/2018.
//  Copyright © 2018 HengFeng. All rights reserved.
//

#import "HFClassTestCollectionViewCell.h"

@implementation HFClassTestCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 6;
    self.contentView.layer.borderColor = UICOLOR_ARGB(0xffe0e0e0).CGColor;
    self.contentView.layer.borderWidth = 2.0f;
    UITapGestureRecognizer *doubleTabGesture=[[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleDoubleTap:)];
    [doubleTabGesture setNumberOfTapsRequired:2];
    [self addGestureRecognizer: doubleTabGesture];
}

- (void)handleDoubleTap: (UITapGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector: @selector(doubleClickCell:)]) {
        [self.delegate doubleClickCell: _object];
    }
}

@end
