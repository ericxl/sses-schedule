//
//  AppDelegate.m
//  StStephenSchedule
//
//  Created by Eric Liang on 6/22/12.
//  Copyright (c) 2012 St.Stephen's. All rights reserved.
//

#import "AppDelegate.h"
#import <Security/Security.h>
#import "Common.h"

@implementation AppDelegate

@synthesize window = _window;
//@synthesize splashView = _splashView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //[[NSUserDefaults standardUserDefaults] synchronize];
    //[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:kLanguageKey], nil] forKey:@"AppleLanguages"];
    /*
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:kLanguageKey] isEqualToString:[NSString stringWithFormat:@"_automatic"]]) {
        [NSLocale currentLocale];
    }
    */
    [NSLocale autoupdatingCurrentLocale];
    //switching to polish locale
    //[[NSUserDefaults standardUserDefaults] synchronize];

    [[NSUserDefaults standardUserDefaults]registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]],kUserDefaultsKeyAppCurrentVersion,nil]];
    [[NSUserDefaults standardUserDefaults]registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],kUserDefaultsKeyUpdateRemindTimes,nil]];
    [[NSUserDefaults standardUserDefaults]registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"], kUserDefaultsKeyOldVersion, nil]];
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0], kUserDefaultsKeyLaunchTimesSinceNewVersion, nil]];
    [[NSUserDefaults standardUserDefaults]registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kUserTypeSchoolSectionUpper],kUserDefaultsKeyUserTypeSchoolSection,nil]];
    [[NSUserDefaults standardUserDefaults]registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kUserTypePersonStudent],kUserDefaultsKeyUserTypePerson,nil]];
    [[NSUserDefaults standardUserDefaults]registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:@"Me",kUserDefaultsKeyUserName, nil]];
    [[NSUserDefaults standardUserDefaults]registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],kUserDefaultsKeyReviewRequested, nil]];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.window makeKeyAndVisible];
   
    
    if (![GET_USER_DEFAULT(kUserDefaultsKeyOldVersion) isEqualToString:[NSString stringWithString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]]]) {
        //update detected
        SET_USER_DEFAULT([NSNumber numberWithBool:NO], kUserDefaultsKeyReviewRequested);
        SET_USER_DEFAULT([NSNumber numberWithInteger:0], kUserDefaultsKeyLaunchTimesSinceNewVersion);
    }
    
    int launchTimes = (int)[[[NSUserDefaults standardUserDefaults]objectForKey:kUserDefaultsKeyLaunchTimesSinceNewVersion]integerValue];
    [[NSUserDefaults standardUserDefaults] setInteger:launchTimes + 1 forKey:kUserDefaultsKeyLaunchTimesSinceNewVersion];

    return YES;

}

-(void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:kUserDefaultsKeyOldVersion];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    //[[NSUserDefaults standardUserDefaults] synchronize];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:kUserDefaultsKeyOldVersion];
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
