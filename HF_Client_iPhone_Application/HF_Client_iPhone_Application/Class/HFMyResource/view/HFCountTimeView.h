//
//  HFCountTimeView.h
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 20/12/2017.
//  Copyright © 2017 HengFeng. All rights reserved.
//

@class HFCountTimeView;

@protocol HFCountTimeViewDelegate <NSObject>

- (void)limitTimeSend:(NSString *)count;
- (void)unlimitTimeSend:(NSString *)count;

@end

@interface HFCountTimeView : UIView

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) id <HFCountTimeViewDelegate> delegate;

@end
