//
//  HFMYResourCeDetailTableViewCell.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 18/12/2017.
//  Copyright © 2017 HengFeng. All rights reserved.
//

#import "HFMYResourCeDetailTableViewCell.h"

@implementation HFMYResourCeDetailTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setDictionary:(NSDictionary *)dictionary
{
    _dictionary = dictionary;
    self.textLabel.text = [dictionary objectForKey: @"DxaZj_Title"];
}

@end
