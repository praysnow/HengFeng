//
//  HFClassTestDetailViewController.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 17/01/2018.
//  Copyright © 2018 HengFeng. All rights reserved.
//

#import "HFClassTestDetailViewController.h"
#import "HFClassTestObject.h"
#import "HFClassTestDetailCell.h"

@interface HFClassTestDetailViewController () <NSXMLParserDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSString *currentElementName;
@property (nonatomic, strong) NSMutableArray <HFClassTestObject *> *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *sentButton;
@property (weak, nonatomic) IBOutlet UIButton *recommendButton;
@property (weak, nonatomic) IBOutlet UIButton *showResult;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (nonatomic, strong) NSString *nameId;

@end

@implementation HFClassTestDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"课堂测验";
    
    self.dataArray = [NSMutableArray array];
    [self.tableView registerNib: [UINib nibWithNibName: NSStringFromClass([HFClassTestDetailCell class]) bundle: nil] forCellReuseIdentifier: @"cell"];
    [self loadData];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    self.nameId = self.dataArray[indexPath.row].ID;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HFClassTestDetailCell *cell = [tableView dequeueReusableCellWithIdentifier: @"cell"];
    cell.object = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - load data

- (void)loadData
{
    //    HFCacheObject *object = [HFCacheObject shardence];
    NSString *soapString = [NSString stringWithFormat: @"<soap:Envelope   xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                            <soap:Header xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\" />\
                            <soap:Body>\
                            <GetClassExamByTpID xmlns=\"http://tempuri.org/\">\
                            <tpID>%@</tpID>\
                            </GetClassExamByTpID>\
                            </soap:Body>\
                            </soap:Envelope>", [HFCacheObject shardence].courseId];
    [[HFNetwork network] xmlSOAPDataWithUrl: [NSString stringWithFormat: @"%@%@", HOST, CLASSID_INTERFACE] soapBody: soapString success:^(id responseObject){
        [responseObject setDelegate: self];
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
    self.currentElementName = elementName;
    NSLog(@"请求回来的数据: %@\n", elementName);
    if ([elementName isEqualToString:@"Table1"]) {
        HFClassTestObject *object = [[HFClassTestObject alloc] init];
            [self.dataArray addObject: object];
    }
}

// 获取节点的值 (这个方法在获取到节点头和节点尾后，会分别调用一次)
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
        if (_currentElementName != nil) {
            HFClassTestObject *stu = [self.dataArray lastObject];
            [stu setValue: string forKey: _currentElementName];
            NSLog(@"key= %@ value=%@", _currentElementName,string);
        }
}

// 获取节点尾
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    _currentElementName = nil;
}
- (IBAction)sentMsgButton:(UIButton *)sender
{
    if ([self isSelectedObject])
    {
        [[HFSocketService sharedInstance] sendCtrolMessage: @[DAOXUEAN_DETAIL_TIME, self.nameId]];
    }
}

- (IBAction)recommentMsgButton:(UIButton *)sender
{
    if ([self isSelectedObject])
    {
        [[HFSocketService sharedInstance] sendCtrolMessage: @[DAOXUEAN_DETAIL_TIME, self.nameId]];
    }
}

- (IBAction)showRusultButton:(UIButton *)sender
{
    if ([self isSelectedObject])
    {
        [[HFSocketService sharedInstance] sendCtrolMessage: @[DAOXUEAN_DETAIL_TIME, self.nameId]];
    }
}

- (IBAction)stopSentButton:(UIButton *)sender
{
    if ([self isSelectedObject])
    {
        [[HFSocketService sharedInstance] sendCtrolMessage: @[DAOXUEAN_DETAIL_TIME, self.nameId]];
    }
}

- (BOOL)isSelectedObject
{
    return self.nameId.length != 0;
}


// 结束
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self.tableView reloadData];
    NSLog(@"结束是数量为：%zi", self.dataArray.count);
}

@end
