//
//  EViewSwitcherViewController.m
//  EChartDemo
//
//  Created by Scott Zhu on 14-1-30.
//  Copyright (c) 2014年 Scott Zhu. All rights reserved.
//

#import "EViewSwitcherViewController.h"

@interface EViewSwitcherViewController ()

@end

@implementation EViewSwitcherViewController
@synthesize arrayOfViews = _arrayOfViews;
@synthesize eViewSwitcher = _eViewSwitcher;

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
	
    /** Init Views need to present*/
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i < 3; i++)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        view.backgroundColor = EGreen;
        
        
        [temp addObject:view];
    }
    _arrayOfViews = [NSArray arrayWithArray:temp];
    
    if (!_eViewSwitcher)
    {
        _eViewSwitcher = [[EViewSwitcher alloc] initWithFrame:CGRectMake(0, 150, CGRectGetWidth(self.view.frame) , 200)];
        [_eViewSwitcher setDelegate:self];
        [_eViewSwitcher setDataSource:self];
        
    }
    
    [self.view addSubview:_eViewSwitcher];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark- EViewSwitcherDataSource
- (NSInteger)numberOfViewsInEViewSwitcher:(EViewSwitcher *)eViewSwitcher
{
    return [_arrayOfViews count];
}


- (UIView *) eSwitcher:(EViewSwitcher *)eViewSwitcher
           viewAtIndex:(NSInteger)index
{
    return [_arrayOfViews objectAtIndex:index];
}

#pragma -mark- EViewSwitcherDelegate

@end
