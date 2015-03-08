//
//  PLRDetailTableViewController.m
//  Polar
//
//  Created by Derek Cuevas on 12/8/14.
//  Copyright (c) 2014 Derek Cuevas. All rights reserved.
//

#import "PLRDetailTableViewController.h"

@implementation PLRDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"details";
    self.chart.yes = self.question.yes;
    self.chart.no = self.question.no; 
    
    NSString *stats = @"yes: 0% no: 0%";
    if (self.question.total != 0) {
        NSInteger percentYes = (self.question.yes / (double)self.question.total) * 100;
        NSInteger percentNo = (self.question.no / (double)self.question.total) * 100;
        stats = [NSString stringWithFormat:@"yes: %ld%% no: %ld%%", percentYes, percentNo];
    }
    
    NSString *username = self.question.user.username;
    if ([self.question.user[@"anon"] boolValue]) {
        username = @"Anonymous";
    }

    self.userLabel.text = username;
    self.questionLabel.numberOfLines = 0; 
    self.questionLabel.text = self.question.question;
    self.statsLabel.text = stats;
    self.totalLabel.text = [NSString stringWithFormat:@"total votes: %ld", self.question.total];
    self.rankLabel.text = [NSString stringWithFormat:@"rank: %ld", self.question.rank];
}

- (PLRQuestion *)question {
    if (!_question) {
        _question = [PLRQuestion new];
    }
    return _question;
}

@end
