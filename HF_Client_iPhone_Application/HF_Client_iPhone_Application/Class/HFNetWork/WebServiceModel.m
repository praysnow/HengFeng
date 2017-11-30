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

    [mString appendFormat: @"<s:Envelope xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\">"
     ];
    [mString appendFormat:@"<s:Body xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema/\"><%@ xmlns=\"http://tempuri.org/\">",self.method];

    if (self.params) {
        for (NSString *key in self.params) {
            [mString appendFormat:@" <%@>%@</%@>\n",key,self.params[key],key];
        }
    }
    [mString appendFormat:@"</%@>\n",self.method];
    [mString appendFormat:
     @"</s:Body>\n"
     "</s:Envelope>"];
    
    return mString;
}

@end
