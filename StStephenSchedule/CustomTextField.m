//
//  CustomTextField.m
//  StStephenSchedule
//
//  Created by Eric Liang on 8/6/12.
//  Copyright (c) 2012 St.Stephen's. All rights reserved.
//

#import "CustomTextField.h"
@implementation CustomTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)awakeFromNib {
    [super awakeFromNib];
    self.font = [UIFont systemFontOfSize:self.font.pointSize];

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
