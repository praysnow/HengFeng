//
//  HFMyResourceCollectionViewCell.h
//  HF_Client_iPhone_Application
//
//  Created by liuyang on 2017/11/15.
//  Copyright © 2017年 HengFeng. All rights reserved.
//

#import "HFDaoxueModel.h"

@protocol HFMyResourceCollectionViewCellDelegate <NSObject>

- (void)doubleClickCell:(HFDaoxueModel *)object;

@end

@interface HFMyResourceCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) HFDaoxueModel *object;

@property (nonatomic, weak) id <HFMyResourceCollectionViewCellDelegate> delegate;

@end
