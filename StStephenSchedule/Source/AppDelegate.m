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
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{kDisplayingUserNameKey: kDefaultUserName}];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}

@end
