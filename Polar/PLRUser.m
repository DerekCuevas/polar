//
//  PLRUser.m
//  Polar
//
//  Created by Derek Cuevas on 12/5/14.
//  Copyright (c) 2014 Derek Cuevas. All rights reserved.
//

#import "PLRUser.h"

@implementation PLRUser

- (instancetype)initWithUser:(NSString *)name {
    self = [super init];
    if (self) {
        self.username = name;
    }
    return self; 
}

- (instancetype)initWithUser:(NSString *)name questions:(NSArray *)questions {
    self = [self initWithUser:name];
    if (self) {
        self.questions = questions;
    }
    return self;
}

- (NSArray *)questions {
    if (_questions) {
        _questions = [NSArray new];
    }
    return _questions; 
}

- (NSInteger)userRank {
    NSInteger rank = 0;
    for (PLRQuestion *q in self.questions) {
        rank += q.rank;
    }
    return rank;
}

@end
