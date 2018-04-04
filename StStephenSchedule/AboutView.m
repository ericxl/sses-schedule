//
//  AboutView.m
//  StStephenSchedule
//
//  Created by Eric Liang on 7/23/12.
//  Copyright (c) 2012 St.Stephen's. All rights reserved.
//

#import "AboutView.h"
#import "Common.h"

#define kTableViewSectionAboutThisApp 0
#define kTableViewSectionAboutSSTX 1
#define kTableViewSectionContactBug 2
#define kTableViewSectionResetData 3


@interface AboutView ()

@end

@implementation AboutView
@synthesize myTableView;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section==kTableViewSectionAboutThisApp) {
        return 5;
    }
    else if(section==kTableViewSectionAboutSSTX){
        return 5;
    }
    else {
        return 1;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier =nil;
    if ([indexPath section]==kTableViewSectionAboutThisApp || [indexPath section]==kTableViewSectionAboutSSTX) {
        CellIdentifier=@"AboutCellIdentifier";
    }
    else {
        CellIdentifier=@"ContactCellIdentifier";
    }
    if ([indexPath section]==kTableViewSectionAboutSSTX && [indexPath row]==4) {
        CellIdentifier=@"MapCellIdentifier";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];

    }
    UILabel *firstLabel=(UILabel *)[cell viewWithTag:1];
    UILabel *secondLabel=(UILabel *)[cell viewWithTag:2];
    
    if ([indexPath section]==kTableViewSectionAboutThisApp) {
        if ([indexPath row]==0) {
            firstLabel.text=NSLocalizedString(@"Design & Code:",nil);
            secondLabel.text=NSLocalizedString(@"Xiaoyong Liang",nil);
        }
        else if ([indexPath row]==1) {
            firstLabel.text=NSLocalizedString(@"Copyright:",nil);
            secondLabel.text=@"2017 Xiaoyong Liang";
        }
        else if([indexPath row]==2) {
            firstLabel.text=NSLocalizedString(@"Version:",nil);
            secondLabel.text=[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];

        }
        else if([indexPath row]==3) {
            firstLabel.text=NSLocalizedString(@"YouTube:",nil);
            secondLabel.text=NSLocalizedString(@"Tutorial",nil);
        }
        else if([indexPath row]==4) {
            firstLabel.text=NSLocalizedString(@"Please",nil);
            secondLabel.text=NSLocalizedString(@"Write a review",nil);
        }
        
    }
    else if ([indexPath section]==kTableViewSectionAboutSSTX) {
        switch ([indexPath row]) {
            case 0:
                firstLabel.text=NSLocalizedString(@"Home Page:",nil);
                secondLabel.text=@"www.sstx.org";
                break;
                
            case 1:
                firstLabel.text=@"Net Classroom:";
                secondLabel.text=@"bbnet.sstx.org";
                break;
            case 2:
                firstLabel.text=@"Moodle:";
                secondLabel.text=@"moodle.sstx.org";
                break;
            case 3:
                firstLabel.text=NSLocalizedString(@"Phone:",nil);
                secondLabel.text=@"512-327-1213";
                break;
            case 4:
                firstLabel.text=NSLocalizedString(@"Location:",nil);
                secondLabel.text=@"6500 St. Stephen's Dr. Austin, TX 78746";
                break;
        }
    }
    else{
        switch ([indexPath row]) {
            case 0:
                firstLabel.text=NSLocalizedString(@"Email Me",nil);
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
        case kTableViewSectionAboutSSTX:
            return [NSString stringWithFormat:NSLocalizedString(@"About St. Stephen's Episcopal School",nil)];
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
            case 3:
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Watch Tutorial on YouTube?" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
                [alert addAction:[UIAlertAction actionWithTitle:@"Go!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                    UIAlertController *tempAlert = [UIAlertController alertControllerWithTitle:@"Redirecting..." message:nil preferredStyle:UIAlertControllerStyleAlert];
                    [self presentViewController:tempAlert animated:NO completion:nil];
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSURL *indirectUrl = [NSURL URLWithString:YOUTUBE_TUTORIAL_LINK_URL];
                        NSError *error = nil;
                        NSData *fetchedIndirectString = [NSData dataWithContentsOfURL:indirectUrl options:0 error:&error];
                        NSString *urlString = nil;
                        if(!error && fetchedIndirectString && [fetchedIndirectString length] > 0) {
                            urlString = [[NSString alloc]initWithData:fetchedIndirectString encoding:NSUTF8StringEncoding];
                            if (urlString) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
                                    [tempAlert dismissViewControllerAnimated:NO completion:nil];
                                });
                            }
                        }
                    });
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            }
                break;
            case 4:
            {
                SET_USER_DEFAULT([NSNumber numberWithBool:YES], kUserDefaultsKeyReviewRequested);
                [[UIApplication sharedApplication]
                 openURL:[NSURL URLWithString:ITUNES_STORE_URL] options:@{} completionHandler:nil];
            }
                break;
                
        }
    }
    
    else if ([indexPath section]==kTableViewSectionAboutSSTX) {
        switch ([indexPath row]) {
            case 0:
            {
                NSURL *url=[NSURL URLWithString:SSES_HOME_URL];
                [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:nil];
            }
                break;
                
            case 1:
            {
                NSURL *url=[NSURL URLWithString:SSES_NET_CLASSROOM_URL];
                [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:nil];
            }
                break;
            case 2:
            {
                NSURL *url=[NSURL URLWithString:SSES_MOODLE_URL];
                [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:nil];
            }
                break;
            case 3:
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:SSES_TELEPHONE_URL] options:@{} completionHandler:nil];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section]==kTableViewSectionAboutSSTX && [indexPath row]==4) {
        return 70;
    }
    else {
        return 45;
    }
    
}

@end
