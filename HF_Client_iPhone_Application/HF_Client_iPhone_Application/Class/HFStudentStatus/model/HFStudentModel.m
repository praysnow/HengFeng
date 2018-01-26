//
//  HFStudentModel.m
//  HF_Client_iPhone_Application
//
//  Created by 陈炳桦 on 2017/12/21.
//  Copyright © 2017年 HengFeng. All rights reserved.
//

#import "HFStudentModel.h"
#import "MJExtension.h"

@interface HFStudentModel() <NSXMLParserDelegate>

@property (strong, nonatomic)NSString *currentElementName;
@property (strong, nonatomic)NSMutableArray<HFStudentModel *> *studentArray;

@end

@implementation HFStudentModel

#pragma mark - realm数据库相关
// 指定主键
+ (NSString *)primaryKey {
    return @"userID";
}

// 指定忽略的属性
+ (NSArray *)ignoredProperties {
    return @[@"currentElementName",@"studentArray"];
}

// 指定默认属性
+ (NSDictionary *)defaultPropertyValues {
    return @{@"point" : @0};
}

#pragma mark - MJExtension相关
// MJMJExtension的模型中的属性名和字典中的key不相同
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"userID" : @"id",
             @"userRealName" : @[@"truename",@"userRealName"],
             @"PeopleGroupNum" : @"peopleGroupNum",
             @"PeopleGroupID" : @"peopleGroupUserID",
             };
}

//@property (nonatomic,strong) NSString *PeopleGroupNum;
//@property (nonatomic,strong) NSString *PeopleGroupID;

- (NSMutableArray<HFStudentModel *> *)studentArray{
    if (_studentArray == nil) {
        _studentArray = [NSMutableArray array];
    }
    return _studentArray;
}

- (NSMutableArray<HFStudentModel *> *)getStudentGroup:(NSXMLParser *)xmlParser{
    

    
    
    if ([HFNetwork network].serverType == ServerTypeBeiJing) { // 北京
        [xmlParser setDelegate:self];
        [xmlParser parse];
        
        return self.studentArray;
    }else{  // 广州
        
        // 先提取json中的字符串
        NSString *string = [[HFNetwork network] stringInNSXMLParser:xmlParser];
        // json字符串转模型数组
        NSMutableArray *array = [HFStudentModel mj_objectArrayWithKeyValuesArray:string];
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
        HFStudentModel *stu = [HFStudentModel new];
        [self.studentArray addObject:stu];
        
    }
    
}

// 获取节点的值 (这个方法在获取到节点头和节点尾后，会分别调用一次)
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    HFStudentModel *stu = [self.studentArray lastObject];
    
//    @property (nonatomic,strong) NSString *userID;
//    @property (nonatomic,strong) NSString *userRealName;
//    @property (nonatomic,strong) NSString *userLoginName;
//    @property (nonatomic,strong) NSString *PeopleGroupNum;
    if ([_currentElementName isEqualToString:@"userID"] ||
        [_currentElementName isEqualToString:@"userRealName"] ||
        [_currentElementName isEqualToString:@"userLoginName"] ||
        [_currentElementName isEqualToString:@"PeopleGroupNum"] ||
        [_currentElementName isEqualToString:@"PeopleGroupID"]
        
        ) {
        
        [stu setValue:string forKey:_currentElementName];
    }
    
    // PeopleGroupUserID
    if ([_currentElementName isEqualToString:@"PeopleGroupUserID"]) {
         [stu setValue:string forKey:@"userID"];
    }
    
}

// 获取节点尾
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    _currentElementName = nil;
}

// 结束
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"结束");
    
    NSLog(@"HFStudentModel解析结果： %@",self.studentArray);
    
}

@end
