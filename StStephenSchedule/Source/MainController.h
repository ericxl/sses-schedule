//
//  MainController.h
//  StStephenSchedule
//
//  Created by Eric Liang on 7/23/12.
//  Copyright (c) 2012 St.Stephen's. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EditScheduleController.h"

@interface MainController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *letterButtons;

@property (strong, nonatomic) NSString *dayDisplayedName;

-(IBAction)dayButtonPressed:(UIButton *)sender;
-(IBAction)editButtonPressed:(UIButton *)sender;

@end
