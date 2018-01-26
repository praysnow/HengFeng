//
//  HFGroupModel.m
//  HF_Client_iPhone_Application
//
//  Created by 陈炳桦 on 2018/1/5.
//  Copyright © 2018年 HengFeng. All rights reserved.
//

#import "HFGroupModel.h"
#import "MJExtension.h"

@interface HFGroupModel() <NSXMLParserDelegate>

@property (strong, nonatomic)NSString *currentElementName;
@property (strong, nonatomic)NSMutableArray *groupArray;

@end

@implementation HFGroupModel


#pragma mark - MJExtension相关
// MJMJExtension的模型中的属性名和字典中的key不相同
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"PeopleGroupID" : @"peopleGroupID",
             @"PeopleGroupName" : @"peopleGroupName",
             @"PeopleGroupType" : @"peopleGroupType",
             @"PeopleGroupMode" : @"peopleGroupMode",
             @"PeopleGroupCount" : @"peopleGroupCount",
             };
}



- (NSMutableArray *)groupArray{
    if (_groupArray== nil) {
        _groupArray = [NSMutableArray array];
    }
    
    return _groupArray;
}

// 返回模型数组的方法
- (NSMutableArray<HFGroupModel *> *)getGroupModelArray:(NSXMLParser *)xmlParser{
    
    
    
    
    if ([HFNetwork network].serverType == ServerTypeBeiJing) { // 北京
        [xmlParser setDelegate:self];
        [xmlParser parse];
        
        return self.groupArray;
    }else{  // 广州
        
        // 先提取json中的字符串
        NSString *string = [[HFNetwork network] stringInNSXMLParser:xmlParser];
        // json字符串转模型数组
        NSMutableArray *array = [HFGroupModel mj_objectArrayWithKeyValuesArray:string];
        return array;
    }
    
    
}

# pragma mark - NSXMLParserDelegate
// 开始
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"开始");
}

// 获取节点头
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    self.currentElementName = elementName;
    
    
    if ([elementName isEqualToString:@"Table1"]) {
        // 创建学生模型
        HFGroupModel *group = [HFGroupModel new];
        [self.groupArray addObject:group];
        
    }
    
}

// 获取节点的值 (这个方法在获取到节点头和节点尾后，会分别调用一次)
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
     HFGroupModel *group = [self.groupArray lastObject];
    
    if ([_currentElementName isEqualToString:@"PeopleGroupID"] ||
        [_currentElementName isEqualToString:@"PeopleGroupName"] ||
        [_currentElementName isEqualToString:@"PeopleGroupType"] ||
        [_currentElementName isEqualToString:@"PeopleGroupMode"] ||
        [_currentElementName isEqualToString:@"PeopleGroupCount"] ||
        [_currentElementName isEqualToString:@"banjiname"]
        ) {
        
        [group setValue:string forKey:_currentElementName];
    }
    
}

// 获取节点尾
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    _currentElementName = nil;
}

// 结束
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"结束");
    
    NSLog(@"%@",self.groupArray);
    //    [self.collectionView reloadData];
}

@end
