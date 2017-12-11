//
//  HFTTeachToolCollectionViewCell.m
//  HF_Client_iPhone_Application
//
//  Created by liuyang on 2017/11/16.
//  Copyright © 2017年 HengFeng. All rights reserved.
//

#import "HFTTeachToolCollectionViewCell.h"

@implementation HFTTeachToolCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.borderColor = [UIColor grayColor].CGColor;
    self.contentView.layer.borderWidth = 0.5;
    self.contentView.layer.cornerRadius = 2;
}

@end
