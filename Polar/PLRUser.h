//
//  PLRUser.h
//  Polar
//
//  Created by Derek Cuevas on 12/5/14.
//  Copyright (c) 2014 Derek Cuevas. All rights reserved.
//

// Important: unused class, might be usefull if adding a user view to the app
// I left this in here for that purpose 

#import <Foundation/Foundation.h>
#import "PLRQuestion.h"

@interface PLRUser : NSObject

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSArray *questions;

- (instancetype)initWithUser:(NSString *)name;
- (instancetype)initWithUser:(NSString *)name questions:(NSArray *)questions;
- (NSInteger)userRank;

@end
