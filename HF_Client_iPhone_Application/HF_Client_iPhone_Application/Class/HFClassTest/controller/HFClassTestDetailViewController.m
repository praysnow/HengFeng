//
//  HFClassTestDetailViewController.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 17/01/2018.
//  Copyright © 2018 HengFeng. All rights reserved.
//

#import "HFClassTestDetailViewController.h"

@interface HFClassTestDetailViewController ()

@end

@implementation HFClassTestDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"课堂测验";
    
    [self loadData];
}

- (void)loadData
{
    //    HFCacheObject *object = [HFCacheObject shardence];
//    NSString *soapString = [NSString stringWithFormat: @"<soap:Envelope   xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
//                            <soap:Header xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\" />\
//                            <soap:Body>\
//                            <GetDaoXueRenWuByTpID xmlns=\"http://tempuri.org/\">\
//                            <tpID>%@</tpID>\
//                            </GetDaoXueRenWuByTpID>\
//                            </soap:Body>\
//                            </soap:Envelope>", [HFCacheObject shardence].courseId];
//    _host = [NSString stringWithFormat: @"%@%@", HOST, DAOXUEAN_INTERFACE];
//    [[HFNetwork network] xmlSOAPDataWithUrl: _host soapBody: soapString success:^(id responseObject){
//        [responseObject setDelegate:self];
//        [responseObject parse];
//        NSLog(@"我的资源请求结果成功");
//        [self loadClassData];
//    } failure:^(NSError *error) {
//        NSLog(@"我的资源  请求结果失败");
//        NSLog(@"loadData faild %@",error.userInfo);
//    }];
}


@end
