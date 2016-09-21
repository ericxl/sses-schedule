//
//  DailyCalenderViewController.h
//  StStephenSchedule
//
//  Created by Eric Liang on 8/2/12.
//  Copyright (c) 2012 St.Stephen's. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyCalenderViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISegmentedControl *upper_middle_segment;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *upperContentView;
@property (nonatomic, strong) IBOutlet UIView *middleContentView;

@end
