//
//  MainController.m
//  StStephenSchedule
//
//  Created by Eric Liang on 7/23/12.
//  Copyright (c) 2012 St.Stephen's. All rights reserved.
//

#import "MainController.h"

#import "AboutView.h"
#import "SettingView.h"

#define isWeekend ([self dateOfToday] == 1 || [self dateOfToday] == 7)
#define isUpper ([[[NSUserDefaults standardUserDefaults]objectForKey:@"userTypeSchoolSection"]integerValue] == kUserTypeSchoolSectionUpper)

#define kAlertTagUpdateReminder 21
#define kAleatTagYoutube 19


@interface MainController ()

@property (strong, nonatomic) AwesomeMenu *menu;
@property (strong, nonatomic) NSDictionary *scheduleData;
@property (strong, nonatomic) NSDictionary *displayedSchedule;

@end

@implementation MainController

-(NSString * )getLetterDayFromApache {
    NSURL *url = [NSURL URLWithString:LETTER_DAY_URL];
    NSError *error = nil;
    NSData *fetchedString = [NSData dataWithContentsOfURL:url options:0 error:&error];
    NSString *content = nil;
    NSString *result = nil;
    if(!error && fetchedString && [fetchedString length] > 0) {
        content = [[NSString alloc]initWithData:fetchedString encoding:NSASCIIStringEncoding];
        char dayLetterChar=[content characterAtIndex:[content length]-4];
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFG"];
        if ([characterSet characterIsMember:dayLetterChar]) {
            result = [NSString stringWithFormat:@"%c",dayLetterChar];
        }
    }
    return result;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *dayString=[self getLetterDayFromApache];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (dayString!=nil) {
                self.dayDisplayedName=dayString;
                self.displayedSchedule=[self.scheduleData objectForKey:dayString];
                for (id object in self.letterButtons) {
                    UIButton * button = (UIButton *)object;
                    if ([button.titleLabel.text isEqualToString:dayString]){
                        button.titleLabel.textColor = [UIColor yellowColor];
                        [button setTitleColor: [UIColor yellowColor] forState:UIControlStateNormal];
                    }
                }
            }
        });
    });
    self.displayedSchedule = [self.scheduleData objectForKey:self.dayDisplayedName];
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

    [self setDayDisplayedName:@"A"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *dayString=[self getLetterDayFromApache];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (dayString!=nil) {
                self.dayDisplayedName = dayString;
                self.displayedSchedule = [self.scheduleData objectForKey:dayString];
                for (id object in self.letterButtons) {
                    UIButton * button = (UIButton *)object;
                    if ([button.titleLabel.text isEqualToString:dayString]){
                        button.titleLabel.textColor = [UIColor yellowColor];
                        [button setTitleColor: [UIColor yellowColor] forState:UIControlStateNormal];
                    }
                }
            }
        });
    });
    self.displayedSchedule = [self.scheduleData objectForKey:self.dayDisplayedName];
}

-(void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated {
    [self reloadUserData];
    self.displayedSchedule = [self.scheduleData objectForKey:self.dayDisplayedName];
    [self.myTableView reloadData];
    
    if ([CURRENT_USER_NAME isEqualToString:@"Me"]) {
        self.title=[NSString stringWithFormat:NSLocalizedString(@"My %@ Day", nil), self.dayDisplayedName];
    }
    else {
        self.title=[NSString stringWithFormat:@"%@'s %@ Day",CURRENT_USER_NAME, self.dayDisplayedName];
    }
    [super viewWillAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
    
    AwesomeMenuItem *settingsMenuItem = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage highlightedImage:storyMenuItemImagePressed ContentImage:[UIImage imageNamed:@"icon-setting.png"] highlightedContentImage:[UIImage imageNamed:@"icon-setting-high.png"]];
    AwesomeMenuItem *aboutMenuItem = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage highlightedImage:storyMenuItemImagePressed ContentImage:[UIImage imageNamed:@"icon-about.png"] highlightedContentImage:[UIImage imageNamed:@"icon-about-high.png"]];
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg-addbutton.png"] highlightedImage:[UIImage imageNamed:@"bg-addbutton-highlighted.png"] ContentImage:[UIImage imageNamed:@"icon-plus.png"] highlightedContentImage:[UIImage imageNamed:@"icon-plus-highlighted.png"]];
   
    self.menu  = [[AwesomeMenu alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.85, self.view.frame.size.height * 0.90, 150, 150) startItem:startItem menuItems:@[aboutMenuItem, settingsMenuItem]];
    [self.menu setStartPoint:CGPointZero];
    self.menu.delegate = self;

    self.menu.menuWholeAngle = M_PI /3;
    self.menu.rotateAngle =  M_PI /2 *3;
    [self.view addSubview:self.menu];
    
}
-(void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx{
    switch (idx) {
        case 0:
        {
            [self performSelector:@selector(quadAboutButtonClicked) withObject:nil afterDelay:0.15];
        }
            break;
        case 1:
        {
            [self performSelector:@selector(quadSettingsButtonClicked) withObject:nil afterDelay:0.15];
        }
            break;
    }
}


-(void) quadAboutButtonClicked {
    AboutView *aboutController = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutView"];
    [self.navigationController pushViewController:aboutController animated:YES];
}

-(void)quadSettingsButtonClicked {
    SettingView *settingView = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingView"];
    [self.navigationController pushViewController:settingView animated:YES];

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
    NSDictionary *dict=[self.displayedSchedule objectForKey:periodNumberString];
    
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
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.myTableView.frame.size.height > 1){
        return self.myTableView.frame.size.height / [self tableView:self.myTableView numberOfRowsInSection:0];
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
        _dayDisplayedName = aName;
        if ([CURRENT_USER_NAME isEqualToString:@"Me"]) {
            self.title=[NSString stringWithFormat:NSLocalizedString(@"My %@ Day", nil), self.dayDisplayedName];
        }
        else {
            self.title=[NSString stringWithFormat:@"%@'s %@ Day",CURRENT_USER_NAME,self.dayDisplayedName];
        }
        self.displayedSchedule=[self.scheduleData objectForKey:aName];
        [self.myTableView reloadData];
    }
}

#pragma mark - Table view delegate

-(IBAction)editButtonPressed:(UIButton *)sender{
    EditScheduleController *editScheduleController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditScheduleControllerID"];
    [editScheduleController setValue:self forKey:@"delegate"];
    [editScheduleController setValue: self.dayDisplayedName forKey:@"editingDayDisplayedName"];
    [self.navigationController pushViewController:editScheduleController animated:YES];
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

@end
