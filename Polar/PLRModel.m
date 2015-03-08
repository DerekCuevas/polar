//
//  PLRModel.m
//  Polar
//
//  Created by Derek Cuevas on 12/7/14.
//  Copyright (c) 2014 Derek Cuevas. All rights reserved.
//

#import "PLRModel.h"

@implementation PLRModel

#pragma mark - Lazily Instantiated properties

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

#pragma mark - Data source 

- (void)sortDataSouceByRank {
    NSArray *sorted = [self.dataSource sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        PLRQuestion *q1 = (PLRQuestion *)obj1;
        PLRQuestion *q2 = (PLRQuestion *)obj2;
        return [q1 compare:q2];
    }];
    self.dataSource = [NSMutableArray arrayWithArray:sorted];
}

- (void)sortDataSouceByDate {
    NSArray *sorted = [self.dataSource sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        PLRQuestion *q1 = (PLRQuestion *)obj1;
        PLRQuestion *q2 = (PLRQuestion *)obj2;
        return [q2.dateAsked compare:q1.dateAsked];
    }];
    self.dataSource = [NSMutableArray arrayWithArray:sorted];
}

- (PLRQuestion *)questionWithId:(NSString *)objectId {
    for (PLRQuestion *question in self.dataSource) {
        if ([question.objectId isEqualToString:objectId]) {
            return question;
        }
    }
    return nil;
}

#pragma mark - Parse Interface

- (PLRQuestion *)toPLRQuestion:(PFObject *)obj {
    PLRQuestion *question = [[PLRQuestion alloc] init];
    question.objectId = obj.objectId;
    question.question = obj[@"question"];
    question.dateAsked = obj.createdAt;
    question.yes = [obj[@"yes"] integerValue];
    question.no = [obj[@"no"] integerValue];
    question.user = obj[@"user"];
    return question;
}

- (void)loadQuestionsWithCompletion:(void (^)(void))completionHandler {
    PFQuery *query = [PFQuery queryWithClassName:PARSE_POLAR_QUESTION];
    [query includeKey:@"user"];
    [query orderByDescending:@"createdAt"];
    query.limit = self.queryLimit;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *questions = [NSMutableArray new];
            for (PFObject *obj in objects) {
                [questions addObject:[self toPLRQuestion:obj]];
            }
            self.dataSource = questions;
            completionHandler();
        }
        else {
            NSLog(@"Parse Query Error: failed finding questions...");
        }
    }];
}

- (void)vote:(NSString *)vote onQuestionWithId:(NSString *)objectId {
    PFQuery *query = [PFQuery queryWithClassName:PARSE_POLAR_QUESTION];
    [query getObjectInBackgroundWithId:objectId block:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"Parse Query Error: vote failed to find question...");
        }
        else {
            [object incrementKey:vote];
            [object saveInBackground];
        }
    }];
    PLRQuestion *question = [self questionWithId:objectId];
    [question setValue: @([[question valueForKey:vote] integerValue] + 1) forKey:vote];
}

- (void)addQuestion:(PLRQuestion *)question withCompletion:(void (^)(void))completionHandler {
    PFObject *q = [question toPFObject];
    q[@"user"] = [PFUser currentUser];

    [q saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            PFRelation *rel = [[PFUser currentUser] relationForKey:@"questions"];
            [rel addObject:q];
            
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    question.objectId = q.objectId;
                    question.user = [PFUser currentUser];
                    [self.dataSource addObject:question];
                    completionHandler();
                }
                else {
                    NSLog(@"Parse Error: failed update user relation");
                }
            }];
        }
        else {
            NSLog(@"Parse Error: failed to add question");
        }
    }];
}

@end
