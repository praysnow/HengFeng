//
//  HFStudentGroupCollectionReusableView.h
//  HF_Client_iPhone_Application
//
//  Created by 陈炳桦 on 2018/1/7.
//  Copyright © 2018年 HengFeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFStudentGroupCollectionReusableView : UICollectionReusableView

@property(assign,nonatomic)NSInteger groupNum; // 第几组
@property(assign,nonatomic)NSInteger groupStudentNum; // 该小组人数
@end
