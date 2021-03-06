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
#import "WebServiceModel.h"
#import "HFCountTimeView.h"
#import "CBAlertWindow.h"
#import "HFCacheObject.h"
#import "HFWebViewController.h"

@interface HFClassTestDetailViewController () <NSXMLParserDelegate, UITableViewDelegate, UITableViewDataSource, HFCountTimeViewDelegate>

@property (nonatomic, copy) NSString *currentElementName;
@property (nonatomic, strong) NSMutableArray <HFClassTestObject *> *dataArray;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel; // 时间标签

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *sentButton; // 下发
@property (weak, nonatomic) IBOutlet UIButton *recommendButton; // 互评
@property (weak, nonatomic) IBOutlet UIButton *showResult;  // 查看结果
@property (weak, nonatomic) IBOutlet UIButton *stopButton;  // 停止
@property (nonatomic, strong) NSString *nameId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, copy) NSMutableString *mutableString;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) HFCountTimeView *configueView;

@property (nonatomic, assign) NSInteger secondsCountDown;
@property (nonatomic, assign) NSTimer *countDownTimer;

@end

@implementation HFClassTestDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"课堂测验";
    
    self.dataArray = [NSMutableArray array];
    [self.tableView registerNib: [UINib nibWithNibName: NSStringFromClass([HFClassTestDetailCell class]) bundle: nil] forCellReuseIdentifier: @"cell"];
    if ([HFNetwork network].serverType == ServerTypeBeiJing) {
        [self loadData];
    } else {
        [self gz_loadData];
    }
    
    self.timeLabel.hidden = YES;
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    
    // 停止下发
    [[HFSocketService sharedInstance] sendCtrolMessage: @[DAOXUEAN_DETAIL_SEND_STOP]];
    
}

- (void)gz_loadData
{
    WebServiceModel *model = [WebServiceModel new];
    model.method = @"GetClassExamByTpID";
    NSString *url = nil;
    if ([HFCacheObject shardence].courseId.length > 0) {
         model.params = @{@"arg0":[HFCacheObject shardence].courseId}.mutableCopy;
    }
    url = [NSString stringWithFormat: @"%@%@",[HFNetwork network].ServerAddress, [HFNetwork network].WebServicePath];
    [[HFNetwork network] SOAPDataWithUrl: url soapBody: [model getRequestParams]  success:^(id responseObject) {
        [responseObject setDelegate:self];
        [responseObject parse];
    } failure:^(NSError *error) {
    }];
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
    self.name = self.dataArray[indexPath.row].Name;
    self.selectedIndex = indexPath.row;
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
    NSLog(@"请求回来的数据: %@\n", elementName);
    self.currentElementName = elementName;
    if ([elementName isEqualToString: @"Table1"]) {
        HFClassTestObject *object = [[HFClassTestObject alloc] init];
            [self.dataArray addObject: object];
    }
}

// 获取节点的值 (这个方法在获取到节点头和节点尾后，会分别调用一次)
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([_currentElementName isEqualToString: @"Table1"]) {
            HFClassTestObject *stu = [self.dataArray lastObject];
            [stu setValue: string forKey: _currentElementName];
        }
    if ([_currentElementName isEqualToString: @"return"]) {
        [self.mutableString appendString: string];
    }
}

// 获取节点尾
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([_currentElementName isEqualToString: @"return"]) {
        NSArray *array = [HFUtils jsonStringToObject: self.mutableString];
        if (array.count > 0) {
            for (NSDictionary *dictionary in array) {
                HFClassTestObject *stu = [HFClassTestObject new];
                stu.Name = [dictionary objectForKey: @"fileName"];
                stu.fileUrl = [dictionary objectForKey: @"fileUrl"];
                stu.ID = [dictionary objectForKey: @"id"];
                [self.dataArray addObject: stu];
            }
        }
    }
    _currentElementName = nil;
}

// 结束
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"结束时为: %@", self.mutableString);
    [self.tableView reloadData];
    NSLog(@"结束是数量为：%zi", self.dataArray.count);
}

- (IBAction)sentMsgButton:(UIButton *)sender
{
    if ([self isSelectedObject])
    {
//        [[HFSocketService sharedInstance] sendCtrolMessage: @[DAOXUEAN_DETAIL_TIME, self.nameId]];
            
//            HFClassTestObject *object = self.dataArray[self.selectedIndex];
                HFCountTimeView *configueView = [[NSBundle mainBundle] loadNibNamed: NSStringFromClass(HFCountTimeView.class) owner: nil options: nil].lastObject;
                configueView.delegate = self;
                self.configueView = configueView;
                configueView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                configueView.layer.masksToBounds = YES;
                [CBAlertWindow jz_showView: configueView animateType: CBShowAnimateTypeCenter];
    } else {
        [HF_MBPregress showMessag: @"请先选择一个资源"];
    }
}

- (void)limitTimeSend:(NSString *)count
{
    NSLog(@"计时下发");
    self.titleLabel.text = @"正在进行课堂测验...";
    
//    NSString *string = [NSString stringWithFormat: @"%@&%@&%@&%@&%@", [HFCacheObject shardence].courseId, self.nameId, @(self.selectedIndex), @([count integerValue] * 60), self.name];
//    [[HFSocketService sharedInstance] sendCtrolMessage: @[SEND_DOWN_TIME, @"0", @"", string, @"3"]];
    
    [[HFSocketService sharedInstance] sendCtrolMessage: @[SEND_DOWN_TIME, @(self.selectedIndex),@([count integerValue] * 60)]];
    [CBAlertWindow jz_hide];
    
    // 倒计时控件
    _secondsCountDown = [count integerValue] * 60 + 1;//倒计时秒数
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法 countDownAction
    //设置倒计时显示的时间
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",_secondsCountDown/3600];//时
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(_secondsCountDown%3600)/60];//分
    NSString *str_second = [NSString stringWithFormat:@"%02ld",_secondsCountDown%60];//秒
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    NSLog(@"time:%@",format_time);
}

// 倒计时
-(void) countDownAction{
    //倒计时-1
    _secondsCountDown--;
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",_secondsCountDown/3600];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(_secondsCountDown%3600)/60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",_secondsCountDown%60];
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    //修改倒计时标签现实内容
    self.timeLabel.text=[NSString stringWithFormat:@"%@",format_time];
    self.timeLabel.hidden = NO;
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(_secondsCountDown==0){
        [_countDownTimer invalidate];
    }
}

-(void)unlimitTimeSend:(NSString *)countxr
{
    NSLog(@"不计时下发");
    self.titleLabel.text = @"正在进行课堂测验...";
    
//    NSString *string = [NSString stringWithFormat: @"%@&%@&%@&%@&%@", [HFCacheObject shardence].courseId, self.nameId, @(self.selectedIndex), @(0), self.name];
//    [[HFSocketService sharedInstance] sendCtrolMessage: @[SEND_DOWN_UNTIME, @"0", @"", string, @"3"]];
    
    [[HFSocketService sharedInstance] sendCtrolMessage: @[SEND_DOWN_UNTIME, @(self.selectedIndex), @"0"]];
    [CBAlertWindow jz_hide];
}

- (IBAction)recommentMsgButton:(UIButton *)sender
{
    NSLog(@"互评");
    if ([self isSelectedObject])
    {
        [[HFSocketService sharedInstance] sendCtrolMessage: @[CLASS_TEST_RECOMMEND_ESCH]];
    }
}

- (IBAction)showRusultButton:(UIButton *)sender
{
    NSLog(@"查看结果");
    if ([self isSelectedObject])
    {
        [[HFSocketService sharedInstance] sendCtrolMessage: @[CLASS_TEST_SHOW_RESULT]];
            HFWebViewController *webView = [[HFWebViewController alloc] init];
             NSString *url = self.dataArray[self.selectedIndex].fileUrl;
            webView.url = [NSString stringWithFormat: @"%@", url];
            [self.navigationController pushViewController: webView animated: YES];
    }
}

- (IBAction)stopSentButton:(UIButton *)sender
{
    NSLog(@"停止");
    self.titleLabel.text = @"测验未开始...";
    
    self.timeLabel.hidden = YES;
    
    if(_countDownTimer != nil){ // 计时器暂停
        [_countDownTimer invalidate];
    }
    
    
    if ([self isSelectedObject])
    {
        [[HFSocketService sharedInstance] sendCtrolMessage: @[CLASS_TEST_END]];
    }
}

- (BOOL)isSelectedObject
{
    return self.nameId.length != 0;
}

- (NSMutableString *)mutableString
{
    if (!_mutableString) {
        _mutableString = [NSMutableString string];
    }
    return _mutableString;
}

@end
