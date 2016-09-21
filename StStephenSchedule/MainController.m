//
//  MainController.m
//  StStephenSchedule
//
//  Created by Eric Liang on 7/23/12.
//  Copyright (c) 2012 St.Stephen's. All rights reserved.
//

#import "MainController.h"
#import "CustomFontLabel.h"
#import "NSString_RotationComp.h"
#import "AboutView.h"
#import "DailyCalenderViewController.h"
#import "SettingView.h"
//#import "MarqueeLabel.h"
#import "Common.h"

#define isWeekend ([self dateOfToday] == 1 || [self dateOfToday] == 7)
#define isUpper ([[[NSUserDefaults standardUserDefaults]objectForKey:@"userTypeSchoolSection"]integerValue] == kUserTypeSchoolSectionUpper)

#define kAlertTagUpdateReminder 21
#define kAlertTagReviewReminder 20
#define kAleatTagYoutube 19




@interface MainController ()

@end


UIImageView *firstlaunchImage;
@implementation MainController
@synthesize toolbar;
@synthesize displayedSchedule;
@synthesize scheduleData;
@synthesize dayDisplayedName;
@synthesize myTableView;
@synthesize menu;
@synthesize dayBanner;
@synthesize marqueeLabel;

BOOL canDisplayTut;
/*
static BOOL isiPhone5(){
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568.0);
}
 */

-(NSString * )getLetterDayFromApache {
    NSURL *url = [NSURL URLWithString:LETTER_DAY_URL];
    NSError *error = nil;
    NSData *fetchedString = [NSData dataWithContentsOfURL:url options:0 error:&error];
    NSString *content = nil;
    NSString *result = nil;
    if(!error && fetchedString && [fetchedString length] > 0) {
        content = [[NSString alloc]initWithData:fetchedString encoding:NSASCIIStringEncoding];
        char dayLetterChar=[content characterAtIndex:[content length]-4];
        NSString *dayLetter=[NSString stringWithFormat:@"%c",dayLetterChar];
        if ([dayLetter isABCDEFG]) {
            result = dayLetter;
        }
    }
    return result;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *dayString=[self getLetterDayFromApache];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (dayString!=nil) {
                self.dayDisplayedName=dayString;
                self.displayedSchedule=[self.scheduleData objectForKey:dayString];
                [dayBanner setFrame:[self dayBannerFrameFromDay:self.dayDisplayedName]];
                [dayBanner setHidden:NO];
            }
            else {
                [dayBanner setHidden:YES];
            }
        });
    });
    self.displayedSchedule = [self.scheduleData objectForKey:dayDisplayedName];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    canDisplayTut = NO;
    
    //load user data
    
    NSString *filePath = PATH_FOR_DATA_OF_USER(CURRENT_USER_NAME);
    if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        self.scheduleData=[[[NSDictionary alloc]initWithContentsOfFile:filePath]objectForKey:kUserDataKeyUserSchedule];
    }
    else {
        if ([[NSFileManager defaultManager]fileExistsAtPath:PATH_FOR_FILE_IN_DOCUMENT_DOMAIN(kPrimeUserDataFileName)]) {
            self.scheduleData = [[NSDictionary alloc]initWithContentsOfFile:PATH_FOR_FILE_IN_DOCUMENT_DOMAIN(kPrimeUserDataFileName)];
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:SCHOOL_SECTION],kUserDataKeyUserSchoolSection,[NSNumber numberWithInteger:PERSON_TYPE],kUserDataKeyUserPersonType,CURRENT_USER_NAME,kUserDataKeyUserName,self.scheduleData,kUserDataKeyUserSchedule, nil];
            [dictionary writeToFile:filePath atomically:YES];
            NSError *error = nil;
            [[NSFileManager defaultManager]removeItemAtPath:PATH_FOR_FILE_IN_DOCUMENT_DOMAIN(kPrimeUserDataFileName) error:&error];
        }
        else {
            self.scheduleData=[NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"emptyUserData" withExtension:@"plist"]];
            NSDictionary *dictionary = GENERATE_USER_DATA_DICTIONARY(self.scheduleData, CURRENT_USER_NAME, SCHOOL_SECTION, PERSON_TYPE);
            [dictionary writeToFile:filePath atomically:YES];
        }

    }
    if (iPhone6) {
        for (UIBarButtonItem *button in self.letterDayButtons) {
            [button setWidth:41];
        }
    }
    else if (iPhone6Plus ) {
        for (UIBarButtonItem *button in self.letterDayButtons) {
            [button setWidth:45.5];
        }
    }
    else {
        for (UIBarButtonItem *button in self.letterDayButtons) {
            [button setWidth:34];
        }
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
    
    [self setDayDisplayedName:@"A"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *dayString=[self getLetterDayFromApache];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (dayString!=nil) {
                self.dayDisplayedName = dayString;
                self.displayedSchedule = [self.scheduleData objectForKey:dayString];
                [dayBanner setFrame:[self dayBannerFrameFromDay:self.dayDisplayedName]];
                [dayBanner setHidden:NO];
            }
            else {
                [dayBanner setHidden:YES];
            }
        });
    });
    self.displayedSchedule = [self.scheduleData objectForKey:dayDisplayedName];
    
    dayBanner = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"day_banner.png"]];
    [dayBanner setFrame: CGRectMake(15, 6 , 34, 34)];
    [dayBanner setHidden:YES];
    [self.view insertSubview:dayBanner atIndex:2];

    
    //add quadcurvemenu
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
    
    //UIImage *starImage = [UIImage imageNamed:@"icon-star.png"];
    
    QuadCurveMenuItem *starMenuItem1 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:[UIImage imageNamed:@"icon-about.png"]
                                                        highlightedContentImage:[UIImage imageNamed:@"icon-about-high.png"]];
    QuadCurveMenuItem *starMenuItem2 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:[UIImage imageNamed:@"icon-calendar.png"]
                                                        highlightedContentImage:[UIImage imageNamed:@"icon-calendar-high.png"]];
    QuadCurveMenuItem *starMenuItem3 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:[UIImage imageNamed:@"icon-setting.png"]
                                                        highlightedContentImage:[UIImage imageNamed:@"icon-setting-high.png"]];
    QuadCurveMenuItem *starMenuItem4 = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:[UIImage imageNamed:@"icon-share.png"]
                                                        highlightedContentImage:[UIImage imageNamed:@"icon-share-high.png"]];

    
    NSArray *menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4, nil];
    CGFloat yPoint = -72.0f;
    if (iPhone5) {
        yPoint = 5.0f;
    }
    else if (iPhone6) {
        yPoint = 95.0f;
    }
    else if (iPhone6Plus) {
        yPoint = 160.0f;
    }
    CGRect qcButtonRect=CGRectMake(self.view.bounds.size.width * 0.83, yPoint, 200, 200);

    menu = [[QuadCurveMenu alloc] initWithFrame:qcButtonRect menus:menus];
    [self.menu setDelegate:self];
    [self.view addSubview:self.menu];
   
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURL *url = [NSURL URLWithString:VERSION_NUMBER_URL];
        NSError *error = nil;
        NSData *fetchedString = [NSData dataWithContentsOfURL:url options:0 error:&error];
        NSString *versionString = nil;
        if(!error && fetchedString && [fetchedString length] > 0) {
            versionString = [[NSString alloc]initWithData:fetchedString encoding:NSASCIIStringEncoding];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (versionString!=nil) {
                NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
                if (![versionString isEqualToString:currentVersion] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"updateRemindTimes"]integerValue]==0) {
                    int value = (int)[[[NSUserDefaults standardUserDefaults] objectForKey:@"updateRemindTimes"]integerValue] + 1;
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:value]forKey:@"updateRemindTimes"];
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Update" message:[NSString stringWithFormat: @"New version %@ is available on the App Store",versionString] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Download", nil];
                    [alert setTag:kAlertTagUpdateReminder];
                    [alert show];
                }
                else if ([versionString isEqualToString:currentVersion]) {
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0]forKey:@"updateRemindTimes"];
                }
            }
        });
        
    });
    
    
    if (![[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] isEqualToString:GET_USER_DEFAULT(kUserDefaultsKeyOldVersion)]) {
        //update detected
        SET_USER_DEFAULT([NSNumber numberWithBool:NO], kUserDefaultsKeyNewFeaturePageShowed);
    }
    
    /*
    if ([GET_USER_DEFAULT(kUserDefaultsKeyLaunchTimesSinceNewVersion) integerValue]>=1 && ![GET_USER_DEFAULT(kUserDefaultsKeyReviewRequested)boolValue]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Like this app?" message:@"Please give a review on the App Store. Thank you!" delegate:self cancelButtonTitle:@"Never" otherButtonTitles:@"OK", @"Remind me later", nil];
        [alert setTag:kAlertTagReviewReminder];
        [alert show];
    }
    */
    
}
- (void)quadCurveMenu:(QuadCurveMenu *)menu didSelectIndex:(NSInteger)idx {
    switch (idx) {
        case 0:
        {
            [self performSelector:@selector(quadAboutButtonClicked) withObject:nil afterDelay:0.2];
        }
            break;
        case 1:
        {
            [self performSelector:@selector(quadDailyButtonClicked) withObject:nil afterDelay:0.2];
        }
            break;
        case 2:
        {
            [self performSelector:@selector(quadSettingButtonClicked) withObject:nil afterDelay:0.2];
        }
            break;
        
        case 3:
        {
            [self performSelector:@selector(quadShareButtonClicked) withObject:nil afterDelay:0.1];
        }
            break;
    }
}

-(void) quadAboutButtonClicked {
    AboutView *aboutController = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutView"];
    [self.navigationController pushViewController:aboutController animated:YES];
}
-(void) quadDailyButtonClicked {
    DailyCalenderViewController *dailyController = [self.storyboard instantiateViewControllerWithIdentifier:@"DailyCalenderView"];
    [self.navigationController pushViewController:dailyController animated:YES];
}
-(void) quadShareButtonClicked {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"Share your schedule, your schedule image will be copied to pasteboard", nil)  delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Email",nil) , NSLocalizedString(@"Message",nil), @"Copy to Photo Library", nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [actionSheet showInView:self.view];
}
-(void) quadSettingButtonClicked {
    SettingView *settingView = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingView"];
    [self.navigationController pushViewController:settingView animated:YES];

}

-(void)dismissTutorialImage{
    [UIView beginAnimations:@"dismiss image" context:nil];
    [UIView setAnimationDuration:1.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelay:4.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    CGRect thirdRect=CGRectMake(320, 0, 150, 100);
    [firstlaunchImage setFrame:thirdRect];
    [firstlaunchImage setAlpha:0.0];
    [UIView commitAnimations];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:kUserDefaultsKeyFirstLaunch];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.toolbar=nil;
    self.scheduleData=nil;
    self.displayedSchedule=nil;
    self.dayDisplayedName=nil;
    self.myTableView=nil;
    self.menu=nil;
    self.dayBanner = nil;
    self.letterDayButtons = nil;
    //self.marqueeLabel = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];

    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ScheduleCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    
    NSInteger row=[indexPath row]+1;
    NSString *periodnumber=[NSString stringWithFormat:@"%ldth",(long)row];
    if (row==1) {
        periodnumber=[NSString stringWithFormat:@"%ldst",(long)row];
    }
    if (row==2) {
        periodnumber=[NSString stringWithFormat:@"%ldnd",(long)row];
    }
    if (row==3) {
        periodnumber=[NSString stringWithFormat:@"%ldrd",(long)row];
    }
    
    NSString *periodNumberString=[NSString stringWithFormat:@"%ld",(long)row];
    NSDictionary *dict=[displayedSchedule objectForKey:periodNumberString];
    
    UILabel *periodLabel=(UILabel *)[cell viewWithTag:1];
    UILabel *classNameLabel=(UILabel *)[cell viewWithTag:2];
    UILabel *teacherNameLabel=(UILabel *)[cell viewWithTag:3];
    UILabel *locationNameLabel=(UILabel *)[cell viewWithTag:4];
    periodLabel.text=periodnumber;
    classNameLabel.text=[dict objectForKey:@"className"];
    teacherNameLabel.text=[dict objectForKey:@"teacherName"];
    locationNameLabel.text=[dict objectForKey:@"locationName"];
    
    if ([classNameLabel.text isEqualToString:@"OFF"]) {
        classNameLabel.textColor=[UIColor lightGrayColor];
        teacherNameLabel.text=@"";
        locationNameLabel.text=@"";
    }
    else {
        classNameLabel.textColor=[UIColor blackColor];
    }
    // Configure the cell...
    UIButton *clockButton=(UIButton *)[cell viewWithTag:5];
    [clockButton setImage:[UIImage imageNamed:@"btn_clock_normal.png"] forState:UIControlStateNormal];
    [clockButton setImage:[UIImage imageNamed:@"btn_clock_pressed.png"] forState:UIControlStateHighlighted];
    [cell addSubview:clockButton];
    [clockButton addTarget:self action:@selector(clockButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (iPhone5) {
        return 57.5;
    }
    else if (iPhone6) {
        return 70;
    }
    else if (iPhone6Plus) {
        return 78.5;
    }
    else return 46.5;
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}
-(void)reloadUserData {
    NSString *filePath = PATH_FOR_DATA_OF_USER(CURRENT_USER_NAME);
    if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        self.scheduleData=[[[NSDictionary alloc]initWithContentsOfFile:filePath]objectForKey:kUserDataKeyUserSchedule];
    }
}
-(void)setDayDisplayedName:(NSString *)aName {
    if (![aName isEqual:self.dayDisplayedName]) {
        dayDisplayedName = aName;
        if ([CURRENT_USER_NAME isEqualToString:@"Me"]) {
            //self.scheduleNavigationItem.title=[NSString stringWithFormat:NSLocalizedString(@"My %@ Day", nil),dayDisplayedName];
            self.title=[NSString stringWithFormat:NSLocalizedString(@"My %@ Day", nil),dayDisplayedName];
        }
        else {
            //self.scheduleNavigationItem.title=[NSString stringWithFormat:@"%@'s %@ Day",CURRENT_USER_NAME,dayDisplayedName];
            self.title=[NSString stringWithFormat:@"%@'s %@ Day",CURRENT_USER_NAME,dayDisplayedName];

        }
        self.displayedSchedule=[scheduleData objectForKey:aName];
        [self.myTableView reloadData];
    }
}
-(void)viewDidAppear:(BOOL)animated {
    if([[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsKeyFirstLaunch] && !canDisplayTut) {
        [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"FirstWelcomeViewController"] animated:YES completion:nil];
        canDisplayTut = YES;
        return;
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsKeyFirstLaunch]  &&  canDisplayTut ) {
        //first launch
        firstlaunchImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"first_launch_tutorial.png"]];
        CGRect firstRect=CGRectMake(0, 0, 150, 100);
        [firstlaunchImage setFrame:firstRect];
        [firstlaunchImage setAlpha:0];
        [self.view addSubview:firstlaunchImage];
        
        [UIView beginAnimations:@"show image" context:nil];
        [UIView setAnimationDuration:1.3];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(dismissTutorialImage)];
        
        CGRect secondRect=CGRectMake(170, 0, 150, 100);
        [firstlaunchImage setFrame:secondRect];
        [firstlaunchImage setAlpha:1.0];
        [UIView commitAnimations];
        
    }
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated {
    [self reloadUserData];
    self.displayedSchedule = [self.scheduleData objectForKey:self.dayDisplayedName];
    [myTableView reloadData];
    
    if ([CURRENT_USER_NAME isEqualToString:@"Me"]) {
        self.title=[NSString stringWithFormat:NSLocalizedString(@"My %@ Day", nil),dayDisplayedName];
    }
    else {
        self.title=[NSString stringWithFormat:@"%@'s %@ Day",CURRENT_USER_NAME,dayDisplayedName];
        
    }
    
    [super viewWillAppear:animated];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self mailButtonPressed];
    }
    else if (buttonIndex == 1){
        [self smsButtonPressed];
    }
    else if (buttonIndex == 2) {
        __block UIImage *newImage = nil;
        __block UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Generating schedule image, please wait..." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSString *user_first_name = [[CURRENT_USER_NAME componentsSeparatedByString:@" "] objectAtIndex:0];
            if ([user_first_name isEqualToString:@"Me"]) {
                user_first_name = @"";
            }
            newImage = [UIImage createScheduleImageWithUserName:CURRENT_USER_NAME displayedName:user_first_name];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil);

                
                [alert dismissWithClickedButtonIndex:-1 animated:YES];
                
                UIAlertView *alertB = [[UIAlertView alloc]initWithTitle:@"Image copied to Photos" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [alertB show];
                [self performSelector:@selector(dismissAlertB:) withObject:alertB afterDelay:2.0];
                
                
            });
        });
    }
}
-(void)dismissAlertB:(UIAlertView *)alert {
    [alert dismissWithClickedButtonIndex:-1 animated:NO];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark - Table view delegate

-(IBAction)editButtonPressed:(UIButton *)sender{
    EditScheduleController *editScheduleController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditScheduleControllerID"];
    
    
    [editScheduleController setValue:self forKey:@"delegate"];
    [editScheduleController setValue:dayDisplayedName forKey:@"editingDayDisplayedName"];
    
    
    [self.navigationController pushViewController:editScheduleController animated:YES];
    
    
    
    //[self performSegueWithIdentifier:@"segue.push.edit" sender:sender];
}
-(IBAction)dayButtonPressed:(UIButton *)sender {
    NSString *day;
    switch (sender.tag) {
        case 1:
            day=@"A";
            break;
        case 2:
            day=@"B";
            break;
        case 3:
            day=@"C";
            break;
        case 4:
            day=@"D";
            break;
        case 5:
            day=@"E";
            break;
        case 6:
            day=@"F";
            break;
        case 7:
            day=@"G";
            break;
    }
    self.dayDisplayedName=day;
}
-(void)smsButtonPressed {
    __block UIImage *newImage = nil;
    __block UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Generating schedule image, please wait..." message:@"When done, tap PASTE to copy image into textfield" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *user_first_name = [[CURRENT_USER_NAME componentsSeparatedByString:@" "] objectAtIndex:0];
        if ([user_first_name isEqualToString:@"Me"]) {
            user_first_name = @"";
        }
        newImage = [UIImage createScheduleImageWithUserName:CURRENT_USER_NAME displayedName:user_first_name];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
            
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.persistent = YES;
            pasteboard.image = newImage;
            
            [alert dismissWithClickedButtonIndex:-1 animated:NO];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms:"]];
            
        });
    });
    
}
-(void)mailButtonPressed {
    __block UIImage *newImage = nil;
    __block UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Generating schedule image, please wait..." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *user_first_name = [[CURRENT_USER_NAME componentsSeparatedByString:@" "] objectAtIndex:0];
        if ([user_first_name isEqualToString:@"Me"]) {
            user_first_name = @"";
        }
        newImage = [UIImage createScheduleImageWithUserName:CURRENT_USER_NAME displayedName:user_first_name];
        NSData *data = UIImagePNGRepresentation (newImage);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
            
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.persistent = YES;
            pasteboard.image = newImage;
            
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self;
            [picker setSubject:@"My Schedule"];
            [picker addAttachmentData: data mimeType:@"image/png" fileName:@"schedule"];
            NSString *emailBody = @"Here is my schedule";
            [picker setMessageBody:emailBody isHTML:NO];
            [self presentViewController:picker animated:YES completion:nil];
            
            [alert dismissWithClickedButtonIndex:-1 animated:NO];
            
            
            
        });
    });
}
-(void)sendMail: (NSString *)bodyOfMail {
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    
    if ([MFMailComposeViewController canSendMail]) {
        controller.mailComposeDelegate = self;
        [controller setSubject:@"My Schedule"];
        [controller setMessageBody:bodyOfMail isHTML:NO];
        if (controller) [self presentViewController:controller animated:YES completion:nil];
    }
}
- (void)sendSMS:(NSString *)bodyOfMessage //recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    
    if([MFMessageComposeViewController canSendText])
        
    {
        
        controller.body = bodyOfMessage;   
        
        //controller.recipients = recipients;
        
        [controller setMessageComposeDelegate:self];
        
        [self presentViewController:controller animated:YES completion:nil];
        
    }
}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)clockButtonPressed :(UIButton *)sender {
    NSIndexPath *indexPath = [self.myTableView indexPathForCell:(UITableViewCell *)[sender superview]];
    if (SYSTEM_VERSION_LESS_THAN(@"8.0") && SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        indexPath = [self.myTableView indexPathForCell:(UITableViewCell *)[(UITableViewCell *)[sender superview]superview]];
    }

    NSInteger periodNumber = [indexPath row] + 1;
    NSString *title;
    NSString *text;
    
    switch (periodNumber) {
        case 1:
        {
            if (isUpper) {
                switch ([self dateOfToday]) {
                    case 7:
                    case 1:
                    {
                        text = @"Mon, Tues, Thur, Fri:\n8:00-9:00\nWednesday:\n8:40-9:25";
                        title = @"1st Period";
                        
                    }
                        break;
                        
                    case 4:
                    {
                        text = @"8:40-9:25";
                        title =@"1st Period";
                       
                    }
                        break;
                    case 2:
                    case 3:
                    case 5:
                    case 6:
                    {
                        text = @"8:00-9:00";
                        title = @"1st Period";
                    }
                        break;
                }
            }
            else { // middle
                switch ([self dateOfToday]) {
                    case 7:
                    case 1:
                    {
                        text = @"Mon, Tues, Thur, Fri:\n8:20-9:20\nWednesday:\n8:40-9:25";
                        title = @"1st Period";
                        
                    }
                        break;
                        
                    case 4:
                    {
                        text = @"8:40-9:25";
                        title = @"1st Period";
                    }
                        break;
                    case 2:
                    case 3:
                    case 5:
                    case 6:
                    {
                        text = @"8:20-9:20";
                        title = @"1st Period";
                    }
                        break;
                }
            }
        }
            break;
        case 2:
        {
            if (isUpper) {
                switch ([self dateOfToday]) {
                    case 7:
                    case 1:
                    {
                        text = @"Mon, Tues, Thur, Fri:\n9:40-10:25\nWednesday:\n9:50-10:35";
                        title = @"2nd Period";
                    }
                        break;
                        
                    case 4:
                    {
                        text = @"9:50-10:35";
                        title = @"2nd Period";
                    }
                        break;
                    case 2:
                    case 3:
                    case 5:
                    case 6:
                    {
                        text = @"9:40-10:25";
                        title = @"2nd Period";
                    }
                        break;
                }
            }
            else { // middle
                switch ([self dateOfToday]) {
                    case 7:
                    case 1:
                    {
                        text = @"Mon, Tues, Thur, Fri:\n9:25-10:25\nWednesday:\n9:50-10:35";
                        title = @"2nd Period";
                    }
                        break;
                        
                    case 4:
                    {
                        text = @"9:50-10:35";
                        title = @"2nd Period";
                    }
                        break;
                    case 2:
                    case 3:
                    case 5:
                    case 6:
                    {
                        text = @"9:25-10:25";
                        title = @"2nd Period";
                    }
                        break;
                }
            }
        }
            break;
        case 3:
        {
            switch ([self dateOfToday]) {
                case 7:
                case 1:
                {
                    text = @"Mon, Tues, Thur, Fri:\n10:30-11:15\nWednesday:\n10:40-11:25";
                    title = @"3rd Period";
                    
                }
                    break;
                    
                case 4:
                {
                    text = @"10:40-11:25";
                    title = @"3rd Period";
                }
                    break;
                case 2:
                case 3:
                case 5:
                case 6:
                {
                    text = @"10:30-11:15";
                    title = @"3rd Period";
                }
                    break;
            }
            
            
        }
            break;
        case 4:
        {
            switch ([self dateOfToday]) {
                case 1:
                case 7:
                {
                    text = @"Mon, Tues, Thur, Fri:\n11:20-12:20\nWednesday:\n11:30-12:15";
                    title = @"4th Period";
                }
                    break;
                    
                case 4:
                {
                    text = @"11:30-12:15";
                    title = @"4th Period";
                }
                    break;
                case 2:
                case 3:
                case 5:
                case 6:
                {
                    text = @"11:20-12:20";
                    title = @"4th Period";
                }
                    break;
            }
            
        }
            break;
        case 5:
        {
            if (isUpper) {
                switch ([self dateOfToday]) {
                    case 7:
                    case 1:
                    {
                        text = @"Mon, Tues, Thur, Fri:\n12:25-1:10\nWednesday:\n12:20-1:05";
                        title = @"5th Period";
                    }
                        break;
                        
                    case 4:
                    {
                        text = @"12:20-1:05";
                        title = @"5th Period";
                    }
                        break;
                    case 2:
                    case 3:
                    case 5:
                    case 6:
                    {
                        text = @"12:25-1:10";
                        title = @"5th Period";
                    }
                        break;
                }
            }
            else {
                text = @"12:20-1:05";
                title = @"5th Period";
            }
            
        }
            break;
        case 6:
        {
            text = @"1:10-1:55";
            title = @"6th Period";
            
        }
            break;
        case 7:
        {
            text = @"2:00-2:45";
            title = @"7th Period";
        }
            break;
        case 8:
        {
            text = @"2:50-3:35";
            title = @"8th Period";
        }
            break;
    }
    
    
    
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:text delegate:self cancelButtonTitle:NSLocalizedString(@"Done", nil) otherButtonTitles:nil, nil];
    [alert show];
}

-(void)dismissAlertView :(UIButton *)sender {
    [(UIAlertView* )sender.superview dismissWithClickedButtonIndex:0 animated:YES];
}

-(NSInteger)dateOfToday {
    return ([[[NSCalendar currentCalendar]components:NSWeekdayCalendarUnit fromDate:[NSDate date]]weekday]);
}

-(CGRect)dayBannerFrameFromDay: (NSString *)dayString {
    CGRect dayFrame;
    CGFloat originY = 6.0f;
    CGFloat originX = 15.0f;
    if (iPhone6) {
        originX = 19.0f;
    }
    else if (iPhone6Plus) {
        originX = 25.0f;
    }
    CGFloat increment = 44.0f;
    if (iPhone6) {
        increment= 51.0f;
    }
    else if (iPhone6Plus) {
        increment= 55.5f;
    }
    if ([dayString isEqualToString:@"B"]) {
        originX += increment;
    }
    if ([dayString isEqualToString:@"C"]) {
        originX += 2 * increment;
    }
    if ([dayString isEqualToString:@"D"]) {
        originX += 3 * increment;
    }
    if ([dayString isEqualToString:@"E"]) {
        originX += 4 * increment;
    }
    if ([dayString isEqualToString:@"F"]) {
        originX += 5 * increment;
    }
    if ([dayString isEqualToString:@"G"]) {
        originX += 6 * increment;
    }
    dayFrame = CGRectMake(originX, originY , 34, 34);
    return dayFrame;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView tag] == kAleatTagYoutube) {
        if (buttonIndex == 1) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Redirecting..." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alert show];
            
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSURL *indirectUrl = [NSURL URLWithString:YOUTUBE_TUTORIAL_LINK_URL];
                NSError *error = nil;
                NSData *fetchedIndirectString = [NSData dataWithContentsOfURL:indirectUrl options:0 error:&error];
                NSString *urlString = nil;
                if(!error && fetchedIndirectString && [fetchedIndirectString length] > 0) {
                    urlString = [[NSString alloc]initWithData:fetchedIndirectString encoding:NSUTF8StringEncoding];
                    if (urlString) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
                            [alert dismissWithClickedButtonIndex:-1 animated:NO];
                        });
                    }
                }
            });
        }
    }
    
    if ([alertView tag] == kAlertTagReviewReminder) {
        SET_USER_DEFAULT([NSNumber numberWithBool:YES], kUserDefaultsKeyReviewRequested);

        if (buttonIndex == 1) {
            [[UIApplication sharedApplication]
             openURL:[NSURL URLWithString:ITUNES_STORE_URL]];
        }
    }
    if ([alertView tag] == kAlertTagUpdateReminder) {
        [[UIApplication sharedApplication]
         openURL:[NSURL URLWithString:ITUNES_STORE_URL]];
    }
}

#pragma mark image picker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"To share your schedule, please go to photo gallery." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end



