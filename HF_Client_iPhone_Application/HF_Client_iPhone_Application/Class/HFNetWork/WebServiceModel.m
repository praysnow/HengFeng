//
//  WebServiceModel.m
//  flippedclassroomstudent
//
//  Created by 陈炳桦 on 2017/11/10.
//  Copyright © 2017年 陈炳桦. All rights reserved.
//

#import "WebServiceModel.h"



@implementation WebServiceModel

- (NSString *)getRequestParams{
    
    if (self.method == nil || self.method.length == 0) {
        return @"";
    }
//    NSString *methodTag = @"";
//    NSString *xmlTag = @"";
    
    NSMutableString *mString = [NSMutableString string];
    
//    [NSString stringWithFormat:@"<soap:Envelope   xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//     "<soap:Header xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\" />\n"
//     "  <soap:Body>\n"
//     "  <n0:CheckUser xmlns:n0=\"http://ui.asp.zhpt.header.com/\">\n"
//     " <arg2>学生</arg2>\n"
//     " <arg0>2017040411</arg0>\n"
//     " <arg1>888888</arg1>\n"
//     "       </n0:CheckUser>\n"
//     "  </soap:Body>\n"
//     "</soap:Envelope>"];
    
    [mString appendFormat:@"<soap:Envelope   xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
     "<soap:Header xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\" />\n"
     "  <soap:Body>\n"
     ];
    [mString appendFormat:@"<n0:%@ xmlns:n0=\"http://ui.asp.zhpt.header.com/\">\n",self.method];
    
    if (self.params) {
        for (NSString *key in self.params) {
            [mString appendFormat:@" <%@>%@</%@>\n",key,self.params[key],key];
        }
    }
    
    [mString appendFormat:@"</n0:%@>\n",self.method];
    [mString appendFormat:
     @"</soap:Body>\n"
     "</soap:Envelope>"];
    
    return mString;
}

@end
