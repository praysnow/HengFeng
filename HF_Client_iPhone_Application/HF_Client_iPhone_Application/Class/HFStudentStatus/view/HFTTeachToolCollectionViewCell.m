//
//  HFTTeachToolCollectionViewCell.m
//  HF_Client_iPhone_Application
//
//  Created by liuyang on 2017/11/16.
//  Copyright © 2017年 HengFeng. All rights reserved.
//

#import "HFTTeachToolCollectionViewCell.h"

@interface HFTTeachToolCollectionViewCell()
//@property (nonatomic,strong) NSString *userRealName;
//@property (nonatomic,strong) NSString *userLoginName;

@property (weak, nonatomic) IBOutlet UILabel *userRealNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLoginNameLabel;

@end

@implementation HFTTeachToolCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.borderColor = [UIColor grayColor].CGColor;
    self.contentView.layer.borderWidth = 0.5;
    self.contentView.layer.cornerRadius = 2;
}

- (void)setSelected:(BOOL)selected{
    if (selected) {
        self.contentView.layer.borderColor = MainColor.CGColor; 
        _userRealNameLabel.textColor = MainColor;
        _userLoginNameLabel.textColor = MainColor;
    }else{
        self.contentView.layer.borderColor = [UIColor grayColor].CGColor;
        _userRealNameLabel.textColor = [UIColor grayColor];
        _userLoginNameLabel.textColor = [UIColor grayColor];
    }
    
}

- (void)setStudentModel:(HFStudentModel *)studentModel{
    _studentModel = studentModel;
    
    _userRealNameLabel.text = studentModel.userRealName;
    _userLoginNameLabel.text = studentModel.userLoginName;
}

@end
