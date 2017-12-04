//
//  HFSocketService.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 30/11/2017.
//  Copyright © 2017 HengFeng. All rights reserved.
//

#import "HFSocketService.h"
#import "WebServiceModel.h"

#define NORMOR_INFO_FIRST_BYTE (Byte)(0x99)
#define HEADER_INFO_FIRST_BYTE (Byte)(0x00)

//#define SOCKETS_HOST @"192.168.13.26"
#define SOCKETS_HOST @"192.168.15.29"
//#define SOCKETS_HOST @"192.168.10.12"

@interface HFSocketService ()<GCDAsyncSocketDelegate>

@property (strong, nonatomic)GCDAsyncSocket *socket;
@property (strong, nonatomic)NSTimer *timer;

@end

@implementation HFSocketService


+ (HFSocketService *)sharedInstance
{
    
    static HFSocketService *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[self alloc] init];
        [sharedInstace setUpSocketWithHost: SOCKETS_HOST andPort: 1001];
    });
    
    return sharedInstace;
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
        int t = [_socket connectToHost:hostIP onPort:hostPort error:&err];
        if (!t) {
            return 0;
        }else{
            return 1;
        }
    }else {
        [_socket readDataWithTimeout:-1 tag:0];
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
                [self sendTeacherCtrolMessage];
//                self.timer = [NSTimer scheduledTimerWithTimeInterval: 10 repeats: YES block:^(NSTimer * _Nonnull timer) {
//                                    [self sendTeacherCtrolMessage];
//                                }];
            } else {
            }
        });
    }else{
        NSLog(@"socket 没有连接");
    }
    [self.socket readDataWithTimeout:-1 tag:0];//WithTimeout 是超时时间,-1表示一直读取数据
}

- (void)sendTeacherCtrolMessage
{
    NSString *loginStatus = @"<?xml version=\"1.0\" encoding=\"utf-16\"?>\
    <XmlPkHeader xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" From=\"TeacherCtrl\" To=\"=\" CommandCode=\"CtrlCmd\" Channel=\"\" PKID=\"e1963ff6-0c5e-4ad1-a523-4b9dadf50b19\" />{7A76F682-6058-4EBC-A5AF-013A4369EE0E}111";
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
    NSLog(@"发送111指令");
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

// 读取数据
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString* receviedMessage = (NSString *)[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    NSLog(@"iOS 接收命令:%zd  %@",data.length,receviedMessage);
    if ([receviedMessage containsString: @"SendTeacherInfo"]) {
        [self teacherInfo: receviedMessage];
    }
    //    Byte *testByte = (Byte *)[data bytes];
    //    Byte lengthByte[] = {};
    //    for(int i=0;i<[data length];i++)
    //    {
    //    }
    //    if (testByte[0] != 153) {
    //        for(int i = 1;i < 5;i++){
    //            lengthByte[i-1] = (Byte)testByte[i];
    //        }
    //        NSLog(@"\n不是心跳：\n");
    //        printf("testByte = %d ", [self lBytesToInt: lengthByte]);
    //    } else {
    //        NSLog(@"\n是心跳包\n");
    //    }
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
    NSLog(@"信息表现为: \nourseId=%@ \nsubjectId=%@ \nclassId=%@",  [HFCacheObject shardence].courseId,  [HFCacheObject shardence].subjectId,  [HFCacheObject shardence].classId);
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

// 断开连接
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    BOOL state = [_socket isConnected];   // 判断当前socket的连接状态
    NSLog(@"连接状态: %d",state);
    self.socket = nil;
    [[HFSocketService sharedInstance] setUpSocketWithHost: SOCKETS_HOST andPort: 1001];
}

@end
