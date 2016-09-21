//
//  EditScheduleController.m
//  StStephenSchedule
//
//  Created by Eric Liang on 6/22/12.
//  Copyright (c) 2012 St.Stephen's. All rights reserved.
//

#import "EditScheduleController.h"
#import "MainController.h"
#import "Common.h"

@interface EditScheduleController ()

@end

@implementation EditScheduleController

@synthesize editingTableView;
@synthesize currentEditedDaySchedule;
@synthesize editedSchedule;
@synthesize editedDataFromPicker;
@synthesize editNavigationItem;
@synthesize toolbar;
@synthesize editingDayDisplayedName;
@synthesize delegate;
@synthesize isEdited;

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
    self.isEdited=[NSNumber numberWithBool:NO];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:[UIApplication sharedApplication]];
    
    
    self.editNavigationItem.title=[NSString stringWithFormat:NSLocalizedString( @"Edit %@ Day",nil),editingDayDisplayedName];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    NSString *filePath = PATH_FOR_DATA_OF_USER(CURRENT_USER_NAME);
    if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        self.editedSchedule = [[NSMutableDictionary dictionaryWithContentsOfFile:filePath]objectForKey:kUserDataKeyUserSchedule];
        self.currentEditedDaySchedule = [NSMutableDictionary dictionaryWithDictionary:[self.editedSchedule objectForKey:editingDayDisplayedName]];
    }

    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(gobackButtonClicked)];
    [customBarItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    if (iPhone6) {
        for (UIBarButtonItem *button in self.letterButtons) {
            [button setWidth:41];
        }
    }
    else if (iPhone6Plus ) {
        for (UIBarButtonItem *button in self.letterButtons) {
            [button setWidth:45.5];
        }
    }
    else {
        for (UIBarButtonItem *button in self.letterButtons) {
            [button setWidth:34];
        }
    }
    
    /*
    if (iPhone5) {
        [editingTableView setFrame:CGRectMake(0, 44, 320, 524)];
    }
    else {
        [editingTableView setFrame:CGRectMake(0, 44, 320, 436)];
    }
*/
    /*
    else {
        
        NSDictionary *dictionary=[NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"emptyUserData" withExtension:@"plist"]];
        self.editedSchedule=[NSMutableDictionary dictionaryWithDictionary:dictionary];
        NSDictionary *dict=[dictionary objectForKey:editingDayDisplayedName];
        self.currentEditedDaySchedule=[NSMutableDictionary dictionaryWithDictionary:dict];
    }
     */
	// Do any additional setup after loading the view.
}

-(void)applicationWillResignActiveNotification :(NSNotification *)nitification {
    [self saveData];
}
- (void) gobackButtonClicked {
    if ([self.isEdited boolValue]) {
        UIActionSheet *actionsheet=[[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"Back without saving?",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil) destructiveButtonTitle:NSLocalizedString(@"Discard Changes", nil) otherButtonTitles:NSLocalizedString(@"Save",nil), nil];
        actionsheet.tag=10;
        actionsheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionsheet showInView:self.view];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES ];
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.editingTableView=nil;
    self.editedSchedule=nil;
    self.currentEditedDaySchedule=nil;
    self.editedDataFromPicker=nil;
    self.editNavigationItem=nil;
    self.toolbar=nil;
    self.editingDayDisplayedName=nil;
    self.isEdited=nil;
    self.letterButtons = nil;
    
        // Release any retained subviews of the main view.
}
-(void)dealloc {
    //[super dealloc];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillResignActiveNotification
                                                  object:[UIApplication sharedApplication]];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

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
    static NSString *EditClassCell=@"EditClassCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EditClassCell];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:EditClassCell];
    }
    
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
    NSDictionary *dict=[self.currentEditedDaySchedule objectForKey:periodNumberString];
    
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassPickerController *destination = [self.storyboard instantiateViewControllerWithIdentifier:@"ClassPickerID"];
    if ([destination respondsToSelector:@selector(setDelegate:)]) {
        [destination setValue:self forKey:@"delegate"];
    }
    
    if ([destination respondsToSelector:@selector(setSelectedData:)]) {
        UITableViewCell *cell = [self.editingTableView cellForRowAtIndexPath:indexPath];
        UILabel *classNameLabel=(UILabel *)[cell viewWithTag:2];
        UILabel *teacherNameLabel=(UILabel *)[cell viewWithTag:3];
        UILabel *locationNameLabel=(UILabel *)[cell viewWithTag:4];
        
        NSString *classNameString=classNameLabel.text;
        NSString *teacherNameString=teacherNameLabel.text;
        NSString *locationNameString=locationNameLabel.text;
        if (!classNameString) {
            classNameString=@"";
        }
        if (!teacherNameString) {
            teacherNameString=@"";
        }
        if (!locationNameString) {
            locationNameString=@"";
        }
        
        NSMutableDictionary *aMutableDict=[NSMutableDictionary dictionaryWithObjectsAndKeys:indexPath,@"indexPath", nil];
        [aMutableDict setObject:self.editingDayDisplayedName forKey:@"dayDisplayedName"];
        if (![classNameString isEqualToString:@""]) {
            [aMutableDict setObject:classNameString forKey:@"className"];
            [aMutableDict setObject:teacherNameString forKey:@"teacherName"];
            [aMutableDict setObject:locationNameString forKey:@"locationName"];
            [aMutableDict setObject:self.editingDayDisplayedName forKey:@"dayName"];
            [aMutableDict setObject:[NSNumber numberWithInteger:[indexPath row]] forKey:@"periodName"];
            
        }
        
        NSDictionary *dict=[NSDictionary dictionaryWithDictionary:aMutableDict];
        [destination setValue:dict forKey:@"selectedData"];
    }
    [self.navigationController pushViewController:destination animated:YES];
    [self.editingTableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"Delete Selected Class?",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil) destructiveButtonTitle:NSLocalizedString(@"For All Days",nil) otherButtonTitles:[NSString stringWithFormat:NSLocalizedString(@"For %@ Day Only",nil),editingDayDisplayedName], nil];
    NSInteger row=[indexPath row]+1;
    
    actionSheet.tag=row;
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag==10) {
        if (buttonIndex==0) {
            self.isEdited=[NSNumber numberWithBool:NO];
            [self.navigationController popViewControllerAnimated:YES ];
        }
        else if (buttonIndex==1) {
            [self saveData];
            self.isEdited=[NSNumber numberWithBool:NO];
            [self.navigationController popViewControllerAnimated:YES];
        }
        return;
    }
    
    switch (buttonIndex) {
        case 0:
        {
            //delete all day
            
            //period name and number
            NSString *originalDayName = self.editingDayDisplayedName;

            NSString *originalNotIdentifiedClassID=[originalDayName stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)actionSheet.tag]];
            NSString *originalClassID = nil;
            NSArray *classNeedChanges = nil;
            if (IS_UPPER) {
                originalClassID = [[NSDictionary dictionaryWithDictionary: [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"identifyClassID_upper" withExtension:@"plist"]]] objectForKey:originalNotIdentifiedClassID];
                classNeedChanges=[[NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"classNeededChanges_upper" withExtension:@"plist"]] objectForKey:originalClassID];
            }
            else {
                originalClassID = [[NSDictionary dictionaryWithDictionary: [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"identifyClassID_middle" withExtension:@"plist"]]] objectForKey:originalNotIdentifiedClassID];
                classNeedChanges=[[NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"classNeededChanges_middle" withExtension:@"plist"]] objectForKey:originalClassID];
            }
            
            //get info about class needed to be changed
            //make changes
            for (NSString *classTagString in classNeedChanges) {
                NSString *classTagDay=[NSString stringWithFormat:@"%c",[classTagString characterAtIndex:0]];
                NSString *classTagPeriod=[NSString stringWithFormat:@"%c",[classTagString characterAtIndex:1]];
                
                NSMutableDictionary *dict=[self.editedSchedule objectForKey:classTagDay];
                NSDictionary *emptyClassPeriod=[NSDictionary dictionaryWithObjectsAndKeys:@"OFF",@"className",@"",@"teacherName",@"",@"locationName", nil];
                
                [dict setObject:emptyClassPeriod forKey:classTagPeriod];
                
            }                
            self.currentEditedDaySchedule=[self.editedSchedule objectForKey:self.editingDayDisplayedName];
            [self.editingTableView reloadData];
            self.isEdited=[NSNumber numberWithBool:YES];

            //day name and number 
        }
            break;
            
        case 1:
            //[self.currentEditedDaySchedule removeObjectForKey:[NSString stringWithFormat:@"%d",actionSheet.tag]];
            [self.currentEditedDaySchedule setObject: [NSDictionary dictionaryWithObjectsAndKeys:@"OFF",@"className",@"",@"teacherName",@"",@"locationName", nil] forKey:[NSString stringWithFormat:@"%ld",(long)actionSheet.tag]];
            [self.editedSchedule removeObjectForKey:self.editingDayDisplayedName];
            [self.editedSchedule setObject:self.currentEditedDaySchedule forKey:self.editingDayDisplayedName];
            [self.editingTableView reloadData];
            self.isEdited=[NSNumber numberWithBool:YES];
            
            break;
            
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (iPhone5) {
        return 57.5;
    }
    else if (iPhone6) {
        return 70;
    }
    else if (iPhone6Plus) {
        return 78.5;
    }
    else return 46.5;
}
-(void)saveData
{
    if (isEdited) {
        [self.editedSchedule removeObjectForKey:editingDayDisplayedName];
        [self.editedSchedule setObject:currentEditedDaySchedule forKey:editingDayDisplayedName];
        NSDictionary *dictionary=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:SCHOOL_SECTION],kUserDataKeyUserSchoolSection,[NSNumber numberWithInteger:PERSON_TYPE],kUserDataKeyUserPersonType,CURRENT_USER_NAME,kUserDataKeyUserName,self.editedSchedule,kUserDataKeyUserSchedule, nil];
        
        NSString *filePath=PATH_FOR_DATA_OF_USER(CURRENT_USER_NAME);
        [dictionary writeToFile:filePath atomically:YES];
    }
    
}
-(IBAction)saveButtonPressed:(id)sender {
    [self saveData];
    if ([delegate respondsToSelector:@selector(setDayDisplayedName:)]) {
        [(MainController *)delegate reloadUserData];
        [delegate setValue:self.editingDayDisplayedName forKey:@"dayDisplayedName"];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - communicationWithClassPicker

 
-(void)setEditedDataFromPicker:(NSDictionary *)editedData {
    if (![editedData isEqual:editedDataFromPicker]) {
            editedDataFromPicker=editedData;
        NSIndexPath *indexPath=[editedData objectForKey:@"indexPath"];
        NSInteger periodNumber=[indexPath row]+1;
        NSString *periodName=[NSString stringWithFormat:@"%ld",(long)periodNumber];
        NSString *newClassName=[editedData objectForKey:@"className"];
        NSString *newTeacherName=[editedData objectForKey:@"teacherName"];
        NSString *newLocationName=[editedData objectForKey:@"locationName"];
        NSDictionary *dictionary=[NSDictionary dictionaryWithObjectsAndKeys:newClassName,@"className",newTeacherName,@"teacherName",newLocationName,@"locationName", nil];
        [self.currentEditedDaySchedule removeObjectForKey:periodName];
        [self.currentEditedDaySchedule setObject:dictionary forKey:periodName];
        [self.editedSchedule removeObjectForKey:self.editingDayDisplayedName];
        [self.editedSchedule setObject:self.currentEditedDaySchedule forKey:self.editingDayDisplayedName];

        [self.editingTableView reloadData];
        BOOL isRotation=[[editedData objectForKey:@"rotationName"]boolValue];
        // set rotation if it is
        if (isRotation) {
            [self rotationFromEditedData:editedData];
        }
    }
   
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
    self.editingDayDisplayedName=day;
    self.currentEditedDaySchedule=[editedSchedule objectForKey:editingDayDisplayedName];
    self.editNavigationItem.title=[NSString stringWithFormat:@"Edit %@ Day",editingDayDisplayedName];
    [self.editingTableView reloadData];
    
}
#pragma mark - get data

-(void)rotationFromEditedData: (NSDictionary *)editedData {
    //class info
    NSString *newClassName=[editedData objectForKey:@"className"];
    NSString *newTeacherName=[editedData objectForKey:@"teacherName"];
    NSString *newLocationName=[editedData objectForKey:@"locationName"];
    NSDictionary *newClassInfo=[NSDictionary dictionaryWithObjectsAndKeys:newClassName,@"className",newTeacherName,@"teacherName",newLocationName,@"locationName", nil];
    //period name and number
    NSIndexPath *indexPath=[editedData objectForKey:@"indexPath"];
    NSInteger originalPeriodNumber=[indexPath row]+1;
    NSString *originalPeriodName=[NSString stringWithFormat:@"%ld",(long)originalPeriodNumber];
    //day name and number
    NSString *originalDayName=self.editingDayDisplayedName;

    //identify classid
    NSString *originalNotIdentifiedClassID=[originalDayName stringByAppendingString:originalPeriodName];
    NSDictionary *identifyClassIDDictionary=[NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"identifyClassID_upper" withExtension:@"plist"]];
    if (SCHOOL_SECTION == kUserTypeSchoolSectionMiddle) {
        identifyClassIDDictionary =[NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"identifyClassID_middle" withExtension:@"plist"]];
    }
    NSString *originalClassID=[identifyClassIDDictionary objectForKey:originalNotIdentifiedClassID];
    //get info about class needed to be changed
    NSDictionary *classNeededChangesDictionary=[NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"classNeededChanges_upper" withExtension:@"plist"]];
    if (SCHOOL_SECTION == kUserTypeSchoolSectionMiddle) {
        classNeededChangesDictionary=[NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"classNeededChanges_middle" withExtension:@"plist"]];
    }
    
    NSArray *classNeedChanges=[classNeededChangesDictionary objectForKey:originalClassID];
    //make changes
    for (NSString *classTagString in classNeedChanges) {
        NSString *classTagDay=[NSString stringWithFormat:@"%c",[classTagString characterAtIndex:0]];
        NSString *classTagPeriod=[NSString stringWithFormat:@"%c",[classTagString characterAtIndex:1]];
        
        NSMutableDictionary *dict=[self.editedSchedule objectForKey:classTagDay];

            [dict removeObjectForKey:classTagPeriod];
        
        [dict setObject:newClassInfo forKey:classTagPeriod];
    }

}
@end
