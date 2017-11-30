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

@interface HFSocketService ()<GCDAsyncSocketDelegate>

@property (strong, nonatomic)GCDAsyncSocket *socket;

@end

@implementation HFSocketService


+ (HFSocketService *)sharedInstance
{
    
    static HFSocketService *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[self alloc] init];
        [sharedInstace setUpSocketWithHost: @"192.178.15.29" andPort: 1001];;
        [sharedInstace sendLoginInfo];
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
        [self sendInfoIsHeader: YES andLength: 1 andBody: 0];
    }else{
        NSLog(@"socket 没有连接");
    }
    [self.socket readDataWithTimeout:-1 tag:0];//WithTimeout 是超时时间,-1表示一直读取数据
}

- (void)sendInfoIsHeader:(BOOL)header andLength: (int)length andBody:(Byte)body
{
    Byte type;
    if (header) {
        type = NORMOR_INFO_FIRST_BYTE;
    } else {
        type = HEADER_INFO_FIRST_BYTE;
    }
    int steamId = (int)1;
    if (header) {
        body = HEADER_INFO_FIRST_BYTE;
    }
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
    NSString* aStr = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"iOS 接收命令:%zd  %@",data.length,aStr);
}

- (void)sendLoginInfo
{
    //     NSString *loginStatus = @"Login?name=TeacherCtrl&os=android&class=defaultEx";
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
    NSLog(@"发送登录状态");
    [self.socket writeData: mutableData withTimeout: -1 tag: 0];
}

// 断开连接
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    BOOL state = [_socket isConnected];   // 判断当前socket的连接状态
    NSLog(@"连接状态: %d",state);
    self.socket=nil;
}

@end
