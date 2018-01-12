//
//  HFStudentGroupCollectionReusableView.m
//  HF_Client_iPhone_Application
//
//  Created by 陈炳桦 on 2018/1/7.
//  Copyright © 2018年 HengFeng. All rights reserved.
//

#import "HFStudentGroupCollectionReusableView.h"
#import <BlocksKit+UIKit.h>

@interface HFStudentGroupCollectionReusableView()
@property (weak, nonatomic) IBOutlet UIButton *titleButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation HFStudentGroupCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    
   
    
    self.titleButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.titleButton.layer.borderWidth = 2;
    self.titleButton.layer.cornerRadius = 5;
    self.titleButton.layer.masksToBounds = YES;
    
    self.titleButton.userInteractionEnabled = NO;

    
    [self bk_whenTapped:^{
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HFStudentGroupCollectionReusableView" object:_model.PeopleGroupNum userInfo:nil];
        
//        if (self.titleButton.layer.borderColor == [UIColor grayColor].CGColor) {
//            self.titleButton.layer.borderColor = MainColor.CGColor;
//        }else{
//            self.titleButton.layer.borderColor = [UIColor grayColor].CGColor;
//        }
    }];
}




- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSInteger num = [_model.PeopleGroupNum integerValue] + 1;
    [self.titleButton setTitle:[NSString stringWithFormat:@" 第%zd组 (小组人数：%zd人)",num,_model.studentArray.count] forState:UIControlStateNormal];
    
    if (_model.isShow) {
        self.titleButton.layer.borderColor = MainColor.CGColor;
        [self.titleButton setImage:[UIImage imageNamed:@"选中小组"] forState:UIControlStateNormal];
        [self.titleButton setTitleColor:MainColor forState:UIControlStateNormal];
        
        [self.imageView setImage:[UIImage imageNamed:@"上拉按钮"]];
    }else{
        self.titleButton.layer.borderColor = [UIColor grayColor].CGColor;
        [self.titleButton setImage:[UIImage imageNamed:@"未选中小组"] forState:UIControlStateNormal];
        [self.titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self.imageView setImage:[UIImage imageNamed:@"下拉按钮"]];
    }
    
}

@end
