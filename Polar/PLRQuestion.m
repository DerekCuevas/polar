//
//  PLRQuestion.m
//  Polar
//
//  Created by Derek Cuevas on 12/5/14.
//  Copyright (c) 2014 Derek Cuevas. All rights reserved.
//

#import "PLRQuestion.h"

@implementation PLRQuestion

- (instancetype)initWithQuestion:(NSString *)question {
    self = [super init];
    if (self) {
        self.question = question;
        self.dateAsked = [NSDate date]; 
        self.yes = 0;
        self.no =  0;
    }
    return self;
}

- (PFObject *)toPFObject {
    PFObject *pq = [PFObject objectWithClassName:PARSE_POLAR_QUESTION];
    pq[@"question"] = self.question;
    pq[@"yes"] = [NSNumber numberWithInteger: self.yes];
    pq[@"no"] = [NSNumber numberWithInteger: self.no];
    return pq;
}

- (NSComparisonResult)compare:(id)otherObject {
    NSInteger rank1 = self.rank;
    NSInteger rank2 = ((PLRQuestion *)otherObject).rank;
    
    if (rank1 > rank2) {
        return NSOrderedAscending;
    }
    else if (rank1 < rank2) {
        return NSOrderedDescending;
    }
    else {
        return NSOrderedSame;
    }
}

- (NSInteger)total {
    return self.yes + self.no;
}

- (NSInteger)rank {
    double recent = self.dateRank * 0.35;
    double total = self.totalRank * 0.55;
    double ratio = self.ratioRank * 0.10;
    return ceil(recent + total + ratio);
}

- (double)dateRank {
    double day = 86400;
    NSDate *current = [NSDate date];
    NSTimeInterval difference = [self.dateAsked timeIntervalSinceDate:current];
    return ceil((pow(2, (difference/day)) * 100));
}

- (double)totalRank {
    double t = self.total;
    if (t != 0) {
        return 100 * pow(10, - 1.0 / t);
    }
    return 1;
}

- (double)ratioRank {
    double diff =  - abs((int)self.yes - (int)self.no);
    double weight = pow(1.025, diff);
    return 100 * weight;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"question: %@, rank: %ld", self.question, self.rank];
}

@end
