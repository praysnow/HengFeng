//
//  HFStudentModel.m
//  HF_Client_iPhone_Application
//
//  Created by 陈炳桦 on 2017/12/21.
//  Copyright © 2017年 HengFeng. All rights reserved.
//

#import "HFStudentModel.h"

@interface HFStudentModel() <NSXMLParserDelegate>

@property (strong, nonatomic)NSString *currentElementName;
@property (strong, nonatomic)NSMutableArray<HFStudentModel *> *studentArray;

@end

@implementation HFStudentModel

- (NSMutableArray<HFStudentModel *> *)studentArray{
    if (_studentArray == nil) {
        _studentArray = [NSMutableArray array];
    }
    return _studentArray;
}

- (NSMutableArray<HFStudentModel *> *)getStudentGroup:(NSXMLParser *)xmlParser{
    
    [xmlParser setDelegate:self];
    [xmlParser parse];
    
    return self.studentArray;
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
        [_currentElementName isEqualToString:@"PeopleGroupNum"]
        ) {
        
        [stu setValue:string forKey:_currentElementName];
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
