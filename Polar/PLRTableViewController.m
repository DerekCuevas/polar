//
//  PLRTableViewController.m
//  Polar
//
//  Created by Derek Cuevas on 12/5/14.
//  Copyright (c) 2014 Derek Cuevas. All rights reserved.
//

#import <Parse/Parse.h>
#import "PLRTableViewController.h"
#import "PLRDetailTableViewController.h"
#import "PLRAskQuestionViewController.h"
#import "PLRQuestion.h"
#import "PLRUser.h"
#import "PLRModel.h"

@interface PLRTableViewController ()

@property (strong, nonatomic) PLRModel *model;
@property (strong, nonatomic) UIColor *voteColor;
@property (strong, nonatomic) UIColor *otherColor;

@end

@implementation PLRTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reload:nil];
    
    self.voteColor = [UIColor colorWithRed:0.20392 green:0.596 blue:0.8588 alpha:1.0];
    self.otherColor = [UIColor groupTableViewBackgroundColor];
    self.sortSegmentControl.tintColor = self.voteColor;
}

- (IBAction)sortPolls:(UISegmentedControl *)sender {
    [self reloadData];
    if (self.model.dataSource.count != 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
    }
}

#pragma mark - PLRTableViewCell delegate

- (void)vote:(NSString *)vote onQuestionWithId:(NSString *)objectId {
    [self.model vote:vote onQuestionWithId:objectId];
    [self reloadData];
}

#pragma mark - Model setup

- (PLRModel *)model {
    if (!_model) {
        _model = [PLRModel new];
        _model.queryLimit = 50;
    }
    return _model;
}

- (IBAction)reload:(id)sender {
    [self.refreshControl beginRefreshing];
    
    [self.model loadQuestionsWithCompletion:^{
        [self reloadData];
        [self.refreshControl endRefreshing];
    }];
}

- (void)reloadData {
    if (self.sortSegmentControl.selectedSegmentIndex == 0) {
        [self.model sortDataSouceByDate];
    } else {
        [self.model sortDataSouceByRank];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.model.dataSource count];
}

// this method probably needs some refactoring, I have documented the steps needed to setup a cell
// none of this is computationally intensive
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PLRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"polar question cell"
                                                             forIndexPath:indexPath];
    [self resetCell:cell];
    
    // configure cell for question to display
    PLRQuestion *question = [self.model.dataSource objectAtIndex:indexPath.row];
    cell.objectId = question.objectId;
    
    // there is an added "anon" boolean property associated with each user in parse's db,
    // this is needed to hide the cryptic username parse assigns to anonymous users
    NSString *username = question.user.username;
    if ([question.user[@"anon"] boolValue]) {
        username = @"Anonymous";
    }
    
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    cell.username.attributedText = [[NSAttributedString alloc] initWithString:username
                                                                   attributes:underlineAttribute];
    
    NSString *stats = @"yes: 0% no: 0%";
    if (question.total != 0) {
        NSInteger percentYes = (question.yes / (double)question.total) * 100;
        NSInteger percentNo = (question.no / (double)question.total) * 100;
        stats = [NSString stringWithFormat:@"yes: %ld%% no: %ld%%", percentYes, percentNo];
    }
    
    cell.question.text = question.question;
    cell.stats.text = stats;
    
    [self addColorsToCell:cell withQuestion:question];
    return cell;
}

- (void)resetCell:(PLRTableViewCell *)cell {
    cell.yesButton.backgroundColor = self.otherColor;
    [cell.yesButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    cell.noButton.backgroundColor = self.otherColor;
    [cell.noButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    cell.delegate = self;
}

// look up old votes in the "voteHistory" property of the current user
// this is needed to color buttons on old votes
- (void)addColorsToCell:(PLRTableViewCell *)cell withQuestion:(PLRQuestion *)question {
    NSMutableDictionary *voteHistory = [PFUser currentUser][@"voteHistory"];
    NSString *vote = [voteHistory objectForKey:question.objectId];
    if (vote) {
        if ([vote isEqualToString:@"yes"]) {
            cell.yesButton.backgroundColor = self.voteColor;
            [cell.yesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else {
            cell.noButton.backgroundColor = self.voteColor;
            [cell.noButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[PLRDetailTableViewController class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        PLRQuestion *q = [self.model.dataSource objectAtIndex:indexPath.row];
        PLRDetailTableViewController *pdvc = segue.destinationViewController;
        pdvc.question = q;
    }
}

- (IBAction)addQuestion:(UIStoryboardSegue *)segue {
    if ([segue.sourceViewController isKindOfClass:[PLRAskQuestionViewController class]]) {
        PLRAskQuestionViewController *aqvc = segue.sourceViewController;
        NSString *question = aqvc.questionTextView.text;
        
        if (question.length > 0) {
            PLRQuestion *newQuestion = [[PLRQuestion alloc] initWithQuestion:question];
            __weak PLRTableViewController *weakSelf = self;
            
            [self.model addQuestion:newQuestion withCompletion:^{
                [weakSelf reloadData];
            }];
        }
    }
}

- (IBAction)cancelQuestion:(UIStoryboardSegue *)segue {
    [self.view resignFirstResponder];
}

@end
