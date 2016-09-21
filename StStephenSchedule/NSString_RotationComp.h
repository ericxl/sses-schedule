//
//  NSString_RotationComp.h
//  StStephenSchedule
//
//  Created by Eric Liang on 9/12/12.
//  Copyright (c) 2012 St.Stephen's. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (InRange)
-(BOOL)isABCDEFG;
@end


@implementation NSString (InRange)

-(BOOL) isABCDEFG {
    BOOL reV = NO;
    if ([self length]>1) {
        return reV;
    }
    if ([self isEqualToString:@"A"]) {
        reV=YES;
    }
    if ([self isEqualToString:@"B"]) {
        reV=YES;
    }
    if ([self isEqualToString:@"C"]) {
        reV=YES;
    }
    if ([self isEqualToString:@"D"]) {
        reV=YES;
    }
    if ([self isEqualToString:@"E"]) {
        reV=YES;
    }
    if ([self isEqualToString:@"F"]) {
        reV=YES;
    }
    if ([self isEqualToString:@"G"]) {
        reV=YES;
    }
    return reV;
}

@end
