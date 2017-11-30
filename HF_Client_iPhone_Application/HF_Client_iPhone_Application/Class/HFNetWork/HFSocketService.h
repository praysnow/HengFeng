//
//  HFSocketService.h
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 30/11/2017.
//  Copyright © 2017 HengFeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFSocketService : NSObject

+ (HFSocketService *)sharedInstance;

- (void)setUpSocketWithHost:(NSString *)host andPort:(uint16_t)prot;

@end
