//
//  PLRTableViewCell.h
//  Polar
//
//  Created by Derek Cuevas on 12/6/14.
//  Copyright (c) 2014 Derek Cuevas. All rights reserved.
//

// the main table view cell, allows voting on question through the
// PLRViewCellDelegate protocol

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol PLRViewCellDelegate

- (void)vote:(NSString *)vote onQuestionWithId:(NSString *)objectId;

@end

@interface PLRTableViewCell : UITableViewCell

@property (weak, nonatomic) id <PLRViewCellDelegate> delegate;

@property (strong, nonatomic) NSString *objectId;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *question;
@property (weak, nonatomic) IBOutlet UILabel *stats;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UIButton *noButton;

@property (nonatomic) NSInteger yes;
@property (nonatomic) NSInteger no; 

- (IBAction)vote:(UIButton *)sender;

@end
