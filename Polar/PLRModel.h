//
//  PLRModel.h
//  Polar
//
//  Created by Derek Cuevas on 12/7/14.
//  Copyright (c) 2014 Derek Cuevas. All rights reserved.
//

// This file contains the model for the PLR table view (the main table view)
// contains code needed to interface between this app and the parse database

// Parse Database setup (Two Tables):

//   1.) User table (PFUsers):
//       normal PFUser rows (username, password, ...)
//       added rows:
//         questions -> one-to-many relationship with the questions they ask
//         voteHistory -> dictonary that holds vote history in this format: {"ObjectId" : "Vote"}
//                        objectId's of the questions are the keys

//   2.) PLRQuestion table (PFObject):
//       normal PFObject rows (ObjectId, createdAt, ...)
//       added rows:
//         question -> string
//         no -> number
//         yes -> number
//         user -> pointer to user that asked the question


// I have added some fake accounts/questions/data to the db on parse 

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "PLRQuestion.h"
#import "PLRUser.h"

@interface PLRModel : NSObject

// of PLRQuestions
@property (strong, nonatomic) NSMutableArray *dataSource;

// limits the number of questions pulled down from parse with every request
@property (nonatomic) NSInteger queryLimit; 

- (void)sortDataSouceByRank;
- (void)sortDataSouceByDate;

// hard reload from the parse database
- (void)loadQuestionsWithCompletion:(void (^)(void))completionHandler;

// voting is limited to one vote per question per user,
// this is enforced by the "voteHistory" row in the user table
- (void)vote:(NSString *)vote onQuestionWithId:(NSString *)objectId;

// adds question to PLRQuestion table, updates relationships,
// sets the user who asked the to the currentUser
- (void)addQuestion:(PLRQuestion *)question withCompletion:(void (^)(void))completionHandler;

@end
