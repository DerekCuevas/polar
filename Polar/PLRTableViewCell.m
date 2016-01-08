//
//  PLRTableViewCell.m
//  Polar
//
//  Created by Derek Cuevas on 12/6/14.
//  Copyright (c) 2014 Derek Cuevas. All rights reserved.
//

#import "PLRTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation PLRTableViewCell

- (void)awakeFromNib {
    self.username.textColor = [UIColor darkGrayColor];
    self.stats.textColor = [UIColor grayColor];
    
    CGFloat radius = self.yesButton.bounds.size.width / 2;
    self.yesButton.layer.cornerRadius = radius;
    self.noButton.layer.cornerRadius = radius;
}

- (IBAction)vote:(UIButton *)sender {
    NSString *vote = sender.currentTitle;
    UIColor *voteColor = [UIColor colorWithRed:0.20392 green:0.596 blue:0.8588 alpha:1.0];
    NSMutableDictionary *voteHistory = [PFUser currentUser][@"voteHistory"];
    
    if (![voteHistory objectForKey:self.objectId]) {
        if ([vote isEqualToString:@"yes"]) {
            self.yesButton.backgroundColor = voteColor;
            [self.yesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else {
            self.noButton.backgroundColor = voteColor;
            [self.noButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        voteHistory[self.objectId] = vote;
        [PFUser currentUser][@"voteHistory"] = voteHistory;
        [[PFUser currentUser] saveInBackground];
        
        [self.delegate vote:sender.currentTitle onQuestionWithId:self.objectId];
    }
}

@end
