//
//  PLRQuestion.h
//  Polar
//
//  Created by Derek Cuevas on 12/5/14.
//  Copyright (c) 2014 Derek Cuevas. All rights reserved.
//

// class adds functionality for rating / comparing questions
// the PARSE_POLAR_QUESTION define is the name of the questions table on parse 

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#define PARSE_POLAR_QUESTION @"PLRQuestion"

@interface PLRQuestion : NSObject

@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) NSString *objectId; 
@property (strong, nonatomic) NSString *question;
@property (strong, nonatomic) NSDate *dateAsked;
@property (nonatomic) NSInteger total;
@property (nonatomic) NSInteger yes;
@property (nonatomic) NSInteger no;

// designated initializer
- (instancetype)initWithQuestion:(NSString *)question; 
- (PFObject *)toPFObject; 

// compares questions by rank
- (NSComparisonResult)compare:(id)otherObject;

// rank is scored on a scale from 0 to 100
// recent questions with a strong divide of yes's to no's and a large total will recive a high rank
- (NSInteger)rank;

- (NSString *)description;

@end
