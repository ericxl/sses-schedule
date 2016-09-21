//
//  CustomFontLabel.m
//  StStephenSchedule
//
//  Created by Eric Liang on 8/2/12.
//  Copyright (c) 2012 St.Stephen's. All rights reserved.
//

#import "CustomFontLabel.h"

@implementation CustomFontLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    if (iPhone6) {
        self.font = [UIFont systemFontOfSize:self.font.pointSize -2];
    }
    else if (iPhone6Plus) {
        self.font = [UIFont systemFontOfSize:self.font.pointSize];
    }
    else {
        self.font = [UIFont systemFontOfSize:self.font.pointSize - 5];
    }
    
    


}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
