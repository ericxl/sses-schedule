//
//  EditScheduleController.h
//  StStephenSchedule
//
//  Created by Eric Liang on 6/22/12.
//  Copyright (c) 2012 St.Stephen's. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MarqueeLabel.h"
#import "ClassPickerController.h"
@interface EditScheduleController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *editingTableView;
@property (strong, nonatomic) NSString *editingDayDisplayedName;

@property (strong, nonatomic) NSDictionary * editedDataFromPicker;
@property (strong, nonatomic) NSNumber *isEdited;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutletCollection(UIBarButtonItem) NSArray *letterButtons;

@property (weak, nonatomic) id delegate;

-(IBAction)dayButtonPressed:(UIButton *)sender;

@end
