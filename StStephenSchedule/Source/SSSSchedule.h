//
//  SSSSchedule.h
//  StStephenSchedule
//
//  Created by Eric Liang on 3/31/19.
//  Copyright © 2019 St.Stephen's. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SSSClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSSSchedule : NSObject<NSCoding, NSSecureCoding>

@property (nonatomic, readonly) BOOL isHighschool;

- (instancetype)initWithHighSchool:(BOOL)high;

- (void)setClass:(SSSClass *)class forAllClassPeriod:(NSString *)classPeriod;
- (void)setClass:(SSSClass *)class forClassPeriod:(NSString *)classPeriod;
- (SSSClass *)getClassWithClassPeriod:(NSString *)classPeriod;

@end

NS_ASSUME_NONNULL_END
