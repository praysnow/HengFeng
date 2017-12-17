//
//  HFMySourcesDetailViewController.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 14/12/2017.
//  Copyright © 2017 HengFeng. All rights reserved.
//

#import "HFMySourcesDetailViewController.h"
#import "HFNetwork.h"

@interface HFMySourcesDetailViewController () <NSXMLParserDelegate>

@property (nonatomic, copy) NSString *currentElementName;
@property (nonatomic, strong) NSMutableString *mutableString;
@property (nonatomic, strong) NSDictionary *Total;
@property (nonatomic, strong) NSArray *listData;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HFMySourcesDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabel.text = _object.type ? _object.resName : _object.Dxa_Name;
    self.navigationItem.title = @"我的资源-导学案";
    self.mutableString = [[NSMutableString alloc] init];
    [self showBackButton];
    [self loadData];
}

- (void)loadData
{
    //    HFCacheObject *object = [HFCacheObject shardence];
    NSString *soapString = [NSString stringWithFormat: @"<soap:Envelope   xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                            <soap:Header xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\" />\
                            <soap:Body>\
                            <getTaskList xmlns=\"http://tempuri.org/\">\
                            <dxaID>%@</dxaID>\
                            </getTaskList>\
                            </soap:Body>\
                            </soap:Envelope>", _object.Dxa_ID];
    NSString *host = [NSString stringWithFormat: @"%@%@", HOST, GETTASKLIST];
    [[HFNetwork network] xmlSOAPDataWithUrl: host soapBody: soapString success:^(id responseObject){
        [responseObject setDelegate:self];
        [responseObject parse];
        NSLog(@"我的资源请求结果成功");
    } failure:^(NSError *error) {
        NSLog(@"我的资源  请求结果失败");
        NSLog(@"loadData faild %@",error.userInfo);
    }];
}

# pragma mark - 协议方法

// 开始
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"开始");
}

// 获取节点头
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    if ([elementName isEqualToString: @"getTaskListResult"]) {
        _currentElementName = @"getTaskListResult";
    }
}

// 获取节点的值 (这个方法在获取到节点头和节点尾后，会分别调用一次)
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    [self.mutableString appendString:string];
}

-(id) stringToNSArrayOrNSDictionary
{
    NSData* data = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error]; // options:NSJSONReadingAllowFragments
    if (error != nil) return nil;
    return result;
}

// 获取节点尾
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString: @"getTaskListResult"]) {
        _currentElementName = nil;
    }
}

// 结束
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if (_currentElementName.length == 0 && self.mutableString.length != 0) {
    id jsonData = [HFUtils jsonStringToObject: self.mutableString];
    if ([jsonData isKindOfClass: [NSDictionary class]])
      {
        NSDictionary *dictionary = (NSDictionary *)jsonData;
        NSDictionary *Total = [dictionary objectForKey: @"Total"];
        NSArray *listData = [dictionary objectForKey: @"listData"];
        NSLog(@"解析数据为: %@ \n 总数量为： %@\n 数组和为: %zi", dictionary, Total, listData.count);
       }
    }
}


@end
