//
//  HFVoteTableViewCell.h
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 07/02/2018.
//  Copyright © 2018 HengFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFVoteObject.h"

@interface HFVoteTableViewCell : UITableViewCell

//@property (nonatomic, copy) NSString *optionTitle;
//@property (nonatomic, assign) NSInteger rateCount;
@property (weak, nonatomic) IBOutlet UILabel *rateCount;
@property (weak, nonatomic) IBOutlet UILabel *optionTitle;
@property (strong, nonatomic) HFVoteObject *object;

@end
