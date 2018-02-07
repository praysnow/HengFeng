//
//  HFVoteTableViewCell.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 07/02/2018.
//  Copyright © 2018 HengFeng. All rights reserved.
//

#import "HFVoteTableViewCell.h"

@implementation HFVoteTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setObject:(HFVoteObject *)object
{
    _object = object;
    self.optionTitle.text = _object.title;
    if (object.count != 0) {
        self.rateCount.text = [NSString stringWithFormat: @"%zi", object.count];
        UIView *view = [UIView new];
        view.backgroundColor = UICOLOR_RGB(0xff80c1b2);
        view.frame = CGRectMake(0, 0, object.count * 10, self.rateCount.height);
        [self.rateCount addSubview: view];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
