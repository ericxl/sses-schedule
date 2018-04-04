//
//  SettingView.h
//  StStephenSchedule
//
//  Created by Eric Liang on 11/17/12.
//  Copyright (c) 2012 St.Stephen's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>


@interface SettingView : UIViewController<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong)IBOutlet UITableView *myTableView;
@property (nonatomic, strong)NSMutableArray *users;
@property (nonatomic, strong)NSIndexPath *lastIndexPath;

@property (nonatomic, strong)UIBarButtonItem *addBarItem;
@property (nonatomic, strong)UIBarButtonItem *backBarItem;
@property (nonatomic, strong)UIBarButtonItem *doneBarItem;
@property (nonatomic, strong)UIBarButtonItem *editBarItem;

@end
