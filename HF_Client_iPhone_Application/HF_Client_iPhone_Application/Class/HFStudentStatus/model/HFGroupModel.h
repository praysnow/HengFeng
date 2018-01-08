//
//  HFGroupModel.h
//  HF_Client_iPhone_Application
//
//  Created by 陈炳桦 on 2018/1/5.
//  Copyright © 2018年 HengFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFGroupModel : NSObject


//<PeopleGroupID>254</PeopleGroupID>
//<PeopleGroupName>分组2</PeopleGroupName>
//<PeopleGroupType>班级分组</PeopleGroupType>
//<PeopleGroupMode>分层模式</PeopleGroupMode>
//<PeopleGroupCount>8</PeopleGroupCount>
//<banjiname>四年级(1)班</banjiname>
@property (nonatomic,strong) NSString *PeopleGroupID;
@property (nonatomic,strong) NSString *PeopleGroupName;
@property (nonatomic,strong) NSString *PeopleGroupType;
@property (nonatomic,strong) NSString *PeopleGroupMode;
@property (nonatomic,strong) NSString *PeopleGroupCount;
@property (nonatomic,strong) NSString *banjiname;

// 返回模型数组的方法
- (NSMutableArray<HFGroupModel *> *)getGroupModelArray:(NSXMLParser *)xmlParser;

@end
