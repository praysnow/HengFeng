//
//  HFInterFace.h
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 24/11/2017.
//  Copyright © 2017 HengFeng. All rights reserved.
//

@interface HFInterFace : NSObject

/* HOST */
#define HOST [HFSocketService sharedInstance].service_host

/* Login InterFace */
#define LOGIN_INTERFACE @"webService/WisdomClassWS.asmx?op=CheckUser"
#define DAOXUEAN_INTERFACE @"webService/WisdomClassWS.asmx?op=GetDaoXueRenWuByTpID"
#define DAOXUETANG_INTERFACE @"webService/WisdomClassWS.asmx?op=GetCourseResByTpID"
/* login name cache user default */

/*  UserDefault  */

#define ADDRESS_HOST @"address_host"

#define LOGIN_INFO_CACHE @"LOGIN_INFO_CACHE"

typedef NS_ENUM(NSUInteger, MATMatchDetailDataLoadedType) {
    MATMatchDetailDataLoadedTypeNone = 0,
    MATMatchDetailDataLoadedTypeHeader = 1 << 0,
    MATMatchDetailDataLoadedTypeVideoLive = 1 << 1,
};


@end
