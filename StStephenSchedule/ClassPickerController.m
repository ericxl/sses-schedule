//
//  ClassPickerController.m
//  StStephenSchedule
//
//  Created by Eric Liang on 6/22/12.
//  Copyright (c) 2012 St.Stephen's. All rights reserved.
//

#import "ClassPickerController.h"
#import "Common.h"

#define kMiddleClassFileName @"middleSchoolClassesData.plist"
#define kUpperClassFileName @"upperSchoolClassesData.plist"

@interface NSDictionary (Helpers)

+ (NSDictionary *)dictionaryWithContentsOfData:(NSData *)data;

@end

@implementation NSDictionary (Helpers)

+ (NSDictionary *)dictionaryWithContentsOfData:(NSData *)data
{
	// uses toll-free bridging for data into CFDataRef and CFPropertyList into NSDictionary
	CFPropertyListRef plist =  CFPropertyListCreateFromXMLData(kCFAllocatorDefault, (__bridge CFDataRef)data,
															   kCFPropertyListImmutable,
															   NULL);
	// we check if it is the correct type and only return it if it is
	if ([(__bridge id)plist isKindOfClass:[NSDictionary class]])
	{
		return (__bridge NSDictionary *)plist;
	}
	else
	{
		// clean up ref
		CFRelease(plist);
		return nil;
	}
}

@end




@interface ClassPickerController ()

@end

@implementation ClassPickerController
@synthesize classesPicker;
@synthesize teacherTextField;
@synthesize locationTextField;
@synthesize classesData;
@synthesize classCategory;
@synthesize specifiedClasses;

@synthesize delegate;
@synthesize selectedData;
@synthesize ericLogo;
@synthesize doneButton;
@synthesize locationFrame, locationNewFrame;
@synthesize teacherFrame, teacherNewFrame;

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
    
    //update class lists
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURL *url = nil;
        if (IS_UPPER) {
            url = [NSURL URLWithString:UPPER_CLASS_COURSE_LIST_URL];
        }
        else {
            url = [NSURL URLWithString:MIDDLE_CLASS_COURSE_LIST_URL];
        }
        
        NSError *error = nil;
        NSData *fetchedString = [NSData dataWithContentsOfURL:url options:0 error:&error];
        NSDictionary *classData = nil;
        if(!error && fetchedString && [fetchedString length] > 0) {
            classData = [NSDictionary dictionaryWithContentsOfData:fetchedString];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (classData!=nil) {
                [classData writeToFile:[self classesDataFilePath] atomically:YES];
                self.classesData = [NSDictionary dictionaryWithDictionary:classData];
                [self.classesPicker reloadAllComponents];
            }
        });
        
    });
    
    
    NSDictionary *dictionary = nil;
    if (![[NSFileManager defaultManager]fileExistsAtPath:[self classesDataFilePath]]) {
        if (SCHOOL_SECTION == kUserTypeSchoolSectionUpper) {
            dictionary = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"sstxClasses_upper" withExtension:@"plist"]];
        }
        else if (SCHOOL_SECTION == kUserTypeSchoolSectionMiddle) {
            dictionary =[NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"sstxClasses_middle" withExtension:@"plist"]];
        }
    }
    else {
        dictionary = [NSDictionary dictionaryWithContentsOfFile:[self classesDataFilePath]];
    }
    
    NSArray *unsorted=[dictionary allKeys];
    NSArray *sorted=[unsorted sortedArrayUsingSelector:@selector(compare:)];
    self.classCategory = sorted;
    
    locationTextField.placeholder = NSLocalizedString(@"Room #", nil);
    teacherTextField.placeholder = NSLocalizedString(@"Teacher Name",nil);
    if (PERSON_TYPE == kUserTypePersonTeacher) {
        teacherTextField.placeholder = NSLocalizedString(@"Class ID",nil);
    }
    
    self.classesData=dictionary;
    self.title = @"Class";
    if (selectedData) {
        if ([selectedData objectForKey:@"dayName"] || ![[selectedData objectForKey:@"dayName"] isEqualToString:@""]) {
            if ([selectedData objectForKey:@"periodName"] || ![[selectedData objectForKey:@"periodName"] isEqualToString:@""]) {
                NSNumber *number = [selectedData objectForKey:@"periodName"];
                self.title = [NSString stringWithFormat:@"%@%ld",[selectedData objectForKey:@"dayName"],(long)[number integerValue] + 1];
            }
            
        }
        
        //add teacher name and location name
        if ([selectedData objectForKey:@"className"] || ![[selectedData objectForKey:@"className"] isEqualToString:@""]) {
            // add teacher name
            if ([selectedData objectForKey:@"teacherName"] || ![[selectedData objectForKey:@"teacherName"] isEqualToString:@""]) {
                NSString *passTeacherName=[self.selectedData objectForKey:@"teacherName"];
                self.teacherTextField.text=passTeacherName;
            }
            //add location name
            if ([selectedData objectForKey:@"locationName"] || ![[selectedData objectForKey:@"locationName"] isEqualToString:@""]) {
                NSString *passLocationName=[self.selectedData objectForKey:@"locationName"];
                self.locationTextField.text=passLocationName;
            }
            
            //select picker
            NSString *selectedClassName=[selectedData objectForKey:@"className"];
            
            NSString *classCateName = [NSString stringWithFormat:@"@(・●・)@"];
            for (NSString *classCate in dictionary) {
                if ([(NSArray *)[dictionary objectForKey:classCate] containsObject:selectedClassName]) {
                    classCateName=classCate;
                    break;
                }
            }
            
            NSInteger cateNum=[self.classCategory indexOfObject:classCateName];
            NSInteger classNum = 0;
            if ([[dictionary objectForKey:classCateName]containsObject:selectedClassName]) {
                classNum=[[dictionary objectForKey:classCateName]indexOfObject:selectedClassName];
            }

            [self.classesPicker selectRow:cateNum inComponent:0 animated:YES];
            [self.classesPicker reloadComponent:1];
            [self.classesPicker selectRow:classNum inComponent:1 animated:YES];
        }
        //select picker
        
    }
    
    [doneButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    doneButton.layer.borderWidth = 1.0f;
    doneButton.layer.cornerRadius = 5.0f;

    ericLogo.alpha = 0.0;
    
    if (iPhone5) {
        teacherFrame = CGRectMake(self.teacherTextField.frame.origin.x, 260.0f, self.teacherTextField.frame.size.width, self.teacherTextField.frame.size.height);
        locationFrame = CGRectMake(self.locationTextField.frame.origin.x, 320.0f, self.locationTextField.frame.size.width, self.locationTextField.frame.size.height);
        teacherNewFrame = CGRectMake(self.teacherTextField.frame.origin.x, 150.0f, self.teacherTextField.frame.size.width, self.teacherTextField.frame.size.height);
        locationNewFrame = CGRectMake(self.locationTextField.frame.origin.x, 220.0f, self.locationTextField.frame.size.width, self.locationTextField.frame.size.height);
    }
    else if (iPhone6) {
        teacherFrame = CGRectMake(self.teacherTextField.frame.origin.x, 300.0f, self.teacherTextField.frame.size.width, self.teacherTextField.frame.size.height);
        locationFrame = CGRectMake(self.locationTextField.frame.origin.x, 380.0f, self.locationTextField.frame.size.width, self.locationTextField.frame.size.height);
        teacherNewFrame = CGRectMake(self.teacherTextField.frame.origin.x, 180.0f, self.teacherTextField.frame.size.width, self.teacherTextField.frame.size.height);
        locationNewFrame = CGRectMake(self.locationTextField.frame.origin.x, 240.0f, self.locationTextField.frame.size.width, self.locationTextField.frame.size.height);
    }
    else if (iPhone6Plus) {
        teacherFrame = CGRectMake(self.teacherTextField.frame.origin.x, 300.0f, self.teacherTextField.frame.size.width, self.teacherTextField.frame.size.height);
        locationFrame = CGRectMake(self.locationTextField.frame.origin.x, 380.0f, self.locationTextField.frame.size.width, self.locationTextField.frame.size.height);
        teacherNewFrame = CGRectMake(self.teacherTextField.frame.origin.x, 210.0f, self.teacherTextField.frame.size.width, self.teacherTextField.frame.size.height);
        locationNewFrame = CGRectMake(self.locationTextField.frame.origin.x, 290.0f, self.locationTextField.frame.size.width, self.locationTextField.frame.size.height);
    }
    else {
        teacherFrame = CGRectMake(self.teacherTextField.frame.origin.x, 240.0f, self.teacherTextField.frame.size.width, self.teacherTextField.frame.size.height);
        locationFrame = CGRectMake(self.locationTextField.frame.origin.x, 285.0f, self.locationTextField.frame.size.width, self.locationTextField.frame.size.height);
        teacherNewFrame = CGRectMake(self.teacherTextField.frame.origin.x, 90.0f, self.teacherTextField.frame.size.width, self.teacherTextField.frame.size.height);
        locationNewFrame = CGRectMake(self.locationTextField.frame.origin.x, 150.0f, self.locationTextField.frame.size.width, self.locationTextField.frame.size.height);
    }
    
}
-(void)viewDidLayoutSubviews {
    [self.teacherTextField setFrame:teacherFrame];
    [self.locationTextField setFrame:locationFrame];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.classesPicker=nil;
    self.teacherTextField=nil;
    self.locationTextField=nil;
    self.classCategory=nil;
    self.classesData=nil;
    self.specifiedClasses=nil;
    self.selectedData=nil;
    self.ericLogo=nil;
    self.doneButton=nil;
    
    // Release any retained subviews of the main view.
}
-(void)viewWillAppear:(BOOL)animated {
    [self.teacherTextField setFrame:teacherFrame];
    [self.locationTextField setFrame:locationFrame];
    
    [super viewWillAppear:animated];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return [self.classCategory count];
    }
    else {
        NSInteger categoryRow=[pickerView selectedRowInComponent:0];
        NSString *categoryName=[self.classCategory objectAtIndex:categoryRow];
        
        self.specifiedClasses=[self.classesData objectForKey:categoryName];
        return [self.specifiedClasses count];
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component==0) {
        return [classCategory objectAtIndex:row];
    }
    else {
        NSInteger categoryRow=[pickerView selectedRowInComponent:0];
        NSString *categoryName=[self.classCategory objectAtIndex:categoryRow];
        
        self.specifiedClasses = [self.classesData objectForKey:categoryName];
        if (row <= [self.specifiedClasses count]) {
            return [self.specifiedClasses objectAtIndex:row];
        }
        else {
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            return [NSString stringWithFormat:@""];
        }
    }
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component==0) {
        NSInteger categoryRow=[pickerView selectedRowInComponent:0];
        NSString *categoryName=[self.classCategory objectAtIndex:categoryRow];
        
        self.specifiedClasses=[self.classesData objectForKey:categoryName];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
    }
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat component1width=140;
    if (component==0) {
        return component1width;
    }
    else {
        return (320-component1width);
    }
}
#pragma mark - DataPasstoEditBoard
-(IBAction)doneButtonPressed:(id)sender{
    if ([delegate respondsToSelector:@selector(setEditedDataFromPicker:)]) {
        
        UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"You are about to create a class",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",nil) destructiveButtonTitle:NSLocalizedString(@"For All Days", nil) otherButtonTitles:[NSString stringWithFormat:NSLocalizedString(@"For %@ Day Only",nil),[self.selectedData objectForKey:@"dayDisplayedName"]], nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 2) {
        if ([delegate respondsToSelector:@selector(setEditedDataFromPicker:)]) {
            NSString *categoryName=[self.classCategory objectAtIndex:[self.classesPicker selectedRowInComponent:0]];
            NSArray *array=[self.classesData objectForKey:categoryName];
            NSString *className=[array objectAtIndex:[self.classesPicker selectedRowInComponent:1]];
            NSIndexPath *indexPath=[self.selectedData objectForKey:@"indexPath"];
            
            NSString *teacher=self.teacherTextField.text;
            NSString *location=self.locationTextField.text;
            
            BOOL isInRotaion = (buttonIndex == 0);
            
            
            NSDictionary *aDict=[[NSDictionary alloc]initWithObjectsAndKeys:indexPath,@"indexPath",className,@"className",teacher,@"teacherName",location,@"locationName",[NSNumber numberWithBool:isInRotaion],@"rotationName", nil];
            
            [delegate setValue:aDict forKey:@"editedDataFromPicker"];
            [delegate setValue:[NSNumber numberWithBool:YES] forKey:@"isEdited"];
            
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:@"Animate Up" context:nil];
	[UIView setAnimationDuration:.3];
	[UIView setAnimationBeginsFromCurrentState:YES];
    
    [self.teacherTextField setFrame:teacherNewFrame];
    [self.locationTextField setFrame:locationNewFrame];
    self.classesPicker.frame=CGRectMake(self.classesPicker.frame.origin.x, -216, self.classesPicker.frame.size.width, self.classesPicker.frame.size.height);

    [UIView commitAnimations];
    [UIView beginAnimations:@"Animate Appear" context:nil];
	[UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [self.ericLogo setAlpha:1.0];
    [UIView commitAnimations];
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView beginAnimations:@"Animate Text Field Down" context:nil];
	[UIView setAnimationDuration:.3];
	[UIView setAnimationBeginsFromCurrentState:YES];
    
    [self.teacherTextField setFrame:teacherFrame];
    [self.locationTextField setFrame:locationFrame];
    self.classesPicker.frame=CGRectMake(self.classesPicker.frame.origin.x, 0, self.classesPicker.frame.size.width, self.classesPicker.frame.size.height);
    
    [UIView commitAnimations];
    [UIView beginAnimations:@"Animate Disappear" context:nil];
	[UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [self.ericLogo setAlpha:0.0];
    [UIView commitAnimations];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [teacherTextField resignFirstResponder];
    [locationTextField resignFirstResponder];
}
-(IBAction)teacherFieldDone:(id)sender
{
    [locationTextField becomeFirstResponder];
}
-(NSString *)classesDataFilePath {
    NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = nil;
    if (SCHOOL_SECTION == kUserTypeSchoolSectionUpper) {
        filePath = [documentsDirectory stringByAppendingPathComponent:kUpperClassFileName];
    }
    else if (SCHOOL_SECTION == kUserTypeSchoolSectionMiddle) {
        filePath = [documentsDirectory stringByAppendingPathComponent:kMiddleClassFileName];

    }
    return filePath;
}

@end
