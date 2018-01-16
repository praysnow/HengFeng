//
//  HFMyResourceHeaderFootView.h
//  HF_Client_iPhone_Application
//
//  Created by liuyang on 2017/11/15.
//  Copyright © 2017年 HengFeng. All rights reserved.
//

@class HFMyResourceHeaderFootView;

@protocol HFMyResourceHeaderFootViewDelegate <NSObject>

- (void)headerFooterSend;
- (void)headerFooterDownLoad;
- (void)headerFooterStop;

@end

@interface HFMyResourceHeaderFootView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) id <HFMyResourceHeaderFootViewDelegate> delegate;

@end
