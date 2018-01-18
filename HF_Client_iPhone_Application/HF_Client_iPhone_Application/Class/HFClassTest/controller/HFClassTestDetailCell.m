//
//  HFClassTestDetailCell.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 18/01/2018.
//  Copyright © 2018 HengFeng. All rights reserved.
//

#import "HFClassTestDetailCell.h"

@implementation HFClassTestDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setObject:(HFClassTestObject *)object
{
    _object = object;
    self.textLabel.text = object.Name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
