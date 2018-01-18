//
//  HFSocketService.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 30/11/2017.
//  Copyright © 2017 HengFeng. All rights reserved.
//

#import "HFSocketService.h"
#import "WebServiceModel.h"
#import "HFNetwork.h"

#define NORMOR_INFO_FIRST_BYTE (Byte)(0x99)
#define HEADER_INFO_FIRST_BYTE (Byte)(0x00)

@interface HFSocketService ()<GCDAsyncSocketDelegate, NSXMLParserDelegate>

@property (strong, nonatomic)NSTimer *timer;
@property (strong, nonatomic) NSString *currentElementName;

@end

@implementation HFSocketService


+ (HFSocketService *)sharedInstance
{
    static HFSocketService *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[self alloc] init];
//        NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] valueForKey: ADDRESS_HOST];
//        if ([dictionary.allKeys containsObject: @"socket_address"]) {
//            sharedInstace.socket_host = [dictionary valueForKey: @"socket_address"];
//        }
//        if ([dictionary.allKeys containsObject: @"service_host"]) {
//            sharedInstace.service_host = [dictionary valueForKey: @"service_host"];
//        }
    });
    [sharedInstace setUpSocketWithHost: [HFNetwork network].SocketAddress andPort: 1001];
    return sharedInstace;
}

- (void)reConnetSockets
{
    [self.socket disconnect];
    [self setUpSocketWithHost: [HFNetwork network].SocketAddress andPort: 1001];
}

- (void)setUpSocketWithHost:(NSString *)host andPort:(uint16_t)prot
{
    [self connectServer: host port: prot];
}

- (int)connectServer:(NSString *)hostIP port:(int)hostPort
{
    if (_socket == nil) {
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        [_socket readDataWithTimeout: -1 tag: 0];
        NSError *err = nil;
        int t = [_socket connectToHost: hostIP onPort: hostPort withTimeout: 5 error: &err];

        if (!t) {
            return 0;
        }else{
            return 1;
        }
    }else {
        [_socket readDataWithTimeout: -1 tag:0];
        return 1;
    }
}

// 连接成功
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    BOOL state = [self.socket isConnected];
    if (state) {
        NSLog(@"socket 已连接");
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (@available(iOS 10.0, *)) {
                [self sendLoginInfo];
                [self sendCheckStatus];
                self.timer = [NSTimer scheduledTimerWithTimeInterval: 10 repeats: YES block:^(NSTimer * _Nonnull timer) {
                    [self headSocketInfoSent];
                }];
                [self sendCtrolMessage: @[@"111"]];
            } else {
            }
        });
    }else{
        NSLog(@"socket 没有连接");
    }
    [self.socket readDataWithTimeout:-1 tag:0];//WithTimeout 是超时时间,-1表示一直读取数据
}

// 断开连接
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    BOOL state = [sock isConnected];   // 判断当前socket的连接状态
    NSLog(@"连接状态: %d",state);
    if (!state) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setUpSocketWithHost: [HFNetwork network].SocketAddress andPort: 1001];
        });
        NSLog(@"增加遮罩");
    } else {
        NSLog(@"通知UI改变移除");
    }
   self.isSocketed = state;
   [[NSNotificationCenter defaultCenter] postNotificationName: @"isShowCoverImage" object: nil];
}

- (void)sendCtrolMessage:(NSArray *)array
{
    if (array.count == 0) return;
    NSMutableData *mutableData = [NSMutableData new];
    int steamId = (int)0;
    Byte type = (Byte)(0x00);
    NSData *typeData = [NSData dataWithBytes: &type length: 1];
    NSData *steamIdData = [NSData dataWithBytes:&steamId length: sizeof(steamId)];
    NSString *loginStatus = @"<?xml version=\"1.0\" encoding=\"utf-16\"?>\
    <XmlPkHeader xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" From=\"TeacherCtrl\" To=\"=\" CommandCode=\"CtrlCmd\" Channel=\"\" PKID=\"e1963ff6-0c5e-4ad1-a523-4b9dadf50b19\" />";
    NSMutableString *string = [NSMutableString stringWithString: loginStatus];
    for (NSString *key in array) {
        NSLog(@"key: %@",key);
        [string appendString: [NSString stringWithFormat: @"%@%@", @"{7A76F682-6058-4EBC-A5AF-013A4369EE0E}", key]];
    }
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    int length = (int)data.length;
    NSData *lengthData = [NSData dataWithBytes:&length length: sizeof(length)];
    [mutableData appendData: typeData];
    [mutableData appendData: lengthData];
    [mutableData appendData: steamIdData];
    [mutableData appendData: data];
    [self.socket writeData: mutableData withTimeout: -1 tag: 0];
}

- (void)sendCheckStatus
{
    NSMutableData *mutableData = [NSMutableData new];
    int steamId = (int)0;
    Byte type = (Byte)(0x00);
    NSData *typeData = [NSData dataWithBytes: &type length: 1];
    NSData *steamIdData = [NSData dataWithBytes:&steamId length: sizeof(steamId)];
    NSString *loginStatus = @"<?xml version=\"1.0\" encoding=\"utf-16\"?><XmlPkHeader xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"  To=\"=\" CommandCode=\"GetXmlState\" Channel=\"\" From=\"idCard\"/>";
    //    NSString *loginStatus = @"<?xml version=\"1.0\" encoding=\"utf-16\"?>\
    \"<XmlPkHeader xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\
    xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"To=\"=\" CommandCode=\"GetXmlState\"\
    Channel=""From=\"idCard\">";
    NSMutableString *string = [NSMutableString stringWithString: loginStatus];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    int length = (int)data.length;
    NSData *lengthData = [NSData dataWithBytes:&length length: sizeof(length)];
    [mutableData appendData: typeData];
    [mutableData appendData: lengthData];
    [mutableData appendData: steamIdData];
    [mutableData appendData: data];
    [self.socket writeData: mutableData withTimeout: -1 tag: 0];
}

- (void)headSocketInfoSent
{
    Byte type= HEADER_INFO_FIRST_BYTE;
    int steamId = (int)1;
    int length = (int)1;
    Byte body = HEADER_INFO_FIRST_BYTE;
    NSData *typeData = [NSData dataWithBytes: &type length: 1];
    NSData *lengthData = [NSData dataWithBytes:&length length: sizeof(length)];
    NSData *steamIdData = [NSData dataWithBytes:&steamId length: sizeof(steamId)];
    NSData *bodyData = [NSData dataWithBytes: &body length: length];
    NSMutableData *mutableData = [NSMutableData new];
    [mutableData appendData: typeData];
    [mutableData appendData: lengthData];
    [mutableData appendData: steamIdData];
    [mutableData appendData: bodyData];
    [self.socket writeData: mutableData withTimeout:-1 tag:0];
}

- (void)teacherSendingSocket:(Byte)body
{
    Byte type= NORMOR_INFO_FIRST_BYTE;
    int steamId = (int)1;
    int length = (int)1;
    NSData *typeData = [NSData dataWithBytes: &type length: 1];
    NSData *bodyData = [NSData dataWithBytes: &body length: length];
    NSData *lengthData = [NSData dataWithBytes:&length length: bodyData.length + 6];
    NSData *steamIdData = [NSData dataWithBytes:&steamId length: sizeof(steamId)];
    NSMutableData *mutableData = [NSMutableData new];
    [mutableData appendData: typeData];
    [mutableData appendData: lengthData];
    [mutableData appendData: steamIdData];
    [mutableData appendData: bodyData];
    [self.socket writeData: mutableData withTimeout:-1 tag:0];
}

- (Byte)transByteFormint:(int)value
{
    char *p_time = (char *)&value;
    char str_time[4] = {0};
    for(int i= 0 ;i < 4 ;i++)
    {
        str_time[i] = *p_time;
        p_time ++;
    }
    return *p_time;
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    [sock readDataWithTimeout: -1 tag: tag];
}

#pragma mark - recevied socket message

// 读取数据
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString* receviedMessage = (NSString *)[[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding]; //  NSASCIIStringEncoding
     NSString* receviedAsiiMessage = (NSString *)[[NSString alloc] initWithData:data encoding: NSASCIIStringEncoding]; //  NSASCIIStringEncoding
    NSLog(@"iOS 接收UTF-8命令:%zd  %@",data.length,receviedMessage);
    NSLog(@"iOS 接收ASII命令:%zd  %@",data.length,receviedAsiiMessage);
    if ([receviedMessage containsString: @"SendTeacherInfo"]) {
        [self teacherInfo: receviedMessage];
    }
        if ([receviedAsiiMessage containsString: @"}43{"]) {
            [self revieveCaptureImageUrl: receviedAsiiMessage];
        }
    
    if ([receviedMessage containsString: @"LockScreen"]) {
        [self lockScreen];
    } else if ([receviedMessage containsString: @"unLockScreen"])
    {
        NSLog(@"解除锁屏");
    } else if ([receviedMessage containsString: @"XmlServerState"]) {
        [self responseXmlStatsWith: receviedMessage];
    }
}

- (void)lockScreen
{
    NSLog(@"\n锁定屏幕中...");
}

- (void)teacherInfo:(NSString*)receviedMessage
{
    NSRange range = [receviedMessage rangeOfString: @"courseId"];
    NSString *message = [receviedMessage substringFromIndex: range.location];
    NSLog(@"截取出课程信息：%@", message);
    NSArray *arry=[message componentsSeparatedByString:@"&"];
    for (NSString *string in arry) {
        if ([string containsString: @"classId="] ) {
            [HFCacheObject shardence].classId = [string stringByReplacingOccurrencesOfString: @"classId=" withString: @""];
            NSLog(@"classID为:%@", [HFCacheObject shardence].classId);
        }
        if ([string containsString: @"courseId="] ) {
            [HFCacheObject shardence].courseId = [string stringByReplacingOccurrencesOfString: @"courseId=" withString: @""];
        }
        if ([string containsString: @"subjectId="] ) {
            [HFCacheObject shardence].subjectId = [string stringByReplacingOccurrencesOfString: @"subjectId=" withString: @""];
        }
    }
    NSLog(@"信息表现为: \ncourseId=%@ \nsubjectId=%@ \nclassId=%@",  [HFCacheObject shardence].courseId,  [HFCacheObject shardence].subjectId,  [HFCacheObject shardence].classId);
}

-(int)lBytesToInt:(Byte[]) byte
{
    int offset = 0;
    int     value = (int) (((byte[offset+3] & 0xFF)<<24)
                           | ((byte[offset+2] & 0xFF)<<16)
                           | ((byte[offset+1] & 0xFF)<<8)
                           | (byte[offset] & 0xFF));
    return value;
}

- (void)sendLoginInfo
{
    NSString *loginStatus = @"Login?name=TeacherCtrl&os=android&class=defaultEx";
    NSData *data = [loginStatus dataUsingEncoding:NSUTF8StringEncoding];
    int length = (int)data.length;
    int steamId = (int)0;
    Byte type = (Byte)(0x00);
    NSData *typeData = [NSData dataWithBytes: &type length: 1];
    NSData *lengthData = [NSData dataWithBytes:&length length: sizeof(length)];
    NSData *steamIdData = [NSData dataWithBytes:&steamId length: sizeof(steamId)];
    NSMutableData *mutableData = [NSMutableData new];
    [mutableData appendData: typeData];
    [mutableData appendData: lengthData];
    [mutableData appendData: steamIdData];
    [mutableData appendData: data];
    NSLog(@"发送登录状态");
    [self.socket writeData: mutableData withTimeout: -1 tag: 0];
}

- (void)responseXmlStatsWith:(NSString *)data
{
    [HFCacheObject shardence].className = [HFUtils regulexFromString: data andStartString: @"<ClassName>" andEndString: @"</ClassName>"];
    [HFCacheObject shardence].handUpUsersList = [HFUtils regulexFromString: data andStartString: @"<HandUpUsersList>" andEndString: @"<HandUpUsersList />"];
    [HFCacheObject shardence].isInRacing = [HFUtils regulexFromString: data andStartString: @"<IsInRacing>" andEndString: @"</IsInRacing>"];
    [HFCacheObject shardence].isInHandup = [HFUtils regulexFromString: data andStartString: @"<IsInHandup>" andEndString: @"</IsInHandup>"];
    [HFCacheObject shardence].showParamsUrl = [HFUtils regulexFromString: data andStartString: @"<ShowParamsUrl>" andEndString: @"<ShowParamsUrl />"];
    [HFCacheObject shardence].guidedLearningInfo = [HFUtils regulexFromString: data andStartString: @"<GuidedLearningInfo>" andEndString: @"<GuidedLearningInfo />"];
//    [HFCacheObject shardence].className = [HFUtils regulexFromString: data andStartString: @"<MicroClassInfo />" andEndString: @"</ClassName>"];
    [HFCacheObject shardence].isCanQuit = [HFUtils regulexFromString: data andStartString: @"<IsCanQuit>" andEndString: @"</IsCanQuit>"];
    [HFCacheObject shardence].iosLookScreen = [HFUtils regulexFromString: data andStartString: @"<IsLookScreen>" andEndString: @"</IsLookScreen>"];
    [HFCacheObject shardence].voteMsg = [HFUtils regulexFromString: data andStartString: @"<VoteMsg>" andEndString: @"<VoteMsg />"];
//    NSXMLParser *xmlData = [[NSXMLParser alloc]initWithData: data];
//    xmlData.delegate = self;
//    [xmlData parse];
}

- (void)revieveCaptureImageUrl:(NSString *)imageUrl
{
        [HFCacheObject shardence].imageUrl = [HFUtils regulexFromString: imageUrl andStartString: @"root" andEndString: @"jpeg"];
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
//    if ([_host containsString: DAOXUEAN_INTERFACE]) {
//        if ([elementName isEqualToString:@"Table1"]) {
//            HFDaoxueModel *stu = [[HFDaoxueModel alloc] init];
//            if (self.studentArray.count == 0) {
//                [self.allInfoArray addObject: self.studentArray];
//            }
//            [self.studentArray addObject: stu];
//        }
//    } else if ([_host containsString: DAOXUETANG_INTERFACE]) {
//        if ([elementName isEqualToString:@"Table1"]) {
//            HFDaoxueModel *stu = [[HFDaoxueModel alloc] init];
//            if (self.classArray.count == 0) {
//                [self.allInfoArray addObject: self.classArray];
//            }
//            [self.classArray addObject: stu];
//        }
//    }
}

// 获取节点的值 (这个方法在获取到节点头和节点尾后，会分别调用一次)
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
//    if ([_host containsString: DAOXUEAN_INTERFACE]) {
//        if (_currentElementName != nil) {
//            HFDaoxueModel *stu = [self.studentArray lastObject];
//            [stu setValue:string forKey:_currentElementName];
//        }
//
//    } else if ([_host containsString: DAOXUETANG_INTERFACE]) {
//        if (_currentElementName != nil) {
//            HFDaoxueModel *stu = [self.classArray lastObject];
//            [stu setValue:string forKey:_currentElementName];
//        }
//    }
}

// 获取节点尾
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    _currentElementName = nil;
}

// 结束
- (void)parserDidEndDocument:(NSXMLParser *)parser {
//    NSLog(@"结束");
//    NSLog(@"导学案%zi",self.studentArray.count);
//    NSLog(@"导学堂%zi",self.classArray.count);
//    [self.collectionView reloadData];
}

@end
