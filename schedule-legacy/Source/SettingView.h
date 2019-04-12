//
//  SettingView.h
//  StStephenSchedule
//
//  Created by Eric Liang on 11/17/12.
//  Copyright (c) 2012 St.Stephen's. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingView : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *users;
@property (nonatomic, strong)IBOutlet UITableView *myTableView;

@end
