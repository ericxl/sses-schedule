//
//  SSSClass.m
//  StStephenSchedule
//
//  Created by Eric Liang on 3/31/19.
//  Copyright © 2019 St.Stephen's. All rights reserved.
//

#import "SSSClass.h"

@implementation SSSClass

- (instancetype)init
{
    self = [super init];
    if (self != nil)
    {
        _name = nil;
        _teacher = nil;
        _location = nil;
    }
    return self;
}

#pragma mark NSCodingProtocol

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:_name forKey:@"_name"];
    [coder encodeObject:_teacher forKey:@"_teacher"];
    [coder encodeObject:_location forKey:@"_location"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        _name = [coder decodeObjectOfClass:[NSString class] forKey:@"_name"];
        _teacher = [coder decodeObjectOfClass:[NSString class] forKey:@"_teacher"];
        _location = [coder decodeObjectOfClass:[NSDate class] forKey:@"_location"];
    }
    return self;
}

@end
