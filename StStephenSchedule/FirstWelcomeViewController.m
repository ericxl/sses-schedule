//
//  FirstWelcomeViewController.m
//  StStephenSchedule
//
//  Created by Eric Liang on 11/18/12.
//  Copyright (c) 2012 St.Stephen's. All rights reserved.
//

#import "FirstWelcomeViewController.h"
#import "Common.h"
@interface FirstWelcomeViewController ()

@end

@implementation FirstWelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.IAmALabel.alpha = 0.0;
    self.IAmFromLabel.alpha = 0.0;
    self.schoolSectionSegment.alpha = 0.0;
    self.personTypeSegment.alpha = 0.0;
    self.schoolSectionSegment.enabled = NO;
    self.personTypeSegment.enabled = NO;
    self.doneButton.alpha = 0.0;
    
    [self.doneButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    self.doneButton.layer.borderWidth = 1.0;
    self.doneButton.layer.cornerRadius = 5;
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)screenTouched:(id)sender {
    [UIView beginAnimations:@"dismiss image" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    self.schoolSectionSegment.enabled = YES;
    self.personTypeSegment.enabled = YES;
    self.touchToStartLabel.alpha = 0.0;
    self.IAmALabel.alpha = 1.0;
    self.IAmFromLabel.alpha = 1.0;
    self.schoolSectionSegment.alpha = 1.0;
    self.personTypeSegment.alpha = 1.0;
    
    
    [UIView commitAnimations];
}
- (void)viewDidUnload {
    [self setSchoolSectionSegment:nil];
    [self setPersonTypeSegment:nil];
    [self setIAmALabel:nil];
    [self setTouchToStartLabel:nil];
    [self setIAmFromLabel:nil];
    [self setDoneButton:nil];
    [super viewDidUnload];
}
- (IBAction)schoolSectionValueChanged:(UISegmentedControl *)sender {
    if (self.personTypeSegment.selectedSegmentIndex >=0) {
        [UIView beginAnimations:@"show done" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.doneButton.alpha = 1.0;
        [UIView commitAnimations];
    }
}

- (IBAction)personTypeValueChanged:(UISegmentedControl *)sender {
    if (self.schoolSectionSegment.selectedSegmentIndex >=0) {
        [UIView beginAnimations:@"dismiss image" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.doneButton.alpha = 1.0;
        [UIView commitAnimations];
    }
}

- (IBAction)buttonPressed:(UIButton *)sender {
    SET_USER_DEFAULT([NSNumber numberWithInteger:self.schoolSectionSegment.selectedSegmentIndex], kUserDefaultsKeyUserTypeSchoolSection);
    SET_USER_DEFAULT([NSNumber numberWithInteger:self.personTypeSegment.selectedSegmentIndex], kUserDefaultsKeyUserTypePerson);

    NSDictionary *dictionary = GENERATE_USER_DATA_DICTIONARY([NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"emptyUserData" withExtension:@"plist"]], CURRENT_USER_NAME, SCHOOL_SECTION, PERSON_TYPE);
    NSString *filePath = PATH_FOR_DATA_OF_USER(CURRENT_USER_NAME);
    [dictionary writeToFile:filePath atomically:YES];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
