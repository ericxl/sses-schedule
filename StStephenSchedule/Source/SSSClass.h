//
//  SSSClass.h
//  StStephenSchedule
//
//  Created by Eric Liang on 3/31/19.
//  Copyright © 2019 St.Stephen's. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SSSClassIdentifier)
{
    SSSClassUndefined,
    SSSClass0,
    SSSClass1,
    SSSClass2,
    SSSClass3,
    SSSClass4,
    SSSClass5,
    SSSClass6,
    SSSClass7,
    SSSClass8,
};

@interface SSSClass : NSObject<NSCoding, NSSecureCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *teacher;
@property (nonatomic, strong) NSString *location;

@end

NS_ASSUME_NONNULL_END
