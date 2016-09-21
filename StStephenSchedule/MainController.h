//
//  MainController.h
//  StStephenSchedule
//
//  Created by Eric Liang on 7/23/12.
//  Copyright (c) 2012 St.Stephen's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "QuadCurveMenu.h"
#import "QuadCurveMenuItem.h"
#import "EditScheduleController.h"
@class MarqueeLabel;
@interface MainController : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate,UIAlertViewDelegate,QuadCurveMenuDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>



//@property (strong, nonatomic) IBOutlet UINavigationItem *scheduleNavigationItem;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSDictionary *scheduleData;
@property (strong, nonatomic) NSDictionary *displayedSchedule;
@property (strong, nonatomic) NSString *dayDisplayedName;
@property (strong, nonatomic) QuadCurveMenu *menu;
@property (strong, nonatomic) UIImageView *dayBanner;
@property (strong, nonatomic) MarqueeLabel *marqueeLabel;
@property (strong, nonatomic) IBOutletCollection(UIBarButtonItem) NSArray *letterDayButtons;
-(IBAction)dayButtonPressed:(UIButton *)sender;
-(IBAction)editButtonPressed:(UIButton *)sender;

-(void)reloadUserData;
@end
