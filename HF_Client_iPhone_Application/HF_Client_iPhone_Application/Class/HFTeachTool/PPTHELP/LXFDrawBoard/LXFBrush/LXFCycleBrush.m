//
//  LXFCycleBrush.m
//  LXFDrawBoard
//
//  Created by 陈炳桦 on 2017/12/14.
//  Copyright © 2017年 LXF. All rights reserved.
//

#import "LXFCycleBrush.h"

@implementation LXFCycleBrush

- (void)drawInContext:(CGContextRef)ctx {
    
    CGFloat x = self.startPoint.x < self.endPoint.x ? self.startPoint.x : self.endPoint.x;
    CGFloat y = self.startPoint.y < self.endPoint.y ? self.startPoint.y : self.endPoint.y;
    CGFloat width = fabs(self.startPoint.x - self.endPoint.x);
    CGFloat height = fabs(self.startPoint.y - self.endPoint.y);
    
    // 椭圆
    CGContextAddEllipseInRect(ctx, CGRectMake(x, y, width, height));
    
}

- (BOOL)keepDrawing {
    return NO;
}

@end
