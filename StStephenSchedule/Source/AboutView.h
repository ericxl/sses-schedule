//
//  AboutView.h
//  StStephenSchedule
//
//  Created by Eric Liang on 7/23/12.
//  Copyright (c) 2012 St.Stephen's. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutView : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)IBOutlet UITableView *myTableView;

@end
