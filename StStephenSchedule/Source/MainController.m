//
//  MainController.m
//  StStephenSchedule
//
//  Created by Eric Liang on 7/23/12.
//  Copyright (c) 2012 St.Stephen's. All rights reserved.
//

#import "MainController.h"

#import "SettingView.h"

#define isWeekend ([self dateOfToday] == 1 || [self dateOfToday] == 7)
#define isUpper ([[[NSUserDefaults standardUserDefaults]objectForKey:@"userTypeSchoolSection"]integerValue] == kUserTypeSchoolSectionUpper)

@interface MainController ()

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
    [self.navigationItem.rightBarButtonItem setAction:@selector(editButtonPressed:)];
    [self.navigationItem.rightBarButtonItem setTarget:self];
    
    [self.navigationItem.leftBarButtonItem setAction:@selector(settingsButtonClicked)];
    [self.navigationItem.leftBarButtonItem setTarget:self];
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


-(void)settingsButtonClicked {
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
    return self.myTableView.frame.size.height / [self tableView:self.myTableView numberOfRowsInSection:0];
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

@end
