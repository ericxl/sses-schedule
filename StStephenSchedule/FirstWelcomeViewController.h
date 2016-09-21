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
@property (strong, nonatomic) IBOutlet UISegmentedControl *personTypeSegment;
@property (strong, nonatomic) IBOutlet UILabel *IAmALabel;
@property (strong, nonatomic) IBOutlet UILabel *touchToStartLabel;
@property (strong, nonatomic) IBOutlet UILabel *IAmFromLabel;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;


- (IBAction)schoolSectionValueChanged:(UISegmentedControl *)sender;
- (IBAction)personTypeValueChanged:(UISegmentedControl *)sender;
- (IBAction)buttonPressed:(UIButton *)sender;
@end
