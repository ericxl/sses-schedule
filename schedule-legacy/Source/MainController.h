//
//  MainController.h
//  StStephenSchedule
//
//  Created by Eric Liang on 7/23/12.
//  Copyright (c) 2012 St.Stephen's. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSSClass;
@class SSSSchedule;

@interface MainController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic) NSString *displayingDay;
@property (strong, nonatomic) SSSSchedule *schedule;
@property (strong, nonatomic) SSSSchedule *editingSchedule;

@property (strong, nonatomic) SSSClass *editingClass;
@property (assign, nonatomic) BOOL editingIsAll;
@property (assign, nonatomic) BOOL shouldSave;
@property (strong, nonatomic) NSIndexPath *editedIndexPath;

@end
