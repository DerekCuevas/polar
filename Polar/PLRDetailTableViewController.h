//
//  PLRDetailTableViewController.h
//  Polar
//
//  Created by Derek Cuevas on 12/8/14.
//  Copyright (c) 2014 Derek Cuevas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLRQuestion.h"
#import "PLRPieChartView.h"

@interface PLRDetailTableViewController : UITableViewController

@property (strong, nonatomic) PLRQuestion *question;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *statsLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet PLRPieChartView *chart;

@end
