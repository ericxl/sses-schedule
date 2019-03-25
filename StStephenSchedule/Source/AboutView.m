//
//  AboutView.m
//  StStephenSchedule
//
//  Created by Eric Liang on 7/23/12.
//  Copyright (c) 2012 St.Stephen's. All rights reserved.
//

#import "AboutView.h"

#define kTableViewSectionAboutThisApp 0
#define kTableViewSectionContactBug 1

@interface AboutView ()

@end

@implementation AboutView

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
    
    //custom uis
    
    
    self.title = NSLocalizedString(@"About", nil);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    
    //back button
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section==kTableViewSectionAboutThisApp)
    {
        return 3;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = @"AboutCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ([indexPath section]==kTableViewSectionAboutThisApp) {
        if ([indexPath row]==0) {
            cell.textLabel.text=NSLocalizedString(@"Designed by: Xiaoyong Liang",nil);
        }
        else if ([indexPath row]==1) {
            cell.textLabel.text=NSLocalizedString(@"Copyright: 2017 Xiaoyong Liang",nil);
        }
        else if([indexPath row]==2) {
            cell.textLabel.text= [NSString stringWithFormat:@"Version: %@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];

        }
    }
    
    else{
        switch ([indexPath row]) {
            case 0:
                cell.textLabel.text=NSLocalizedString(@"Email Me",nil);
                break;
        }
    }
    
    
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case kTableViewSectionAboutThisApp:
            return [NSString stringWithFormat:NSLocalizedString(@"About this app",nil)];
            break;
        default:
            return [NSString stringWithFormat:NSLocalizedString(@"Contact Info & Bug Report",nil)];
            break;

    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([indexPath section]==kTableViewSectionAboutThisApp) {
        switch ([indexPath row]) {
            case 0:
            {
                UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
                UILabel *secondLabel=(UILabel *)[cell viewWithTag:2];
                if ([secondLabel.text isEqualToString: @"Eric Liang"]) {
                    secondLabel.text=@"梁骁勇";
                }
                else if ([secondLabel.text isEqualToString: @"Xiaoyong Liang"]) {
                    secondLabel.text=@"Eric Liang";
                }
                else if ([secondLabel.text isEqualToString: @"梁骁勇"]) {
                    secondLabel.text=@"梁驍勇";
                }
                else if ([secondLabel.text isEqualToString: @"梁驍勇"]) {
                    secondLabel.text=@"Xiaoyong Liang";
                }
            }
                break;
                
        }
    }
    else {
        switch ([indexPath row]) {
            case 0:
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Choose Email" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
                [alert addAction:[UIAlertAction actionWithTitle:@"My Gmail" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:MAIL_TO_URL] options:@{} completionHandler:nil];
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            }
                break;
        }
    }
    
}

@end
