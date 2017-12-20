//
//  HFMySourcesDetailViewController.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 14/12/2017.
//  Copyright © 2017 HengFeng. All rights reserved.
//

#import "HFMySourcesDetailViewController.h"
#import "HFNetwork.h"
#import "HFMYResourCeDetailTableViewCell.h"
#import "HFDaoxueDetailObject.h"
#import "HFWebViewController.h"

@interface HFMySourcesDetailViewController () <NSXMLParserDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSString *currentElementName;
@property (nonatomic, strong) NSMutableString *mutableString;
@property (nonatomic, strong) NSDictionary *Total;
@property (nonatomic, strong) NSArray *listData;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) HFMYResourCeDetailTableViewCell *cell;
@property (weak, nonatomic) IBOutlet UIButton *getAwayButton;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation HFMySourcesDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabel.text = _object.type ? _object.resName : _object.Dxa_Name;
    self.navigationItem.title = @"我的资源-导学案";
    self.mutableString = [[NSMutableString alloc] init];
    [self.tableView registerNib: [UINib nibWithNibName: NSStringFromClass([HFMYResourCeDetailTableViewCell class]) bundle: nil] forCellReuseIdentifier: @"Cell"];
     self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self showBackButton];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    self.tabBarController.tabBar.hidden = NO;
}

- (void)loadData
{
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

#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HFMYResourCeDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Cell"];
    cell.dictionary = self.listData[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    self.selectedIndex = indexPath.row;
    NSLog(@"单击");
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
        self.Total = [dictionary objectForKey: @"Total"];
        self.listData = [dictionary objectForKey: @"listData"];
          [self.tableView reloadData];
//        NSLog(@"解析数据为: %@ \n 总数量为： %@\n 数组和为: %zi", dictionary, self.Total, self.listData.count);
       }
    }
}

- (IBAction)sendAway:(UIButton *)sender
{
    if (self.listData.count > self.selectedIndex) {

        NSLog(@"下发导学案");
        [[HFSocketService sharedInstance] sendCtrolMessage: @[DAOXUEAN_DETAIL_UNTIME, @(self.selectedIndex), @"", @"", @"1"]];
    }
}

//查看详情
- (IBAction)startingResource:(UIButton *)sender
{
    if (self.listData.count < self.selectedIndex) return;
    HFWebViewController *webView = [[HFWebViewController alloc] init];
    NSDictionary *dictioanry = self.listData[self.selectedIndex];
    webView.url = [NSString stringWithFormat: @"%@%@", HOST, [dictioanry objectForKey: @"showUrl"]];
    [self.navigationController pushViewController: webView animated: YES];
}

@end
