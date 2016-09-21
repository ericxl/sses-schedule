//
//  UsersViewController.m
//  StStephenSchedule
//
//  Created by Eric Liang on 11/17/12.
//  Copyright (c) 2012 St.Stephen's. All rights reserved.
//

#import "UsersViewController.h"
#import "SettingView.h"
#import "Common.h"

#define kSettingsTableViewSectionUsers 0


@interface UsersViewController ()

@end

@implementation UsersViewController

@synthesize userTypeSegment;
@synthesize userNameTextField;
@synthesize userDataBuffer;
@synthesize personTypeSegment;
@synthesize delegate;
@synthesize passedData;
@synthesize userNameHolder;

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

    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goback)];
    [customBarItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    
    UIBarButtonItem *customBarItemDone = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(save)];
    [customBarItemDone setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = customBarItemDone;
    
    
    
    [self.userTypeSegment setTitle:NSLocalizedString(@"Upper", nil) forSegmentAtIndex:0];
    [self.userTypeSegment setTitle:NSLocalizedString(@"Middle", nil) forSegmentAtIndex:1];
    [self.personTypeSegment setTitle:NSLocalizedString(@"Student", nil) forSegmentAtIndex:0];
    [self.personTypeSegment setTitle:NSLocalizedString(@"Teacher", nil) forSegmentAtIndex:1];

    
    if ([[passedData objectForKey:kSettingsUsersPassedDataUserName] isEqualToString:@""]) {
        NSDictionary *dict = GENERATE_USER_DATA_DICTIONARY([NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"emptyUserData" withExtension:@"plist"]], @"",  kUserTypeSchoolSectionUpper, kUserTypePersonStudent);
        self.userDataBuffer = [NSMutableDictionary dictionaryWithDictionary:dict];
    }
    else {
        self.userDataBuffer = [NSMutableDictionary dictionaryWithContentsOfFile:PATH_FOR_DATA_OF_USER([passedData objectForKey:kSettingsUsersPassedDataUserName])];
    }
    
    self.userTypeSegment.selectedSegmentIndex = [[self.userDataBuffer objectForKey:kUserDataKeyUserSchoolSection]integerValue];
    self.personTypeSegment .selectedSegmentIndex = [[self.userDataBuffer objectForKey:kUserDataKeyUserPersonType]integerValue];
    self.userNameTextField.text = [passedData objectForKey:kSettingsUsersPassedDataUserName];
    
    if ([self.userNameTextField.text isEqualToString:@""]) {
        [self.userNameTextField becomeFirstResponder];
    }
    self.userNameHolder = [passedData objectForKey:kSettingsUsersPassedDataUserName];
    
 
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) save {
        
    if ([[self.passedData objectForKey:kSettingsUsersPassedDataIsNew]boolValue] && [self.userNameTextField.text isEqualToString:@""]) {
        //delete new user
        [[(SettingView *)delegate users] removeObjectsAtIndexes:[NSIndexSet indexSetWithIndex:[[self.passedData objectForKey:kSettingsUsersPassedDataIndex] integerValue]]];
        [[(SettingView *)delegate users] writeToFile:PATH_FOR_FILE_IN_DOCUMENT_DOMAIN(kUsersNamesManagerFileName) atomically:YES];
        [[(SettingView *)delegate myTableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[[self.passedData objectForKey:kSettingsUsersPassedDataIndex] integerValue] inSection:kSettingsTableViewSectionUsers]] withRowAnimation:YES];
        
        self.userNameHolder = nil;
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if (![[self.passedData objectForKey:kSettingsUsersPassedDataIsNew]boolValue] && [self.userNameTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please enter a name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([[(SettingView *)delegate users] containsObject:self.userNameTextField.text] && ![self.userNameTextField.text isEqualToString:self.userNameHolder]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Name already exists" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([delegate isKindOfClass:[SettingView class]]) {
        NSString *name = self.userNameTextField.text;
        if (![name isEqualToString:self.userNameHolder]) {
            [[(SettingView *)delegate users] removeObjectsAtIndexes:[NSIndexSet indexSetWithIndex:[[self.passedData objectForKey:kSettingsUsersPassedDataIndex] integerValue]]];
            [[(SettingView *)delegate users] insertObject:name atIndex:[[self.passedData objectForKey:kSettingsUsersPassedDataIndex] integerValue]];
            NSError *error = nil;
            [[NSFileManager defaultManager]removeItemAtPath:PATH_FOR_DATA_OF_USER(self.userNameHolder) error:&error];
            
            NSString *filePath = PATH_FOR_DATA_OF_USER(self.userNameTextField.text);
            [self.userDataBuffer writeToFile:filePath atomically:YES];
            
            NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:PATH_FOR_FILE_IN_DOCUMENT_DOMAIN(kUsersNamesManagerFileName)];
            [array removeObject:userNameHolder];
            [array insertObject:self.userNameTextField.text atIndex:[[passedData objectForKey:kSettingsUsersPassedDataIndex]integerValue]];
            [array writeToFile:PATH_FOR_FILE_IN_DOCUMENT_DOMAIN(kUsersNamesManagerFileName) atomically:YES];
            
            [[(SettingView *)delegate myTableView]reloadData];
        }
        else {
            NSString *filePath = PATH_FOR_DATA_OF_USER(self.userNameTextField.text);
            [self.userDataBuffer writeToFile:filePath atomically:YES];
        }
        
        if ([[passedData objectForKey:kSettingsUsersPassedDataIsCurrentUser] boolValue]) {
            SET_USER_DEFAULT(self.userNameTextField.text, kUserDefaultsKeyUserName);
            SET_USER_DEFAULT([[NSDictionary dictionaryWithContentsOfFile: PATH_FOR_DATA_OF_USER(CURRENT_USER_NAME)]objectForKey:kUserDataKeyUserPersonType], kUserDefaultsKeyUserTypePerson);
            SET_USER_DEFAULT([[NSDictionary dictionaryWithContentsOfFile: PATH_FOR_DATA_OF_USER(CURRENT_USER_NAME)]objectForKey:kUserDataKeyUserSchoolSection], kUserDefaultsKeyUserTypeSchoolSection);
        }
    }
    self.userNameHolder = nil;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) goback {
    if ([[self.passedData objectForKey:kSettingsUsersPassedDataIsNew]boolValue]) {
        //delete new user
        [[(SettingView *)delegate users] removeObjectsAtIndexes:[NSIndexSet indexSetWithIndex:[[self.passedData objectForKey:kSettingsUsersPassedDataIndex] integerValue]]];
        [[(SettingView *)delegate users] writeToFile:PATH_FOR_FILE_IN_DOCUMENT_DOMAIN(kUsersNamesManagerFileName) atomically:YES];
        [[(SettingView *)delegate myTableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[[self.passedData objectForKey:kSettingsUsersPassedDataIndex] integerValue] inSection:kSettingsTableViewSectionUsers]] withRowAnimation:YES];
        
        self.userNameHolder = nil;
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    
    self.userNameHolder = nil;
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (void)viewDidUnload {
    [self setUserTypeSegment:nil];
    [self setPersonTypeSegment:nil];
    [self setUserNameTextField:nil];
    [self setDelegate:nil];
    [self setPassedData:nil];
    [self setUserNameHolder:nil];
    [self setUserDataBuffer:nil];    
    [super viewDidUnload];
}
- (IBAction)viewTouched:(UIControl *)sender {
    [userNameTextField resignFirstResponder];
}

- (IBAction)userTypeSegmentValueChanged:(UISegmentedControl *)sender {
    if ([[passedData objectForKey:kSettingsUsersPassedDataIsNew]boolValue]) { // new 
        [self.userDataBuffer setObject:[NSNumber numberWithInteger:sender.selectedSegmentIndex] forKey:kUserDataKeyUserSchoolSection];
    }
    else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"Switch Section",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil)destructiveButtonTitle:NSLocalizedString(@"Switch and Reset Data",nil) otherButtonTitles:NSLocalizedString(@"Switch without Reset",nil), nil];
        [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        [actionSheet showInView:self.view];
    }
}

- (IBAction)personTypeSegmentValueChanged:(UISegmentedControl *)sender {
    [self.userDataBuffer setObject:[NSNumber numberWithInteger:sender.selectedSegmentIndex] forKey:kUserDataKeyUserPersonType];
}

-(void)switchSegment: (UISegmentedControl *)sender{
    if (sender.selectedSegmentIndex == 0) {
        sender.selectedSegmentIndex = 1;
    }
    else sender.selectedSegmentIndex = 0;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {
            NSDictionary *emtpyDataDictionary=[NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"emptyUserData" withExtension:@"plist"]];
            [self.userDataBuffer setObject:emtpyDataDictionary forKey:kUserDataKeyUserSchedule];
            [self.userDataBuffer setObject:[NSNumber numberWithInteger:userTypeSegment.selectedSegmentIndex] forKey:kUserDataKeyUserSchoolSection];

        }
            break;
            
        case 1:
        {
            [self.userDataBuffer setObject:[NSNumber numberWithInteger:userTypeSegment.selectedSegmentIndex] forKey:kUserDataKeyUserSchoolSection];
        }
            break;
            
        case 2:
            [self switchSegment:self.userTypeSegment];
            [self.userDataBuffer setObject:[NSNumber numberWithInteger:userTypeSegment.selectedSegmentIndex] forKey:kUserDataKeyUserSchoolSection];
            break;
    }
}
@end
