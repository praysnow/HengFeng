//
//  HFStudentStatusPersonViewController.m
//  HF_Client_iPhone_Application
//
//  Created by 陈炳桦 on 2017/12/20.
//  Copyright © 2017年 HengFeng. All rights reserved.
//

#import "HFStudentStatusPersonViewController.h"
#import "HFNetwork.h"
#import "WebServiceModel.h"

@interface HFStudentStatusPersonViewController ()

@end

@implementation HFStudentStatusPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"学生状态-个人";
    
    WebServiceModel *model = [WebServiceModel new];
    model.method = @"GetStudentListByClassID";
    
    NSString *classId = [HFCacheObject shardence].classId;
    
    model.params = @{@"ClassID":classId}.mutableCopy;
    
    NSString *url = [NSString stringWithFormat: @"%@%@", HOST, @"webService/WisdomClassWS.asmx"];
    [[HFNetwork network] xmlSOAPDataWithUrl:url soapBody:[model getRequestParams] success:^(id responseObject) {
      
        
        NSLog(@"返回数据%@",responseObject);
        
    } failure:^(NSError *error) {
        
    }];
    
}



@end
