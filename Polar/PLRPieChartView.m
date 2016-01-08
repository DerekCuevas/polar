//
//  PLRPieChartView.m
//  Polar
//
//  Created by Derek Cuevas on 12/8/14.
//  Copyright (c) 2014 Derek Cuevas. All rights reserved.
//

#import "PLRPieChartView.h"

@implementation PLRPieChartView

- (CGFloat)radians:(CGFloat)degrees {
    return degrees * M_PI / 180.0;
}

- (void)drawSlice:(CGFloat)size color:(UIColor *)color clockwise:(BOOL)dir {
    CGFloat angle = [self radians:-size];
    
    CGFloat x = self.bounds.size.width / 2;
    CGFloat y = self.bounds.size.height / 2;
    
    CGPoint center = CGPointMake(x, y);
    CGFloat radius = self.bounds.size.height / 2;
    
    UIBezierPath *slice = [UIBezierPath bezierPath];
    [slice moveToPoint:center];
    [slice addLineToPoint:CGPointMake(center.x + radius * cosf(angle), center.y + radius * sinf(angle))];
    [slice addArcWithCenter:center radius:radius startAngle:angle endAngle:[self radians:size] clockwise:dir];
    
    [slice closePath];
    [color setFill];
    [slice fill];
}

- (void)drawRect:(CGRect)rect {
    UIColor *yesColor = [UIColor colorWithRed:0.20392 green:0.596 blue:0.8588 alpha:1.0];
    UIColor *noColor = [UIColor groupTableViewBackgroundColor];
    
    if (self.yes == 0 && self.no == 0) {
        //show no stats message
    } else if (self.yes == 0) {
        [self drawSlice:180.0 color:noColor clockwise:YES];
    } else if (self.no == 0) {
        [self drawSlice:180.0 color:yesColor clockwise:YES];
    } else {
        CGFloat noSlice = (self.no / (float)(self.no + self.yes)) * 180.0;
        CGFloat yesSlice = 180 - (180.0 - noSlice);
        
        [self drawSlice:noSlice color:noColor clockwise:YES];
        [self drawSlice:yesSlice color:yesColor clockwise:NO];
    }
}

@end
