//
//  ClassPickerController.h
//  StStephenSchedule
//
//  Created by Eric Liang on 6/22/12.
//  Copyright (c) 2012 St.Stephen's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlowLabel.h"
#import "EditScheduleController.h"
@interface ClassPickerController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIActionSheetDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) IBOutlet UIPickerView *classesPicker;
@property (strong, nonatomic) IBOutlet UITextField *teacherTextField;
@property (strong, nonatomic) IBOutlet UITextField *locationTextField;

@property (strong, nonatomic) NSDictionary *classesData;
@property (strong, nonatomic) NSArray *classCategory;
@property (strong, nonatomic) NSArray *specifiedClasses;

@property (weak, nonatomic)id delegate;
@property (strong, nonatomic) NSDictionary *selectedData;

@property (strong, nonatomic) UISearchDisplayController *searchController;

@property (strong, nonatomic) IBOutlet GlowLabel *ericLogo;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (nonatomic) CGRect locationFrame;
@property (nonatomic) CGRect teacherFrame;
@property (nonatomic) CGRect locationNewFrame;
@property (nonatomic) CGRect teacherNewFrame;
-(IBAction)doneButtonPressed:(id)sender;
-(IBAction)teacherFieldDone:(id)sender;

@end
