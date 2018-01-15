//
//  HFPersonRankingTableViewCell.h
//  HF_Client_iPhone_Application
//
//  Created by 陈炳桦 on 2018/1/12.
//  Copyright © 2018年 HengFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFStudentModel.h"
#import "HFStudentArrayModel.h"

@interface HFPersonRankingTableViewCell : UITableViewCell

@property (strong,nonatomic) HFStudentModel *studentModel;
@property (strong,nonatomic) HFStudentArrayModel *studentArrayModel;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIImageView *numImageView;


@end
