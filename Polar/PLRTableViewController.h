//
//  PLRTableViewController.h
//  Polar
//
//  Created by Derek Cuevas on 12/5/14.
//  Copyright (c) 2014 Derek Cuevas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLRTableViewCell.h"

@interface PLRTableViewController : UITableViewController <PLRViewCellDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *sortSegmentControl;

- (void)vote:(NSString *)vote onQuestionWithId:(NSString *)objectId;
- (IBAction)sortPolls:(UISegmentedControl *)sender;

@end
