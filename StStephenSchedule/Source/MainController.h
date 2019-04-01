//
//  MainController.h
//  StStephenSchedule
//
//  Created by Eric Liang on 7/23/12.
//  Copyright (c) 2012 St.Stephen's. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSSClass;

@interface MainController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *letterButtons;

-(IBAction)dayButtonPressed:(UIButton *)sender;

@property (strong, nonatomic) SSSClass *editingClass;
@property (assign, nonatomic) BOOL editingIsAll;
@property (assign, nonatomic) BOOL shouldSave;
@property (strong, nonatomic) NSIndexPath *editedIndexPath;

@end
