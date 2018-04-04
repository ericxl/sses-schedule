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

    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
    [customBarItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    
    UIBarButtonItem *customBarItemDone = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
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
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Please enter a name" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    if ([[(SettingView *)delegate users] containsObject:self.userNameTextField.text] && ![self.userNameTextField.text isEqualToString:self.userNameHolder]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Name already exists" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
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

- (IBAction)viewTouched:(UIControl *)sender {
    [userNameTextField resignFirstResponder];
}

- (IBAction)userTypeSegmentValueChanged:(UISegmentedControl *)sender {
    if ([[passedData objectForKey:kSettingsUsersPassedDataIsNew]boolValue]) { // new 
        [self.userDataBuffer setObject:[NSNumber numberWithInteger:sender.selectedSegmentIndex] forKey:kUserDataKeyUserSchoolSection];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Switch Section" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
            [self switchSegment:self.userTypeSegment];
            [self.userDataBuffer setObject:[NSNumber numberWithInteger:userTypeSegment.selectedSegmentIndex] forKey:kUserDataKeyUserSchoolSection];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Switch and Reset Data" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action){
            NSDictionary *emtpyDataDictionary=[NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"emptyUserData" withExtension:@"plist"]];
            [self.userDataBuffer setObject:emtpyDataDictionary forKey:kUserDataKeyUserSchedule];
            [self.userDataBuffer setObject:[NSNumber numberWithInteger:userTypeSegment.selectedSegmentIndex] forKey:kUserDataKeyUserSchoolSection];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Switch without Reset" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            [self.userDataBuffer setObject:[NSNumber numberWithInteger:userTypeSegment.selectedSegmentIndex] forKey:kUserDataKeyUserSchoolSection];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
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
@end
