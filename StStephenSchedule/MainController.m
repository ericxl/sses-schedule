//
//  MainController.m
//  StStephenSchedule
//
//  Created by Eric Liang on 7/23/12.
//  Copyright (c) 2012 St.Stephen's. All rights reserved.
//

#import "MainController.h"

#import "NSString_RotationComp.h"
#import "AboutView.h"
#import "DailyCalenderViewController.h"
#import "SettingView.h"
#import "Common.h"

#define isWeekend ([self dateOfToday] == 1 || [self dateOfToday] == 7)
#define isUpper ([[[NSUserDefaults standardUserDefaults]objectForKey:@"userTypeSchoolSection"]integerValue] == kUserTypeSchoolSectionUpper)

#define kAlertTagUpdateReminder 21
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
                for (id object in _letterButtons) {
                    UIButton * button = (UIButton *)object;
                    if ([button.titleLabel.text isEqualToString:dayString]){
                        button.titleLabel.textColor = [UIColor yellowColor];
                        [button setTitleColor: [UIColor yellowColor] forState:UIControlStateNormal];
                    }
                }
            }
        });
    });
    self.displayedSchedule = [self.scheduleData objectForKey:dayDisplayedName];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
    
    [self setDayDisplayedName:@"A"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *dayString=[self getLetterDayFromApache];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (dayString!=nil) {
                self.dayDisplayedName = dayString;
                self.displayedSchedule = [self.scheduleData objectForKey:dayString];
                for (id object in _letterButtons) {
                    UIButton * button = (UIButton *)object;
                    if ([button.titleLabel.text isEqualToString:dayString]){
                        button.titleLabel.textColor = [UIColor yellowColor];
                        [button setTitleColor: [UIColor yellowColor] forState:UIControlStateNormal];
                    }
                }
            }
        });
    });
    self.displayedSchedule = [self.scheduleData objectForKey:dayDisplayedName];
}

-(void)viewDidAppear:(BOOL)animated {
    if([[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsKeyFirstLaunch]) {
        [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"FirstWelcomeViewController"] animated:YES completion:nil];

        return;
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

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
    
    AwesomeMenuItem *starMenuItem1 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:[UIImage imageNamed:@"icon-about.png"]
                                                        highlightedContentImage:[UIImage imageNamed:@"icon-about-high.png"]];
    AwesomeMenuItem *starMenuItem2 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:[UIImage imageNamed:@"icon-calendar.png"]
                                                        highlightedContentImage:[UIImage imageNamed:@"icon-calendar-high.png"]];
    AwesomeMenuItem *starMenuItem3 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:[UIImage imageNamed:@"icon-setting.png"]
                                                        highlightedContentImage:[UIImage imageNamed:@"icon-setting-high.png"]];
    AwesomeMenuItem *starMenuItem4 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:[UIImage imageNamed:@"icon-share.png"]
                                                        highlightedContentImage:[UIImage imageNamed:@"icon-share-high.png"]];
    
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg-addbutton.png"]
                                                       highlightedImage:[UIImage imageNamed:@"bg-addbutton-highlighted.png"]
                                                           ContentImage:[UIImage imageNamed:@"icon-plus.png"]
                                                highlightedContentImage:[UIImage imageNamed:@"icon-plus-highlighted.png"]];
    NSArray *menus = [NSArray arrayWithObjects:starMenuItem4, starMenuItem3, starMenuItem1, nil];
   
    menu  = [[AwesomeMenu alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.85, self.view.frame.size.height * 0.90, 150, 150) startItem:startItem menuItems:menus];
    [menu setStartPoint:CGPointZero];
    menu.delegate = self;

    menu.menuWholeAngle = M_PI /2;
    menu.rotateAngle =  M_PI /2 *3;
    [self.view addSubview:menu];
    
}
-(void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx{
    switch (idx) {
        case 3:
        {
            [self performSelector:@selector(quadAboutButtonClicked) withObject:nil afterDelay:0.2];
        }
            break;
        case 2:
        {
            [self performSelector:@selector(quadAboutButtonClicked) withObject:nil afterDelay:0.2];
        }
            break;
        case 1:
        {
            [self performSelector:@selector(quadSettingButtonClicked) withObject:nil afterDelay:0.2];
        }
            break;
            
        case 0:
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Share your schedule, your schedule image will be copied to pasteboard" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Message" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self smsButtonPressed];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Copy to Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        __block UIImage *newImage = nil;
        __block UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Generating schedule image, please wait..." message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSString *user_first_name = [[CURRENT_USER_NAME componentsSeparatedByString:@" "] objectAtIndex:0];
            if ([user_first_name isEqualToString:@"Me"]) {
                user_first_name = @"";
            }
            newImage = [UIImage createScheduleImageWithUserName:CURRENT_USER_NAME displayedName:user_first_name];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil);
                [alert dismissViewControllerAnimated:NO completion:nil];
                
                UIAlertController *alertTemp = [UIAlertController alertControllerWithTitle:@"Image copied to Photos" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alertTemp animated:YES completion:nil];
                [self performSelector:@selector(dismissAlertB:) withObject:alertTemp afterDelay:2.0];
            });
        });
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void) quadSettingButtonClicked {
    SettingView *settingView = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingView"];
    [self.navigationController pushViewController:settingView animated:YES];

}


- (void)viewDidUnload
{
    [super viewDidUnload];

    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
    
    /*
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    */
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
    if (myTableView.frame.size.height > 1){
        return myTableView.frame.size.height / [self tableView:myTableView numberOfRowsInSection:0];
    }
    return 48;
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

-(void)dismissAlertB:(UIAlertController *)alert {
    [alert dismissViewControllerAnimated:NO completion:nil];
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
    
    __block UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Generating schedule image, please wait..." message:@"When done, tap PASTE to copy image into textfield" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *user_first_name = [[CURRENT_USER_NAME componentsSeparatedByString:@" "] objectAtIndex:0];
        if ([user_first_name isEqualToString:@"Me"]) {
            user_first_name = @"";
        }
        newImage = [UIImage createScheduleImageWithUserName:CURRENT_USER_NAME displayedName:user_first_name];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
            
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.image = newImage;
            
            [alert dismissViewControllerAnimated:NO completion:nil];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms:"] options:@{} completionHandler:nil];
            
        });
    });
    
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


    NSInteger periodNumber = [indexPath row] + 1;
    NSString *title;
    NSString *text;
    
    switch (periodNumber) {
        case 1:
        {
            text = @"8:30-9:15";
            title =@"1st Period";
        }
            break;
        case 2:
        {
            text = @"9:20-10:05";
            title =@"2nd Period";
        }
            break;
        case 3:
        {
            text = @"10:10-10:55";
            title = @"3rd Period";
        }
            break;
        case 4:
        {
            text = @"11:35-12:20";
            title = @"4th Period";
        }
            break;
        case 5:
        {
            text = @"12:25-1:10";
            title = @"5th Period";
            
        }
            break;
        case 6:
        {
            text = @"1:15-2:00";
            title = @"6th Period";
            
        }
            break;
        case 7:
        {
            text = @"2:05-2:50";
            title = @"7th Period";
        }
            break;
        case 8:
        {
            text = @"2:55-3:40";
            title = @"8th Period";
        }
            break;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:text preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
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


#pragma mark image picker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"To share your schedule, please go to photo gallery." message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end



