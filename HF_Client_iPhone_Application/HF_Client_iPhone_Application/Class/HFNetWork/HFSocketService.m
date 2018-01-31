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

@interface HFSocketService ()<GCDAsyncSocketDelegate>

@property (strong, nonatomic)NSTimer *timer;



@end

@implementation HFSocketService


+ (HFSocketService *)sharedInstance
{
    static HFSocketService *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[self alloc] init];

    });
    return sharedInstace;
}

// socket连接
-(void)socketConnectHost{
    // 1.创建socket并指定代理对象为self,代理队列必须为主队列.
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    // 2.连接指定主机的对应端口.
    NSError *error = nil;
    [self.socket connectToHost:[HFNetwork network].SocketAddress onPort:1001 error:&error];
    [self.socket readDataWithTimeout:-1 tag:0];
}

// 连接成功
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    BOOL state = [self.socket isConnected];
    if (state) {
        NSLog(@"socket 已连接");
        
        [self sendLoginInfo];
        [self sendCheckStatus];
        
        // 开启定时器
        self.timer = [NSTimer scheduledTimerWithTimeInterval: 10 repeats: YES block:^(NSTimer * _Nonnull timer) {
            [self headSocketInfoSent];
        }];
        [self sendCtrolMessage: @[@"111"]];
        
    }else{
        NSLog(@"socket 没有连接");
    }
    [self.socket readDataWithTimeout:-1 tag:0];//WithTimeout 是超时时间,-1表示一直读取数据
    
    self.isSocketed = state;
    [[NSNotificationCenter defaultCenter] postNotificationName: @"isShowCoverImage" object: nil];
    
    
    
}


// 断开连接
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    BOOL state = [sock isConnected];   // 判断当前socket的连接状态
    self.isSocketed = state;
    
    // 停掉定时器
    if ([self.timer isValid]) {
        [self.timer  invalidate];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"isShowCoverImage" object: nil];
    if (self.userData == SocketOfflineByServer) {
        // 服务器掉线，重连
//        NSLog(@"5秒重连");
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self socketConnectHost];
//        });
        [self socketConnectHost];
        
    }else if (self.userData == SocketOfflineByUser) {
        // 如果由用户断开，不进行重连
        return;
    }
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
    <XmlPkHeader xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"  From=\"TeacherCtrl\" CommandCode=\"CtrlCmd\" Channel=\"\" PKID=\"92cff518-503a-45c2-9b51-884e34d6c70c\" />";
    // 92cff518-503a-45c2-9b51-884e34d6c70c
    // e1963ff6-0c5e-4ad1-a523-4b9dadf50b19
    NSMutableString *string = [NSMutableString stringWithString: loginStatus];
    for (NSString *key in array) {
        NSLog(@"key: %@",key);
        [string appendString: [NSString stringWithFormat: @"%@%@", @"{7A76F682-6058-4EBC-A5AF-013A4369EE0E}", key]];
    }
    
    NSLog(@"发送socket命令   %@",string);
    
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
    NSLog(@"iOS 接收UTF-8命令: %@", receviedMessage);
    NSLog(@"iOS 接收ASII命令: %@", receviedAsiiMessage);
//    char* a=[data bytes];
//    NSString * string = [NSString stringWithUTF8String::@"a];
    if ([receviedAsiiMessage containsString: @"SendTeacherInfo"]) {
        [self teacherInfo: receviedAsiiMessage];
    }
    if ([receviedAsiiMessage containsString: @"PadViewImage?folder="]) {
        [self reveviedPadViewImageView];
    }
    if ([receviedAsiiMessage containsString: @"ForceCloseScreenTest"]) {
        [self reveviedForceCloseScreenTest];
    }
    
    if ([receviedAsiiMessage containsString: @"CommitViewImage="]) {
        [self reveviedCommitViewImage:receviedAsiiMessage];
    }
    if ([receviedMessage containsString: @"teacher="]) {
        [self reveviedTeaclerName: receviedMessage];
    }
    if ([receviedMessage containsString: @"SendTeacherInfo"]) {
        [self teacherInfo: receviedMessage];
    }
        if ([receviedAsiiMessage containsString: @"}43{"]) {
            [self revieveCaptureImageUrl: receviedAsiiMessage];
        }
    //接收班级姓名
    if ([receviedMessage containsString: @"<ClassName>"]) {
        [self receviedClassName: receviedMessage];
    }
    //接收主机状态
    if ([receviedAsiiMessage containsString: @"CommandCode="]) {
        [self responseXmlStatsWith: receviedAsiiMessage];
    }
    
    if ([receviedAsiiMessage containsString: @"LockScreen"]) {
        [self responseXmlStatsWith: receviedAsiiMessage];
    }
    if ([receviedAsiiMessage containsString: @"CommandCode=\"EndBrocastDesktop"] || [receviedAsiiMessage containsString: @"CommandCode=\"BrocastDesktop"]) {
//        BOOL change = [HFCacheObject shardence].BrocastDesktop;
        if ([receviedAsiiMessage containsString: @"BrocastDesktop"] && ![receviedAsiiMessage containsString: @"EndBrocastDesktop"]) {
            [HFCacheObject shardence].BrocastDesktop = YES;
            NSLog(@"屏幕广播开始");
        } else if ([receviedAsiiMessage containsString: @"EndBrocastDesktop"]){
            [HFCacheObject shardence].BrocastDesktop = NO;
            NSLog(@"屏幕广播没有开始");
        }
        [[NSNotificationCenter defaultCenter] postNotificationName: CHANGE_TEACHER_STATUS object: nil];
    }
    if ([receviedAsiiMessage containsString: @"CommandCode=\"BeginRacing"] || [receviedAsiiMessage containsString: @"CommandCode=\"EndRacing"]) {
        //        BOOL change = [HFCacheObject shardence].BrocastDesktop;
        if ([receviedAsiiMessage containsString: @"BeginRacing"]) {
            [HFCacheObject shardence].Racing = YES;
            NSLog(@"开始抢答");
        } else if ([receviedAsiiMessage containsString: @"EndRacing"]){
            [HFCacheObject shardence].Racing = NO;
            NSLog(@"停止抢答");
        }
        [[NSNotificationCenter defaultCenter] postNotificationName: CHANGE_TEACHER_STATUS object: nil];
    }
    
     if ([receviedMessage containsString: @"XmlServerState"]) {
        [self responseXmlStatsWith: receviedMessage];
    }
//    else if ([receviedMessage containsString: @"SendToCtrl"]) {
//        NSLog(@"截屏图片");
//        [self image: receviedMessage];
//    }
}

- (void)image:(NSString *)receviedMessage{
    
}

- (void)lockScreen
{
    NSLog(@"\n锁定屏幕中...");
}

- (void)reveviedForceCloseScreenTest
{
    [[NSNotificationCenter defaultCenter] postNotificationName: @"reveviedForceCloseScreenTest" object: nil];
}

- (void)reveviedTeaclerName:(NSString *)string
{
    NSRange range = [string rangeOfString:@"teacher="];
    [HFCacheObject shardence].teachName = [[string substringFromIndex: range.location] stringByReplacingOccurrencesOfString: @"teacher=" withString: @""];
}

- (void)reveviedPadViewImageView
{
    [[NSNotificationCenter defaultCenter] postNotificationName: @"reveviedPadViewImageView" object: nil];
}

//接收学生测评提交通知
- (void)reveviedCommitViewImage:(NSString *)string
{
    [HFCacheObject sendArrayWithString: string];
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

- (void)receviedClassName:(NSString *)string
{
    [HFCacheObject shardence].className = [HFUtils regulexFromString: string andStartString: @"<ClassName>" andEndString: @"</ClassName>"];
}

- (void)responseXmlStatsWith:(NSString *)data
{
    [HFCacheObject shardence].handUpUsersList = [HFUtils regulexFromString: data andStartString: @"<HandUpUsersList>" andEndString: @"<HandUpUsersList />"];
    [HFCacheObject shardence].isInRacing = [HFUtils regulexFromString: data andStartString: @"<IsInRacing>" andEndString: @"</IsInRacing>"];
    [HFCacheObject shardence].isInHandup = [HFUtils regulexFromString: data andStartString: @"<IsInHandup>" andEndString: @"</IsInHandup>"];
    [HFCacheObject shardence].showParamsUrl = [HFUtils regulexFromString: data andStartString: @"<ShowParamsUrl>" andEndString: @"<ShowParamsUrl />"];
    [HFCacheObject shardence].guidedLearningInfo = [HFUtils regulexFromString: data andStartString: @"<GuidedLearningInfo>" andEndString: @"<GuidedLearningInfo />"];
//    [HFCacheObject shardence].className = [HFUtils regulexFromString: data andStartString: @"<MicroClassInfo />" andEndString: @"</ClassName>"];
    [HFCacheObject shardence].isCanQuit = [HFUtils regulexFromString: data andStartString: @"<IsCanQuit>" andEndString: @"</IsCanQuit>"];
    [HFCacheObject shardence].iosLookScreen = [HFUtils regulexFromString: data andStartString: @"<IsLookScreen>" andEndString: @"</IsLookScreen>"];
    [HFCacheObject shardence].isLockScreen = [data containsString: @"True"] ? true:false;
    [HFCacheObject shardence].voteMsg = [HFUtils regulexFromString: data andStartString: @"<VoteMsg>" andEndString: @"<VoteMsg />"];
    [[NSNotificationCenter defaultCenter] postNotificationName: CHANGE_TEACHER_STATUS object: nil];
//    NSXMLParser *xmlData = [[NSXMLParser alloc]initWithData: data];
//    xmlData.delegate = self;
//    [xmlData parse];
}

- (void)revieveCaptureImageUrl:(NSString *)imageUrl
{
        [HFCacheObject shardence].imageUrl = [HFUtils regulexFromString: imageUrl andStartString: @"root" andEndString: @"jpeg"];
}

// socket断开连接
-(void)cutOffSocket{
    
    self.userData = SocketOfflineByUser;
    
    [self.timer invalidate];
    
    [self.socket disconnect];
}


@end
