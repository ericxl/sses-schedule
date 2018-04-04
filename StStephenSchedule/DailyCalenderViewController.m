//
//  DailyCalenderViewController.m
//  StStephenSchedule
//
//  Created by Eric Liang on 8/2/12.
//  Copyright (c) 2012 St.Stephen's. All rights reserved.
//

#import "DailyCalenderViewController.h"
#import "Common.h"
@interface DailyCalenderViewController ()

@end

@implementation DailyCalenderViewController
@synthesize upper_middle_segment;
@synthesize scrollView = _scrollView;
@synthesize upperContentView = _upperContentView;
@synthesize middleContentView = _middleContentView;

static CGRect upperViewFrame;
static CGRect middleViewFrame;


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
    
    upperViewFrame=CGRectMake(0, 50, self.view.bounds.size.width, 870);
    middleViewFrame=CGRectMake(0, 50, self.view.bounds.size.width, 792);

    
    CGSize upperViewSize = self.upperContentView.bounds.size;
    //CGSize middleViewSize = self.middleContentView.bounds.size;
    self.upperContentView.frame = upperViewFrame;
    self.middleContentView.frame= middleViewFrame;
    
    [self.scrollView addSubview:self.upperContentView];
    self.scrollView.contentSize = upperViewSize;
    
    [upper_middle_segment setTitle:NSLocalizedString(@"Upper",nil) forSegmentAtIndex:0];
    [upper_middle_segment setTitle:NSLocalizedString(@"Middle",nil) forSegmentAtIndex:1];
    
    self.title = NSLocalizedString(@"Daily Calendar", nil);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    
	// Do any additional setup after loading the view.
  
    upper_middle_segment.selectedSegmentIndex=0;
    
}

-(IBAction)upperLowerValueChange:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0://choose upper
            if (self.middleContentView.superview!=nil) {
                [self.middleContentView removeFromSuperview];
            }
            CGSize upperViewSize = self.upperContentView.bounds.size;
            [self.scrollView addSubview:self.upperContentView];
            self.scrollView.contentSize = upperViewSize;
            break;
            
        case 1://choose middle
            if (self.upperContentView.superview!=nil) {
                [self.upperContentView removeFromSuperview];
            }
            CGSize middleViewSize = self.middleContentView.bounds.size;
            [self.scrollView addSubview:self.middleContentView];
            self.scrollView.contentSize = middleViewSize;
            break;
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
