//
//  ClassPickerController.m
//  StStephenSchedule
//
//  Created by Eric Liang on 6/22/12.
//  Copyright (c) 2012 St.Stephen's. All rights reserved.
//

#import "ClassPickerController.h"
#import "MainController.h"
#import "SSSClass.h"
#import "SSSSchedule.h"

@interface ClassPickerController()

@property (strong, nonatomic) NSDictionary *classesData;
@property (strong, nonatomic) NSArray *classCategory;

@end

@implementation ClassPickerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed)];
    [customBarItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = customBarItem;
    
    NSString *classesDataFileName = [self.editingSchedule isHighschool] ? @"sstxClasses_upper" : @"sstxClasses_middle";
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:classesDataFileName withExtension:@"plist"]];
    
    NSArray *unsorted = [dictionary allKeys];
    NSArray *sorted = [unsorted sortedArrayUsingSelector:@selector(compare:)];
    self.classCategory = sorted;
    self.classesData = dictionary;

    self.title = self.editingPeriod;
    if (self.editingClass)
    {
        self.teacherTextField.text = self.editingClass.teacher;
        self.locationTextField.text = self.editingClass.location;
        
        NSString *classCateName = [NSString stringWithFormat:@"@(・●・)@"];
        for (NSString *classCate in dictionary.allKeys) {
            if ([(NSArray *)[dictionary objectForKey:classCate] containsObject:self.editingClass.name]) {
                classCateName = classCate;
                break;
            }
        }
        NSInteger cateNum = [self.classCategory indexOfObject:classCateName];
        [self.classesPicker selectRow:cateNum inComponent:0 animated:YES];
        [self.classesPicker reloadComponent:1];
        [self.classesPicker selectRow:0 inComponent:1 animated:YES];
    }
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
        NSInteger categoryRow = [pickerView selectedRowInComponent:0];
        NSString *categoryName = [self.classCategory objectAtIndex:categoryRow];
        
        self.specifiedClasses = [self.classesData objectForKey:categoryName];
        return [self.specifiedClasses count];
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component==0) {
        return [self.classCategory objectAtIndex:row];
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

#pragma mark - DataPasstoEditBoard
-(void)doneButtonPressed{
    if (![self.delegate respondsToSelector:@selector(setEditingClass:)])
    {
        return;
    }
    MainController *mainController = (MainController *)self.delegate;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"You are about to create a class" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];

    SSSClass *editedClass = [SSSClass new];
    editedClass.name = [[self.classesData objectForKey:[self.classCategory objectAtIndex:[self.classesPicker selectedRowInComponent:0]]] objectAtIndex:[self.classesPicker selectedRowInComponent:1]];
    editedClass.location = self.locationTextField.text;
    editedClass.teacher = self.teacherTextField.text;

    [alert addAction:[UIAlertAction actionWithTitle:@"For All Days" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        NSLog(@"name: %@", editedClass.name);
        [mainController setEditingClass:editedClass];
        [mainController setEditingIsAll:YES];
        [mainController setShouldSave:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"For %C Day Only", [self.editingPeriod characterAtIndex:0]] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        // For one day
        [mainController setEditingClass:editedClass];
        [mainController setEditingIsAll:NO];
        [mainController setShouldSave:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.scrollView setContentOffset:CGPointMake(0, 200)];
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.teacherTextField resignFirstResponder];
    [self.locationTextField resignFirstResponder];
}
-(IBAction)teacherFieldDone:(UITextField *)sender
{
    [self.locationTextField becomeFirstResponder];
}

- (IBAction)locationFieldDone:(UITextField *)sender {
    
}

- (IBAction)backgroundTouched {
    [self.teacherTextField resignFirstResponder];
    [self.locationTextField resignFirstResponder];
}

@end
