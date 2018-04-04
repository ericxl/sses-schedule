//
//  UIImage_draw_schedule.h
//  StStephenSchedule
//
//  Created by Eric Liang on 6/6/13.
//  Copyright (c) 2013 St.Stephen's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#pragma mark

@interface UIImage (drawText)
+(UIImage*) drawText:(NSString*) text
            withFont:(UIFont *)font
           withColor:(UIColor *) color
           withImage:(UIImage *) image
             atPoint:(CGPoint)   point;
+(UIImage *)createScheduleImageWithUserName:(NSString *) userName displayedName:(NSString *) displayedName;
@end

@implementation UIImage (drawText)

+(UIImage*) drawText:(NSString*) text
            withFont:(UIFont *)font
           withColor:(UIColor *) color
           withImage:(UIImage *) image
             atPoint:(CGPoint)   point
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(point.x, point.y - [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]].height / 2, image.size.width, image.size.height);
    [color set];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetShadowWithColor(ctx, CGSizeMake(0/5, 0.5), 1.0, [[UIColor grayColor] CGColor]);
    
    [text drawInRect:CGRectIntegral(rect) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(UIImage *)createScheduleImageWithUserName:(NSString *) userName displayedName:(NSString *) displayedName{
    
    NSDictionary *schedule;
    NSString *filePath = PATH_FOR_DATA_OF_USER(userName);
    if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        schedule = [[NSDictionary dictionaryWithContentsOfFile:filePath]objectForKey:kUserDataKeyUserSchedule];
    }
    else return nil;
    
    //
    UIImage *chart = [UIImage imageNamed:@"schedule_chart.png"];
    CGSize chartSize = chart.size;
    
    //draw image into context
    UIGraphicsBeginImageContextWithOptions(chartSize, NO, 0.0);
    [chart drawInRect:CGRectMake(0,0,chartSize.width,chartSize.height)];
    
    //get year
    NSDate *date = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [gregorian components:( NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    NSString *titleYear = nil;
    int year = (int)[dateComponents year];
    NSInteger month = [dateComponents month];
    if (month >= 6) {
        titleYear = [NSString stringWithFormat:@"%ld-%d",(long)year, year+1];
    }
    else {
        titleYear = [NSString stringWithFormat:@"%d-%d",year - 1, year];
    }
    
    //draw title
    NSString *title = [NSString stringWithFormat:@"%@'s Schedule of %@",displayedName,titleYear];
    if ([displayedName isEqualToString:@""] || !displayedName) {
        title = [NSString stringWithFormat:@"Schedule of %@",titleYear];
    }
    UIFont *titleFont = [UIFont fontWithName:@"Dumbledor 1" size:60];
    CGSize sizeOfTitle = [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:titleFont,NSFontAttributeName, nil]];
    CGPoint titlePoint = CGPointMake(chartSize.width/2 - sizeOfTitle.width/2, 50);
    CGRect rect = CGRectMake(titlePoint.x, titlePoint.y - [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:titleFont,NSFontAttributeName, nil]].height / 2, chartSize.width, chartSize.height);
    [[UIColor blackColor] set];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetShadowWithColor(ctx, CGSizeMake(0/5, 0.5), 1.0, [[UIColor grayColor] CGColor]);
    [title drawInRect:CGRectIntegral(rect) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:titleFont,NSFontAttributeName, nil]];
    
    
    //draw classes
    for (NSString *day in [schedule allKeys]) {
        for (NSString *period in [[schedule objectForKey:day]allKeys]) {
            //73 // 146
            NSDictionary *classInfo = [[schedule objectForKey:day] objectForKey:period];
            NSString *className = [classInfo objectForKey:@"className"];
            NSString *teacher = [classInfo objectForKey:@"teacherName"];
            
            int periodInt = [period intValue];
            int dayIntInterval = [day characterAtIndex:0] - 65;
            float pointX = 5 + 146 * dayIntInterval;
            float pointClassY = 188 + (periodInt - 1) * 74;
            UIFont *classFont = [UIFont fontWithName:@"Dumbledor 1" size:22];
            if (![teacher isEqualToString:@""]) {
                
                float pointTeacherY = 218 + (periodInt - 1) * 74;
                UIFont *teacherFont = [UIFont fontWithName:@"Dumbledor 1" size:16];
                
                //draw teacher
                CGPoint teacherPoint = CGPointMake(pointX,pointTeacherY);
                CGRect teacher_rect = CGRectMake(teacherPoint.x, teacherPoint.y - [teacher sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:teacherFont,NSFontAttributeName, nil]].height / 2, chartSize.width, chartSize.height);
                CGContextSetShadowWithColor(ctx, CGSizeMake(0/5, 0.5), 1.0, [[UIColor grayColor] CGColor]);
                [teacher drawInRect:CGRectIntegral(teacher_rect) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:teacherFont,NSFontAttributeName, nil]];
                
                //draw class
                CGPoint classPoint = CGPointMake(pointX,pointClassY);
                CGRect class_rect = CGRectMake(classPoint.x, classPoint.y - [className sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:teacherFont,NSFontAttributeName, nil]].height / 2, chartSize.width, chartSize.height);
                CGContextSetShadowWithColor(ctx, CGSizeMake(0/5, 0.5), 1.0, [[UIColor grayColor] CGColor]);
                [className drawInRect:CGRectIntegral(class_rect) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:classFont,NSFontAttributeName, nil]];
            }
            else {
                if ([className isEqualToString:@"OFF"]) {
                    [[UIColor grayColor]set];
                }
                
                pointClassY = pointClassY + 10;
                
                //draw class
                CGPoint classPoint = CGPointMake(pointX,pointClassY);
                CGRect class_rect = CGRectMake(classPoint.x, classPoint.y - [className sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:classFont,NSFontAttributeName, nil]].height / 2, chartSize.width, chartSize.height);
                CGContextSetShadowWithColor(ctx, CGSizeMake(0/5, 0.5), 1.0, [[UIColor grayColor] CGColor]);
                [className drawInRect:CGRectIntegral(class_rect) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:classFont,NSFontAttributeName, nil]];
                
                [[UIColor blackColor]set];
            }
        }
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
}
@end

