//
//  HFCountTimeView.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 20/12/2017.
//  Copyright © 2017 HengFeng. All rights reserved.
//

#import "HFCountTimeView.h"
#import "CBAlertWindow.h"

@interface HFCountTimeView ()

@property (weak, nonatomic) IBOutlet UIButton *closeBUtton;

@end

@implementation HFCountTimeView

- (IBAction)tappedAdd:(UIButton *)sender
{
   self.textField.text =  [NSString stringWithFormat: @"%zi", [self.textField.text integerValue] + 1];
}
- (IBAction)tappedReduce:(UIButton *)sender
{
    if ([self.textField.text integerValue] > 1) {
              self.textField.text =  [NSString stringWithFormat: @"%zi", [self.textField.text integerValue] - 1];
    }
}
- (IBAction)limitedTimeSend:(UIButton *)sender
{
    if ([self.delegate respondsToSelector: @selector(limitedTimeSend:)])
    {
        [self.delegate limitTimeSend: self.textField.text];
    }
}

- (IBAction)unLimitedTimeSend:(UIButton *)sender
{
    if ([self.delegate respondsToSelector: @selector(unlimitTimeSend:)])
    {
        [self.delegate unlimitTimeSend: self.textField.text];
    }
}

- (IBAction)tappedColseButton:(UIButton *)sender
{
    [CBAlertWindow jz_hide];
}


@end
