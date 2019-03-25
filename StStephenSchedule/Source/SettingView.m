//
//  SettingView.m
//  StStephenSchedule
//
//  Created by Eric Liang on 11/17/12.
//  Copyright (c) 2012 St.Stephen's. All rights reserved.
//

#import "SettingView.h"
#import "UsersViewController.h"

#define kSettingsTableViewSectionUsers 0
#define kSettingsTableViewGeneral 1


@interface SettingView ()

@property (nonatomic, strong)NSIndexPath *lastIndexPath;

@property (nonatomic, strong)UIBarButtonItem *addBarItem;
@property (nonatomic, strong)UIBarButtonItem *doneBarItem;

@end

@implementation SettingView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
     
    self.navigationItem.title = NSLocalizedString(@"Users", nil);
    
    NSString *filePath = PATH_FOR_FILE_IN_DOCUMENT_DOMAIN(kUsersNamesManagerFileName);
    if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        self.users = [NSMutableArray arrayWithContentsOfFile:filePath];
    }
    else {
        NSArray *array = [NSArray arrayWithObject:CURRENT_USER_NAME];
        [array writeToFile:filePath atomically:YES];
        self.users = [NSMutableArray arrayWithArray:array];
    }
    
    NSUInteger lastUserOrder = [[NSArray arrayWithContentsOfFile:filePath]indexOfObject:GET_USER_DEFAULT(kUserDefaultsKeyUserName)];
    self.lastIndexPath = [NSIndexPath indexPathForRow:lastUserOrder inSection:kSettingsTableViewSectionUsers];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) addUserButtonPressed {
    
    NSIndexPath *path;
    
    path = [NSIndexPath indexPathForRow:[self.users count] inSection:kSettingsTableViewSectionUsers];
    [self.users addObject:@""];
    [self.myTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationBottom];
    NSUInteger buttonRow = [path row];
    UsersViewController *usersViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UsersViewController"];
    
    if ([usersViewController respondsToSelector:@selector(setDelegate:)]) {
        [usersViewController setValue:self forKey:@"delegate"];
    }
    if ([usersViewController respondsToSelector:@selector(setPassedData:)]) {
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:[self.users objectAtIndex:buttonRow],kSettingsUsersPassedDataUserName, [NSNumber numberWithInteger:buttonRow],kSettingsUsersPassedDataIndex, [NSNumber numberWithBool:YES], kSettingsUsersPassedDataIsNew, nil];
        [usersViewController setValue:data forKey:@"passedData"];
    }
    [self.navigationController pushViewController:usersViewController animated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == kSettingsTableViewGeneral) {
        return 1;
    }
    else return [self.users count] + 1;
}

-(NSIndexPath*) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == kSettingsTableViewSectionUsers && [self.users count] == [indexPath row]) {
        return indexPath;
    }
    
    else return indexPath;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([indexPath row] != 0) {
            [self.users removeObjectAtIndex:[indexPath row]];
            [self.users writeToFile:PATH_FOR_FILE_IN_DOCUMENT_DOMAIN(kUsersNamesManagerFileName) atomically:YES];
            NSError *error = nil;
            [[NSFileManager defaultManager]removeItemAtPath:PATH_FOR_DATA_OF_USER([tableView cellForRowAtIndexPath:indexPath].textLabel.text) error:&error];
            // delete the row from the data source
            if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark) {
                SET_USER_DEFAULT([self.users objectAtIndex:0], kUserDefaultsKeyUserName);
                SET_USER_DEFAULT([[NSDictionary dictionaryWithContentsOfFile: PATH_FOR_DATA_OF_USER(CURRENT_USER_NAME)]objectForKey:kUserDataKeyUserPersonType], kUserDefaultsKeyUserTypePerson);
                SET_USER_DEFAULT([[NSDictionary dictionaryWithContentsOfFile: PATH_FOR_DATA_OF_USER(CURRENT_USER_NAME)]objectForKey:kUserDataKeyUserSchoolSection], kUserDefaultsKeyUserTypeSchoolSection);
                self.lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:kSettingsTableViewSectionUsers];
            }
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
            [tableView reloadData];
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier =nil;

    if ([indexPath section]==kSettingsTableViewGeneral){
        if ([indexPath row] == 0) {
            CellIdentifier=@"ResetCellIdentifier";
        }
        else if ([indexPath row] == 1){
            CellIdentifier=@"AddUserCellIdentifier";

        }
    }
    else if ([indexPath section]==kSettingsTableViewSectionUsers && [indexPath row] < [self.users count]) {
        CellIdentifier=@"UsersCellIdentifier";
    }
    else if ([indexPath section]==kSettingsTableViewSectionUsers && [indexPath row] == [self.users count]) {
        CellIdentifier=@"AddUserCellIdentifier";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    
    if ([indexPath section] == kSettingsTableViewSectionUsers && [indexPath row] < [self.users count]) {
        
        cell.textLabel.text = [self.users objectAtIndex:[indexPath row]];
        UIButton *cellEditButton=(UIButton *)[cell viewWithTag:1];
        cellEditButton.titleLabel.text = @"Edit";
        [cellEditButton.layer setBorderColor:[cellEditButton titleColorForState:UIControlStateNormal].CGColor];
        cellEditButton.layer.borderWidth = 1.0;
        cellEditButton.layer.cornerRadius = 5;
        
        
        [cellEditButton addTarget:self action:@selector(cellEditButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:cellEditButton];
        NSUInteger row = [indexPath row];
        NSUInteger oldRow = [self.lastIndexPath row];
        cell.accessoryType = (row == oldRow && self.lastIndexPath != nil) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    else if ([indexPath section] == kSettingsTableViewSectionUsers && [indexPath row] == [self.users count]) {
        
        UILabel *firstLabel=(UILabel *)[cell viewWithTag:1];
        firstLabel.text=NSLocalizedString(@"Add New User",nil);
        
    }
    if ([indexPath section]==kSettingsTableViewGeneral) {
        
        UILabel *firstLabel=(UILabel *)[cell viewWithTag:1];
        
        if ([indexPath row] == 0) {
            firstLabel.text = NSLocalizedString(@"Reset All Data",nil);
        }
        
    
    }

    return cell;
}

-(void)cellEditButtonPressed:(UIButton *) sender {
    UITableViewCell *buttonCell = (UITableViewCell *)[sender superview];


    NSUInteger buttonRow = [[self.myTableView
                             indexPathForCell:buttonCell] row];
    
    UsersViewController *usersViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UsersViewController"];
    if ([usersViewController respondsToSelector:@selector(setDelegate:)]) {
        [usersViewController setValue:self forKey:@"delegate"];
    }
    if (buttonCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        ;
    }
    
    if ([usersViewController respondsToSelector:@selector(setPassedData:)]) {
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:[self.users objectAtIndex:buttonRow],kSettingsUsersPassedDataUserName, [NSNumber numberWithInteger:buttonRow],kSettingsUsersPassedDataIndex, [NSNumber numberWithBool:NO], kSettingsUsersPassedDataIsNew, [NSNumber numberWithBool:(buttonCell.accessoryType == UITableViewCellAccessoryCheckmark) ? YES : NO], kSettingsUsersPassedDataIsCurrentUser, nil];
        [usersViewController setValue:data forKey:@"passedData"];
    }
    
    [self.navigationController pushViewController:usersViewController animated:YES];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case kSettingsTableViewSectionUsers:
            return [NSString stringWithFormat:NSLocalizedString(@"Users",nil)];
            break;
        default:
            return [NSString stringWithFormat:NSLocalizedString(@"General",nil)];
            break;
    }
}

#pragma mark - Table view delegate

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == kSettingsTableViewSectionUsers && [indexPath row] != [self.users count]) {
        return YES;
    }
    else return NO;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == kSettingsTableViewSectionUsers && [indexPath row] != 0 && [indexPath row] != [self.users count]) {
        return UITableViewCellEditingStyleDelete;
    }
    else return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([indexPath section]==kSettingsTableViewGeneral) {
        if ([indexPath row] == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Clear Data?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"Reset All Data" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action){
                for (NSString *name in self.users) {
                    NSError *error = nil;
                    [[NSFileManager defaultManager]removeItemAtPath:PATH_FOR_DATA_OF_USER(name) error:&error];
                }
                
                NSDictionary *dict = GENERATE_USER_DATA_DICTIONARY([NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"emptyUserData" withExtension:@"plist"]], @"Me",  kUserTypeSchoolSectionUpper, kUserTypePersonStudent);
                SET_USER_DEFAULT(@"Me", kUserDefaultsKeyUserName);
                NSString *filePath = PATH_FOR_DATA_OF_USER(CURRENT_USER_NAME);
                if (![[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
                    [dict writeToFile:filePath atomically:YES];
                }
                
                SET_USER_DEFAULT([[NSDictionary dictionaryWithContentsOfFile: PATH_FOR_DATA_OF_USER(CURRENT_USER_NAME)]objectForKey:kUserDataKeyUserPersonType], kUserDefaultsKeyUserTypePerson);
                SET_USER_DEFAULT([[NSDictionary dictionaryWithContentsOfFile: PATH_FOR_DATA_OF_USER(CURRENT_USER_NAME)]objectForKey:kUserDataKeyUserSchoolSection], kUserDefaultsKeyUserTypeSchoolSection);
                
                NSMutableArray *indexPathes = [NSMutableArray array];
                for (int i = 1; i<[[self users]count]; i++) {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection: kSettingsTableViewSectionUsers];
                    [indexPathes addObject:path];
                    
                }
                [self.users removeAllObjects];
                [self.users addObject:@"Me"];
                [self.users writeToFile:PATH_FOR_FILE_IN_DOCUMENT_DOMAIN(kUsersNamesManagerFileName) atomically:YES];
                
                [self.myTableView deleteRowsAtIndexPaths:indexPathes withRowAnimation:YES];
                [self.myTableView reloadData];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
        
    }
 
    if ([indexPath section] == kSettingsTableViewSectionUsers && [indexPath row] != [self.users count]) {

        NSInteger newRow = [indexPath row];
        NSInteger oldRow = (self.lastIndexPath != nil) ? [self.lastIndexPath row] : -1;
        if (newRow != oldRow) {
            UITableViewCell *newCell = [tableView cellForRowAtIndexPath:
                                        indexPath];
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            UITableViewCell *oldCell = [tableView cellForRowAtIndexPath: self.lastIndexPath];
            oldCell.accessoryType = UITableViewCellAccessoryNone;
            self.lastIndexPath = indexPath;
            SET_USER_DEFAULT([self.users objectAtIndex:[indexPath row]], kUserDefaultsKeyUserName);
            SET_USER_DEFAULT([[NSDictionary dictionaryWithContentsOfFile: PATH_FOR_DATA_OF_USER(CURRENT_USER_NAME)]objectForKey:kUserDataKeyUserPersonType], kUserDefaultsKeyUserTypePerson);
            SET_USER_DEFAULT([[NSDictionary dictionaryWithContentsOfFile: PATH_FOR_DATA_OF_USER(CURRENT_USER_NAME)]objectForKey:kUserDataKeyUserSchoolSection], kUserDefaultsKeyUserTypeSchoolSection);
        }
    }
    else if ([indexPath section] == kSettingsTableViewSectionUsers && [indexPath row] == [self.users count] ) {
        
        [self addUserButtonPressed];
        
    }
}

@end
