//
//  SSSSchedule.m
//  StStephenSchedule
//
//  Created by Eric Liang on 3/31/19.
//  Copyright © 2019 St.Stephen's. All rights reserved.
//

#import "SSSSchedule.h"

@interface SSSSchedule()

@property (nonatomic, strong) NSMutableDictionary *_data;
@property (nonatomic, assign) BOOL highSchool;

@end

@implementation SSSSchedule

- (instancetype)initWithHighSchool:(BOOL)high
{
    self = [super init];
    if (self != nil)
    {
        __data = [NSMutableDictionary new];
        NSString *allDays = @"ABCDEFFG";
        for (NSUInteger charIdx = 0; charIdx < allDays.length; charIdx++)
        {
            for (NSInteger period = 1; period <= 8; period++)
            {
                [__data setObject:[SSSClass new] forKey:[NSString stringWithFormat:@"%C%ld", [allDays characterAtIndex:charIdx], (long)period]];
            }
        }
        _highSchool = high;
    }
    return self;
}

+(NSDictionary<NSNumber *, NSArray *> *)highSchoolMap
{
    static NSDictionary<NSNumber *, NSArray *> *high_school_map = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        high_school_map = @{
                            @(SSSClass0): @[@"B1", @"C2", @"D3", @"E4", @"F7", @"G8"],
                            @(SSSClass1): @[@"A1", @"B2", @"C3", @"D4", @"E7", @"F8"],
                            @(SSSClass2): @[@"A2", @"B3", @"C4", @"D7", @"E8", @"G1"],
                            @(SSSClass3): @[@"A3", @"B4", @"C7", @"D8", @"F1", @"G2"],
                            @(SSSClass4): @[@"A4", @"B7", @"C8", @"E1", @"F2", @"G3"],
                            @(SSSClass5): @[@"A5", @"B5", @"C5", @"D5", @"E5", @"F5", @"G5"],
                            @(SSSClass6): @[@"A6", @"B6", @"C6", @"D6", @"E6", @"F6", @"G6"],
                            @(SSSClass7): @[@"A7", @"B8", @"D1", @"E2", @"F3", @"G4"],
                            @(SSSClass8): @[@"A8", @"C1", @"D2", @"E3", @"F4", @"G7"]
                            };
    });
    return high_school_map;
}

+(NSDictionary<NSNumber *, NSArray *> *)middleSchoolMap
{
    static NSDictionary<NSNumber *, NSArray *> *middle_school_map = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        middle_school_map = @{
                              @(SSSClass0): @[@"B1", @"C2", @"D3", @"E5", @"F7", @"G6"],
                              @(SSSClass1): @[@"A1", @"B2", @"C3", @"D5", @"E7", @"F6"],
                              @(SSSClass2): @[@"A2", @"B3", @"C5", @"D7", @"E6", @"G1"],
                              @(SSSClass3): @[@"A3", @"B5", @"C7", @"D6", @"F1", @"G2"],
                              @(SSSClass4): @[@"A4", @"B4", @"C4", @"D4", @"E4", @"F4", @"G4"],
                              @(SSSClass5): @[@"A5", @"B7", @"C6", @"E1", @"F2", @"G3"],
                              @(SSSClass6): @[@"A6", @"C1", @"D2", @"E3", @"F5", @"G7"],
                              @(SSSClass7): @[@"A7", @"B6", @"D1", @"E2", @"F3", @"G5"],
                              @(SSSClass8): @[@"A8", @"B8", @"C8", @"D8", @"E8", @"F8", @"G8"]
                              };
    });
    return middle_school_map;
}

- (BOOL)isHighschool
{
    return _highSchool;
}

- (void)setClass:(SSSClass *)class forClassPeriod:(NSString *)classPeriod
{
    [self._data setObject:class forKey:classPeriod];
}

- (void)setClass:(SSSClass *)class forAllClassPeriod:(NSString *)classPeriod
{
    NSDictionary<NSNumber *, NSArray *> *currentMap = self.isHighschool ? [SSSSchedule highSchoolMap] : [SSSSchedule middleSchoolMap];
    NSNumber *currentClassID = nil;
    for (NSNumber *periodKey in currentMap.allKeys)
    {
        NSArray *periods = currentMap[periodKey];
        for (NSString *p in periods)
        {
            if ([p isEqualToString:classPeriod])
            {
                currentClassID = periodKey;
                break;
            }
        }
    }
    NSArray *classesPeriods = currentMap[currentClassID];
    for (NSString *cp in classesPeriods)
    {
        [self setClass:class forClassPeriod:cp];
    }
    
}

- (SSSClass *)getClassWithClassPeriod:(NSString *)classPeriod
{
    return self._data[classPeriod];
}

#pragma mark NSCodingProtocol

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:__data forKey:@"_data"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    self = [super init];
    if (self)
    {
        __data = [coder decodeObjectOfClass:[NSDictionary class] forKey:@"_data"];
    }
    return self;
}

@end
