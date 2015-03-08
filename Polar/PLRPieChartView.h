//
//  PLRPieChartView.h
//  Polar
//
//  Created by Derek Cuevas on 12/8/14.
//  Copyright (c) 2014 Derek Cuevas. All rights reserved.
//

// pie chart view used in the detail view for each question,
// adds visual representation of voting data

#import <UIKit/UIKit.h>

@interface PLRPieChartView : UIView

@property (nonatomic) NSInteger yes;
@property (nonatomic) NSInteger no;

@end
