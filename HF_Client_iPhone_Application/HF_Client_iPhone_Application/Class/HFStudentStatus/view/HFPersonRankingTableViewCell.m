//
//  HFPersonRankingTableViewCell.m
//  HF_Client_iPhone_Application
//
//  Created by 陈炳桦 on 2018/1/12.
//  Copyright © 2018年 HengFeng. All rights reserved.
//

#import "HFPersonRankingTableViewCell.h"

@interface HFPersonRankingTableViewCell()


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;



@end

@implementation HFPersonRankingTableViewCell

- (void)setStudentModel:(HFStudentModel *)studentModel{
    _studentModel = studentModel;
    
    _nameLabel.text = [NSString stringWithFormat:@"%@ [%@]", studentModel.userRealName,studentModel.userID];
    
    _pointLabel.text = [NSString stringWithFormat:@"%zd积分",studentModel.point];
    
    _numLabel.layer.cornerRadius = _numLabel.width / 2;
    _numLabel.layer.masksToBounds = YES;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
