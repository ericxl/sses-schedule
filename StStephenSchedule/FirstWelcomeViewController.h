//
//  FirstWelcomeViewController.h
//  StStephenSchedule
//
//  Created by Eric Liang on 11/18/12.
//  Copyright (c) 2012 St.Stephen's. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstWelcomeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISegmentedControl *schoolSectionSegment;

@property (strong, nonatomic) IBOutlet UIButton *doneButton;


- (IBAction)schoolSectionValueChanged:(UISegmentedControl *)sender;
- (IBAction)buttonPressed:(UIButton *)sender;
@end
