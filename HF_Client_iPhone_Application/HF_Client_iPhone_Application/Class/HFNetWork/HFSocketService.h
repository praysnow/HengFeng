//
//  HFSocketService.h
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 30/11/2017.
//  Copyright © 2017 HengFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFSocketService : NSObject

@property (copy ,nonatomic) NSString *socket_host;
@property (copy ,nonatomic) NSString *service_host;
@property (nonatomic, assign) BOOL  isSocketed;
@property (strong, nonatomic)GCDAsyncSocket *socket;

+ (HFSocketService *)sharedInstance;

- (void)setUpSocketWithHost:(NSString *)host andPort:(uint16_t)prot;

//发送Socket命令
- (void)sendCtrolMessage:(NSArray *)array;
- (void)reConnetSockets;

@end
