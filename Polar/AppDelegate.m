//
//  AppDelegate.m
//  Polar
//
//  Created by Derek Cuevas on 12/5/14.
//  Copyright (c) 2014 Derek Cuevas. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ polar keys ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    //[Parse setApplicationId:@"erywO8cjjYf1vmiyfzlbzq7bOqGKEW7aCcrFEJXs"
    //              clientKey:@"MJoaNFB60siYWiiITvXmzgsaKsFDfg62A0DCoGKn"];
    
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ polar-dev keys ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    [Parse setApplicationId:@"FIOAl0Vv8rawXobSyyTiV8H0wS8GGyju9JGugKeG"
                  clientKey:@"AdR7Hq15Yb5kqyAQVUFd8tXZnQVqFHPJjIBPeSeq"];
    
    //Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // users are only allowed one vote per question, for testing it might be usefull to log
    // the anonymous user out, and create a new anonymous account on the server/phone
    // [PFUser logOut];
    
    // an anonymous PFUser is created on the phone/parse-db with first time run of the app,
    // this allows me to track questions a particular user voted on as well as questions
    // the user has asked without an annoying first time username/password login
    
    // in other words users can use the app anonymously without being forced to create an account
    
    // a sign-in controller would be all that is needed to allow users to have full accounts
    // all the functionallity exists in this app and the database for users, except a sign-in conroller
    // I have added some fake users on the parse db to demonstrate this
    
    if (![PFUser currentUser]) {
        [PFUser enableAutomaticUser];
        PFUser *anonUser = [PFUser currentUser];
        anonUser[@"anon"] = @YES;
        anonUser[@"voteHistory"] = [NSMutableDictionary new];
        [[PFUser currentUser] saveInBackground];
    }
    return YES;
}

@end
