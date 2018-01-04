//
//  HFUserInfocellTableViewCell.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 03/01/2018.
//  Copyright © 2018 HengFeng. All rights reserved.
//

#import "HFUserInfocellTableViewCell.h"

@interface HFUserInfocellTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UILabel *detailText;

@end

@implementation HFUserInfocellTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setDictioanry:(NSDictionary *)dictioanry
{
    _dictioanry = dictioanry;
    _avatarImage.image = [UIImage imageNamed: [dictioanry objectForKey: @"image"]];
    _cellTitle.text = [dictioanry objectForKey: @"name"];
    _detailText.text = [dictioanry objectForKey: @"context"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
