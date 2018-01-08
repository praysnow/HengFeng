//
//  HFStudentGroupCollectionReusableView.m
//  HF_Client_iPhone_Application
//
//  Created by 陈炳桦 on 2018/1/7.
//  Copyright © 2018年 HengFeng. All rights reserved.
//

#import "HFStudentGroupCollectionReusableView.h"

@interface HFStudentGroupCollectionReusableView()
@property (weak, nonatomic) IBOutlet UIButton *titleButton;

@end

@implementation HFStudentGroupCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    
   
    
    self.titleButton.layer.borderColor = MainColor.CGColor;
    self.titleButton.layer.borderWidth = 2;
    self.titleButton.layer.cornerRadius = 5;
    self.titleButton.layer.masksToBounds = YES;
    
    
    [self.titleButton addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
}

- (void)click{
    NSLog(@"点击");
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSLog(@"%@",[NSString stringWithFormat:@"第%zd组 (小组人数：%zd人)",_groupNum,_groupStudentNum]);
    [self.titleButton setTitle:[NSString stringWithFormat:@"第%zd组 (小组人数：%zd人)",_groupNum,_groupStudentNum] forState:UIControlStateNormal];
    
}

@end
