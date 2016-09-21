//
//  ButtonView.m
//  StStephenSchedule
//
//  Created by Eric Liang on 2/4/14.
//  Copyright (c) 2014 St.Stephen's. All rights reserved.
//

#import "ButtonView.h"

@implementation ButtonView



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //// General Declarations
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* buttonColorDark = [UIColor colorWithRed: 0.439 green: 0.004 blue: 0 alpha: 1];
    UIColor* buttonColorLight = [UIColor colorWithRed: 1 green: 0 blue: 0 alpha: 1];
    UIColor* innerGlowColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.502];
    UIColor* shadowColor2 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.51];
    
    //// Gradient Declarations
    NSArray* gradientColors = [NSArray arrayWithObjects:
                               (id)buttonColorLight.CGColor,
                               (id)buttonColorDark.CGColor, nil];
    CGFloat gradientLocations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    
    //// Shadow Declarations
    UIColor* outerGlow = innerGlowColor;
    CGSize outerGlowOffset = CGSizeMake(0.1, -0.1);
    CGFloat outerGlowBlurRadius = 3;
    UIColor* highlight = shadowColor2;
    CGSize highlightOffset = CGSizeMake(0.1, 2.1);
    CGFloat highlightBlurRadius = 2;
    
    //// Frames
    CGRect frame = rect;
    
    
    //// Group
    {
        //// Rounded Rectangle Drawing
        CGRect roundedRectangleRect = CGRectMake(CGRectGetMinX(frame) + 4, CGRectGetMinY(frame) + 4, CGRectGetWidth(frame) - 7, floor((CGRectGetHeight(frame) - 4) * 0.91304 + 0.5));
        UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: roundedRectangleRect cornerRadius: 6];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, outerGlowOffset, outerGlowBlurRadius, outerGlow.CGColor);
        CGContextBeginTransparencyLayer(context, NULL);
        [roundedRectanglePath addClip];
        CGContextDrawLinearGradient(context, gradient,
                                    CGPointMake(CGRectGetMidX(roundedRectangleRect), CGRectGetMinY(roundedRectangleRect)),
                                    CGPointMake(CGRectGetMidX(roundedRectangleRect), CGRectGetMaxY(roundedRectangleRect)),
                                    0);
        CGContextEndTransparencyLayer(context);
        
        ////// Rounded Rectangle Inner Shadow
        CGRect roundedRectangleBorderRect = CGRectInset([roundedRectanglePath bounds], -highlightBlurRadius, -highlightBlurRadius);
        roundedRectangleBorderRect = CGRectOffset(roundedRectangleBorderRect, -highlightOffset.width, -highlightOffset.height);
        roundedRectangleBorderRect = CGRectInset(CGRectUnion(roundedRectangleBorderRect, [roundedRectanglePath bounds]), -1, -1);
        
        UIBezierPath* roundedRectangleNegativePath = [UIBezierPath bezierPathWithRect: roundedRectangleBorderRect];
        [roundedRectangleNegativePath appendPath: roundedRectanglePath];
        roundedRectangleNegativePath.usesEvenOddFillRule = YES;
        
        CGContextSaveGState(context);
        {
            CGFloat xOffset = highlightOffset.width + round(roundedRectangleBorderRect.size.width);
            CGFloat yOffset = highlightOffset.height;
            CGContextSetShadowWithColor(context,
                                        CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                        highlightBlurRadius,
                                        highlight.CGColor);
            
            [roundedRectanglePath addClip];
            CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(roundedRectangleBorderRect.size.width), 0);
            [roundedRectangleNegativePath applyTransform: transform];
            [[UIColor grayColor] setFill];
            [roundedRectangleNegativePath fill];
        }
        CGContextRestoreGState(context);
        
        CGContextRestoreGState(context);
        
        [[UIColor blackColor] setStroke];
        roundedRectanglePath.lineWidth = 2;
        [roundedRectanglePath stroke];
    }
    
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    

}


@end
