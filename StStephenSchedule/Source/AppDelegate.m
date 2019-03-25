//
//  AppDelegate.m
//  StStephenSchedule
//
//  Created by Eric Liang on 6/22/12.
//  Copyright (c) 2012 St.Stephen's. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[NSUserDefaults standardUserDefaults]registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kUserTypeSchoolSectionUpper],kUserDefaultsKeyUserTypeSchoolSection,nil]];
    [[NSUserDefaults standardUserDefaults]registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kUserTypePersonStudent],kUserDefaultsKeyUserTypePerson,nil]];
    [[NSUserDefaults standardUserDefaults]registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:@"Me",kUserDefaultsKeyUserName, nil]];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;

}

@end
