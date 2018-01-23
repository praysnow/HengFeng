//
//  HFClassTestCollectionViewCell.h
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 23/01/2018.
//  Copyright © 2018 HengFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFClassTestObject.h"

@protocol HFClassTestCollectionViewCellDelegate <NSObject>

- (void)doubleClickCell:(HFClassTestObject *)object;

@end

@interface HFClassTestCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) HFClassTestObject *object;

@property (nonatomic, weak) id <HFClassTestCollectionViewCellDelegate> delegate;


@end
