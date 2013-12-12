//
//  EColumnChartViewController.m
//  EChart
//
//  Created by Efergy China on 11/12/13.
//  Copyright (c) 2013年 Scott Zhu. All rights reserved.
//

#import "EColumnChartViewController.h"

@interface EColumnChartViewController ()

@end

@implementation EColumnChartViewController

@synthesize eColumnChart = _eColumnChart;


#pragma -mark- ViewController Life Circle
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
    
    _eColumnChart = [[EColumnChart alloc] initWithFrame:CGRectMake(30, 100, 300, 300)];
	[_eColumnChart setDelegate:self];
    [_eColumnChart setDataSource:self];
    [self.view addSubview:_eColumnChart];
    
}

- (void)viewWillAppear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark- EColumnChartDataSource

- (NSInteger)numberOfColumnsInEColumnChart:(EColumnChart *)eColumnChart
{
    return 0;
}

- (NSInteger)numberOfColumnsPresentedEveryTime:(EColumnChart *)eColumnChart
{
    return 5;
}

- (float)highestValueEColumnChart:(EColumnChart *)eColumnChart
{
    return 0;
}

- (float)eColumnChart:(EColumnChart *)eColumnChart valueForIndex:(NSInteger)index
{
    return 0;
}

@end
