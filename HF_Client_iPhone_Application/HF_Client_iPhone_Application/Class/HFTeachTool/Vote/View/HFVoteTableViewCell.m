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
    
//    UIView *view = [UIView new];
//    view.backgroundColor = UICOLOR_RGB(0xff80c1b2);
//    view.frame = CGRectMake(0, 0, 0, self.rateCount.height);
//    [self.rateCount addSubview: view];
    
    self.numberLabel.hidden = YES;
    
    self.progressView.layer.cornerRadius = 5;
    self.progressView.layer.masksToBounds = YES;
}

- (void)setObject:(HFVoteObject *)object
{
    _object = object;
    self.optionTitle.text = _object.title;
   
    
    if (object.count != 0) {
        self.numberLabel.hidden = NO;
        self.numberLabel.text = [NSString stringWithFormat: @"%zi", object.count];
        
        for(UIView *subview in [self.progressView subviews])
        {
            [subview removeFromSuperview];
        }
        
        UIView *view = [UIView new];
        view.backgroundColor = UICOLOR_RGB(0xff80c1b2);
        view.frame = CGRectMake(0, 0, object.count * 10, self.progressView.height);
        [self.progressView addSubview: view];
    }else{
        for(UIView *subview in [self.progressView subviews])
        {
            [subview removeFromSuperview];
        }
        self.numberLabel.hidden = YES;
    }
}



@end
