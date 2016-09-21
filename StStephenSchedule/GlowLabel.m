//
//  GlowLabel.m
//  GlowLabel
//
//  Created by Bill on 12-9-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GlowLabel.h"

@implementation GlowLabel

@synthesize redValue;
@synthesize greenValue;
@synthesize blueValue;
@synthesize size;

-(id) initWithFrame: (CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        redValue = 0.0f;
        greenValue = 0.50f;
        blueValue = 1.0f;
        size=20.0f;
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    self.font = [UIFont fontWithName:@"Dumbledor 1" size:self.font.pointSize+4];
}

-(void) drawTextInRect: (CGRect)rect {
	CGSize textShadowOffest = CGSizeMake(0, 0);
	CGFloat textColorValues[] = {redValue, greenValue, blueValue, 1.0};
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSaveGState(ctx);
	
	CGContextSetShadow(ctx, textShadowOffest, size);
	CGColorSpaceRef textColorSpace = CGColorSpaceCreateDeviceRGB();
	CGColorRef textColor = CGColorCreate(textColorSpace, textColorValues);
	CGContextSetShadowWithColor(ctx, textShadowOffest, size, textColor);
	
	[super drawTextInRect:rect];
	
	CGColorRelease(textColor);
	CGColorSpaceRelease(textColorSpace);
	
	CGContextRestoreGState(ctx);
}


@end
