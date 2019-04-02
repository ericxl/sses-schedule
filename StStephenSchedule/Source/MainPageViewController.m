//
//  MainPageViewController.m
//  StStephenSchedule
//
//  Created by Eric Liang on 4/1/19.
//  Copyright © 2019 St.Stephen's. All rights reserved.
//

#import "MainPageViewController.h"
#import "MainController.h"
#import "SettingView.h"
#import "SSSSchedule.h"

@interface MainPageViewController ()

@property (strong, nonatomic) SSSSchedule *displayingSchedule;
@property (strong, nonatomic) SSSSchedule *editingSchedule;
@property (strong, nonatomic) NSString *displayingDay;

@property (nonatomic, strong) NSArray *controllers;

@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = self;
    self.delegate = self;

    self.displayingSchedule = [self loadSchedule];
    self.editingSchedule = [self loadSchedule];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setModalPresentationStyle:UIModalPresentationFullScreen];
    NSMutableArray *array = [NSMutableArray new];
    for (int i = 0; i < 7; i++)
    {
        MainController *ct = [self.storyboard instantiateViewControllerWithIdentifier:@"MainView"];
        ct.displayingDay = [NSString stringWithFormat:@"%C", [@"ABCDEFG" characterAtIndex:i]];;
        ct.schedule = self.displayingSchedule;
        ct.editingSchedule = self.editingSchedule;
        
        [array addObject:ct];
    }
    self.controllers = array;
    [self setViewControllers:@[self.controllers.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *dayString = [self getLetterDayFromApache];
        if (dayString != nil)
        {
            self.displayingDay = dayString;
            __weak MainPageViewController *welf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                //[welf setTitle:[NSString stringWithFormat:@"%@ day", self.displayingDay]];
            });
        }
    });
    
    
    
    [self updateNavBar:NO];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerAfterViewController:(nonnull UIViewController *)viewController {
    NSUInteger index = [self.controllers indexOfObject:viewController];
    if (index != self.controllers.count - 1)
        return [self.controllers objectAtIndex:index + 1];
    return nil;
}

- (nullable UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerBeforeViewController:(nonnull UIViewController *)viewController {
    NSUInteger index = [self.controllers indexOfObject:viewController];
    if (index != 0)
        return [self.controllers objectAtIndex:index - 1];
    return nil;
}

 - (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.controllers.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.controllers indexOfObject: self.viewControllers.firstObject];
}
//- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
//    <#code#>
//}
//
//- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
//    <#code#>
//}
//
//- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    <#code#>
//}
//
//- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
//    <#code#>
//}
//
//- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    <#code#>
//}
//
//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    <#code#>
//}
//
//- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    <#code#>
//}
//
//- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
//    <#code#>
//}
//
//- (void)setNeedsFocusUpdate {
//    <#code#>
//}
//
//- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
//    <#code#>
//}
//
//- (void)updateFocusIfNeeded {
//    <#code#>
//}

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
    //[self.myTableView setEditing:YES animated:YES];
    //[self.myTableView reloadData];
    [self updateNavBar:YES];
}

- (void)handleSettings {
    SettingView *settingView = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingView"];
    [self.navigationController pushViewController:settingView animated:YES];
}

- (void)handleCancel{
    [self updateNavBar:NO];
//    self.editingSchedule = [self loadSchedule];
//    [self.myTableView setEditing:NO animated:YES];
//    [self.myTableView reloadData];
}

- (void)handleSave {
    [self updateNavBar:NO];
//    [self saveSchedule:self.editingSchedule];
//    self.displayingSchedule = [self loadSchedule];
//    self.editingSchedule = [self loadSchedule];
//    [self.myTableView setEditing:NO animated:YES];
//    [self.myTableView reloadData];
}

@end
