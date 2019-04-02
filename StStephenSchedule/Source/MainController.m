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

@end

@implementation MainController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = [NSString stringWithFormat:@"%@ day", self.displayingDay];

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

    SSSSchedule *displayedSchedule = tableView.isEditing ? self.editingSchedule : self.schedule;
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
    [destination setEditingClass:[self.schedule getClassWithClassPeriod:selectedClassPeriod]];
    [destination setEditingSchedule:self.schedule];
    [destination setEditingPeriod:selectedClassPeriod];
    [destination setDelegate:self];

    [self.navigationController pushViewController:destination animated:YES];
    [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Helpers

- (NSString *)classPeriodFromIndexPath:(NSIndexPath *)indexPath
{
    NSInteger period = [indexPath row] + 1;
    return [NSString stringWithFormat:@"%@%ld", self.displayingDay, period];
}

@end
