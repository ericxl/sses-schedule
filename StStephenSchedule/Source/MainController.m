//
//  MainController.m
//  StStephenSchedule
//
//  Created by Eric Liang on 7/23/12.
//  Copyright (c) 2012 St.Stephen's. All rights reserved.
//

#import "MainController.h"

#import "SettingView.h"
#import "SSSSchedule.h"
#import "ClassPickerController.h"

@interface MainController ()

@property (strong, nonatomic) SSSSchedule *displayingSchedule;
@property (strong, nonatomic) SSSSchedule *editingSchedule;
@property (strong, nonatomic) NSString *displayingDay;

@end

@implementation MainController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.displayingSchedule = [self loadSchedule];
    self.editingSchedule = [self loadSchedule];
    
    self.displayingDay = @"A";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *dayString = [self getLetterDayFromApache];
        if (dayString != nil)
        {
            self.displayingDay = dayString;
            __weak MainController *welf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                for (id object in self.letterButtons) {
                    UIButton * button = (UIButton *)object;
                    if ([button.titleLabel.text isEqualToString:dayString]){
                        button.titleLabel.textColor = [UIColor yellowColor];
                        [button setTitleColor: [UIColor yellowColor] forState:UIControlStateNormal];
                    }
                    [[welf myTableView] reloadData];
                }
                [welf setTitle:[NSString stringWithFormat:@"%@ day", self.displayingDay]];
            });
        }
    });
    
    self.title = [NSString stringWithFormat:@"%@ day", self.displayingDay];
    [self updateNavBar:NO];
    self.myTableView.allowsSelectionDuringEditing = YES;
    self.myTableView.allowsSelection = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.editingClass != nil && self.shouldSave)
    {
        NSString *cp = [self classPeriodFromIndexPath:self.editedIndexPath];
        if (self.editingIsAll)
        {
            [self.editingSchedule setClass:self.editingClass forAllClassPeriod:cp];
        }
        else
        {
            [self.editingSchedule setClass:self.editingClass forClassPeriod:cp];
        }
        [self.myTableView reloadData];
    }
    self.editingClass = nil;
}

#pragma mark - Table View delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ScheduleCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    SSSSchedule *displayedSchedule = tableView.isEditing ? self.editingSchedule : self.displayingSchedule;
    NSLog(@"isEditing%@", [tableView isEditing] ? @"YES":  @"NO");
    NSString *selectedClassPeriod = [self classPeriodFromIndexPath:indexPath];
    SSSClass *currentClass = [displayedSchedule getClassWithClassPeriod:selectedClassPeriod];

    UILabel *periodLabel=(UILabel *)[cell viewWithTag:1];
    UILabel *classNameLabel=(UILabel *)[cell viewWithTag:2];
    UILabel *teacherNameLabel=(UILabel *)[cell viewWithTag:3];
    UILabel *locationNameLabel=(UILabel *)[cell viewWithTag:4];
    periodLabel.text = [NSString stringWithFormat:@"%ld", ([indexPath row] + 1)];
    classNameLabel.text = currentClass.name;
    teacherNameLabel.text = currentClass.teacher;
    locationNameLabel.text = currentClass.location;

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.myTableView.frame.size.height / [self tableView:self.myTableView numberOfRowsInSection:0];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassPickerController *destination = [self.storyboard instantiateViewControllerWithIdentifier:@"ClassPickerID"];
    if ([destination respondsToSelector:@selector(setDelegate:)]) {
        [destination setValue:self forKey:@"delegate"];
    }
    
    self.editedIndexPath = indexPath;
    NSString *selectedClassPeriod = [self classPeriodFromIndexPath:indexPath];
    [destination setEditingClass:[self.displayingSchedule getClassWithClassPeriod:selectedClassPeriod]];
    [destination setEditingSchedule:self.displayingSchedule];
    [destination setEditingPeriod:selectedClassPeriod];
    [destination setDelegate:self];

    [self.navigationController pushViewController:destination animated:YES];
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Helpers

- (NSString *)userFilePath
{
    NSString *currentUser = [[NSUserDefaults standardUserDefaults]objectForKey:kDisplayingUserNameKey];
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_schedule", currentUser]];
}

- (SSSSchedule *)loadSchedule
{
    NSString *usersFilePath = [self userFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:usersFilePath]) {
        NSData *scheduleData = [NSData dataWithContentsOfFile:usersFilePath];
        return [NSKeyedUnarchiver unarchiveObjectWithData:scheduleData];
    }
    else
    {
        SSSSchedule *newSchedule = [[SSSSchedule alloc] initWithHighSchool:YES];
        [self saveSchedule:newSchedule];
        return newSchedule;
    }
}

- (void)saveSchedule:(SSSSchedule *)schedule
{
    [NSKeyedArchiver archiveRootObject:schedule toFile:[self userFilePath]];
}

- (NSString *)classPeriodFromIndexPath:(NSIndexPath *)indexPath
{
    NSInteger period = [indexPath row] + 1;
    return [NSString stringWithFormat:@"%@%ld", self.displayingDay, period];
}

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

-(IBAction)dayButtonPressed:(UIButton *)sender {
    self.displayingDay = [NSString stringWithFormat:@"%C", [@"_ABCDEFG" characterAtIndex:sender.tag]];
    self.title = [NSString stringWithFormat:@"%@ day", self.displayingDay];
    [self.myTableView reloadData];
}

- (void)updateNavBar:(BOOL)editing
{
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: editing ? UIBarButtonSystemItemCancel : UIBarButtonSystemItemAdd target:self action: editing ? @selector(handleCancel) : @selector(handleSettings)];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:editing ? UIBarButtonSystemItemOrganize : UIBarButtonSystemItemCompose target:self action: editing ? @selector(handleSave) : @selector(handleEdit)];
    [left setTintColor:[UIColor whiteColor]];
    [right setTintColor:[UIColor whiteColor]];

    self.navigationItem.leftBarButtonItem = left;
    self.navigationItem.rightBarButtonItem = right;
}

- (void)handleEdit{
    [self.myTableView setEditing:YES animated:YES];
    [self.myTableView reloadData];
    [self updateNavBar:YES];
}

- (void)handleSettings {
    SettingView *settingView = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingView"];
    [self.navigationController pushViewController:settingView animated:YES];
}

- (void)handleCancel{
    [self updateNavBar:NO];
    self.editingSchedule = [self loadSchedule];
    [self.myTableView setEditing:NO animated:YES];
    [self.myTableView reloadData];
}

- (void)handleSave {
    [self updateNavBar:NO];
    [self saveSchedule:self.editingSchedule];
    self.displayingSchedule = [self loadSchedule];
    self.editingSchedule = [self loadSchedule];
    [self.myTableView setEditing:NO animated:YES];
    [self.myTableView reloadData];
}

@end
