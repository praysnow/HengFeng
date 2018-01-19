//
//  HFSocketService.h
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 30/11/2017.
//  Copyright © 2017 HengFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

enum{
    SocketOfflineByServer, // 服务器断开
    SocketOfflineByUser,   // 用户断开
};

@interface HFSocketService : NSObject

@property (copy ,nonatomic) NSString *socket_host;
@property (copy ,nonatomic) NSString *service_host;
@property (nonatomic, assign) BOOL  isSocketed;
@property (strong, nonatomic)GCDAsyncSocket *socket;

+ (HFSocketService *)sharedInstance;

// 断开的情况
@property (nonatomic, assign) NSInteger userData;

//发送Socket命令
- (void)sendCtrolMessage:(NSArray *)array;

// socket连接
-(void)socketConnectHost;
// socket断开连接
-(void)cutOffSocket;

@end
