//
//  Common.h
//  StStephenSchedule
//
//  Created by Eric Liang on 11/26/12.
//  Copyright (c) 2012 St.Stephen's. All rights reserved.
//


#ifndef StStephenSchedule_Common_h
#define StStephenSchedule_Common_h

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define kParseApplicationID @"zsaHWsnaGQ2urj5GjzVvAGdHj41sUh92bwphowle"
#define kParseClientKey @"C1GnjrmPlftxQyQh1NyI87AUD09O21UqHYMWs7OV"

//User default keys
#define kUserDefaultsKeyFirstLaunch @"firstLaunch"
#define kUserDefaultsKeyLaunchTimesSinceNewVersion @"launchTimesSinceNewVersion"
#define kUserDefaultsKeyOldVersion @"oldVersion"
#define kUserDefaultsKeyReviewRequested @"reviewRequested"
#define kUserDefaultsKeyAppCurrentVersion @"appCurrentVersion"
#define kUserDefaultsKeyUpdateRemindTimes @"updateRemindTimes"
#define kUserDefaultsKeyUserTypeSchoolSection @"userTypeSchoolSection"
#define kUserDefaultsKeyUserTypePerson @"userTypePerson"
#define kUserDefaultsKeyUserName @"userName"

//IAPs
#define kUserDefaultsKeyMUIAPEnabled @"STXIDSerialID" 
#define kUserDefaultsKeyADCode @"iTnetCellActivitionCode"

// URLs
#define UPPER_CLASS_COURSE_LIST_URL @"http://sses-schedule.parseapp.com/support/sstxClasses_upper.plist"
#define MIDDLE_CLASS_COURSE_LIST_URL @"http://sses-schedule.parseapp.com/support/sstxClasses_middle.plist"
#define VERSION_NUMBER_URL @"http://sses-schedule.parseapp.com/support/versionNumber.txt"
#define YOUTUBE_TUTORIAL_LINK_URL @"http://sses-schedule.parseapp.com/support/youtube_link.txt"
#define LETTER_DAY_URL @"http://apache.sstx.org/letterday/letterDayJsonP.php"
#define ITUNES_STORE_URL @"itms-apps://itunes.apple.com/app/id540807002"
#define MAIL_TO_URL @"mailto://ericliang@utexas.edu"
#define SSES_HOME_URL @"http://www.sstx.org"
#define SSES_NET_CLASSROOM_URL @"https://bbnet.sstx.org"
#define SSES_MOODLE_URL @"http://moodle.sstx.org"
#define SSES_TELEPHONE_URL @"tel:5123271213"

#define kUserTypeSchoolSectionUpper 0
#define kUserTypeSchoolSectionMiddle 1
#define kUserTypePersonStudent 0
#define kUserTypePersonTeacher 1

#define kSettingsUsersPassedDataUserName @"userName"
#define kSettingsUsersPassedDataSchoolSection @"userSchoolSection"
#define kSettingsUsersPassedDataPersonType @"userPersonType"
#define kSettingsUsersPassedDataIndex @"selectedIndex"
#define kSettingsUsersPassedDataIsNew @"isNew"
#define kSettingsUsersPassedDataIsCurrentUser @"isCurrentUser"

#define kPrimeUserDataFileName @"userData.plist"
#define kUsersNamesManagerFileName @"userNames.plist"

#define CURRENT_USER_NAME [[NSUserDefaults standardUserDefaults]objectForKey:kUserDefaultsKeyUserName]
#define SCHOOL_SECTION [[[NSUserDefaults standardUserDefaults]objectForKey:kUserDefaultsKeyUserTypeSchoolSection]integerValue]
#define PERSON_TYPE [[[NSUserDefaults standardUserDefaults]objectForKey:kUserDefaultsKeyUserTypePerson]integerValue]
#define IS_UPPER [[[NSUserDefaults standardUserDefaults]objectForKey:kUserDefaultsKeyUserTypeSchoolSection]integerValue] == 0 ? YES : NO

#define PATH_FOR_FILE_IN_DOCUMENT_DOMAIN(_FILE_) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:_FILE_]
#define DATA_NAME_FOR_USER_NAME(_USER_NAME_) [NSString stringWithFormat:@"userData_%@.plist",_USER_NAME_]
#define PATH_FOR_DATA_OF_USER(_USER_NAME_) PATH_FOR_FILE_IN_DOCUMENT_DOMAIN(DATA_NAME_FOR_USER_NAME(_USER_NAME_))

#define kUserDataKeyUserName @"userName"
#define kUserDataKeyUserSchoolSection @"userSchoolSection"
#define kUserDataKeyUserPersonType @"userPersonType"
#define kUserDataKeyUserSchedule @"userSchedule"

#define SET_USER_DEFAULT(__VALUE__,__KEY__) [[NSUserDefaults standardUserDefaults] setObject:__VALUE__ forKey:__KEY__];
#define GET_USER_DEFAULT(__KEY__) [[NSUserDefaults standardUserDefaults]objectForKey:__KEY__]

#define GENERATE_USER_DATA_DICTIONARY(_SCHEDULE_,_USER_NAME_,_SCHOOL_SECTION_,_PERSON_TYPE_) [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:_SCHOOL_SECTION_],kUserDataKeyUserSchoolSection,[NSNumber numberWithInteger:_PERSON_TYPE_],kUserDataKeyUserPersonType,_USER_NAME_,kUserDataKeyUserName,_SCHEDULE_,kUserDataKeyUserSchedule, nil];

#endif

#import "UIImage_draw_schedule.h"

