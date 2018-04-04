//
//  UsersViewController.h
//  StStephenSchedule
//
//  Created by Eric Liang on 11/17/12.
//  Copyright (c) 2012 St.Stephen's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
@interface UsersViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UISegmentedControl *personTypeSegment;
@property (strong, nonatomic) IBOutlet UISegmentedControl *userTypeSegment;
@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) NSMutableDictionary *userDataBuffer;
@property (strong, nonatomic) NSString *userNameHolder;
@property (weak, nonatomic) id delegate;
@property (strong, nonatomic) NSDictionary *passedData;

- (IBAction)viewTouched:(UIControl *)sender;

- (IBAction)userTypeSegmentValueChanged:(id)sender;
- (IBAction)personTypeSegmentValueChanged:(UISegmentedControl *)sender;
@end
