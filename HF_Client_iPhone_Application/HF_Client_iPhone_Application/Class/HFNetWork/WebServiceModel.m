//
//  WebServiceModel.m
//  flippedclassroomstudent
//
//  Created by 陈炳桦 on 2017/11/10.
//  Copyright © 2017年 陈炳桦. All rights reserved.
//

#import "WebServiceModel.h"

@implementation WebServiceModel

- (BOOL)hideN0{
    if ([HFNetwork network].serverType == ServerTypeBeiJing) {
        _hideN0 = YES;
    }else{
        _hideN0 = NO;
    }
    return _hideN0;
}

- (NSString *)getRequestParams{
    
    if (self.method == nil || self.method.length == 0) {
        return @"";
    }
    
    NSString *methodTag = self.hideN0 ? @"":@"n0:";
    NSString *xmlTag = self.hideN0 ? @"":@":n0";
    
    
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
    [mString appendFormat:@"<%@%@ xmlns%@=\"%@\">\n",methodTag, self.method,xmlTag,[HFNetwork network].NameSpace];
    
    if (self.params) {
        for (NSString *key in self.params) {
            [mString appendFormat:@" <%@>%@</%@>\n",key,self.params[key],key];
        }
    }
    
    [mString appendFormat:@"</%@%@>\n",methodTag,self.method];
    [mString appendFormat:
     @"</soap:Body>\n"
     "</soap:Envelope>"];
    
    return mString;
}

@end
