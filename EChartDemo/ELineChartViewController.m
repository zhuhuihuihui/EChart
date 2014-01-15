//
//  ELineChartViewController.m
//  EChartDemo
//
//  Created by 朱 建慧 on 13-12-25.
//  Copyright (c) 2013年 Scott Zhu. All rights reserved.
//

#import "ELineChartViewController.h"
#include <stdlib.h>

@interface ELineChartViewController ()
@property (strong, nonatomic) NSArray *eLineChartData;
@end

@implementation ELineChartViewController

@synthesize eLineChart = _eLineChart;
@synthesize eLineChartData = _eLineChartData;
@synthesize numberTaped = _numberTaped;

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
    
    /** Generate data for _eLineChart*/
	NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0 ; i < 100; i++)
    {
        int number = arc4random() % 100;
        ELineChartDataModel *eLineChartDataModel = [[ELineChartDataModel alloc] initWithLabel:[NSString stringWithFormat:@"%d", i] value:number index:i unit:@"kWh"];
        [tempArray addObject:eLineChartDataModel];
    }
    _eLineChartData = [NSArray arrayWithArray:tempArray];
    
    /** The Actual frame for the line is half height of the frame you specified, because the bottom half is for the touch control, but it's empty */
    _eLineChart = [[ELineChart alloc] initWithFrame:CGRectMake(50, 100, 200, 200)];
    //_eLineChart = [[ELineChart alloc] initWithFrame:CGRectMake(40, 150, 250, 400) lineWidth:1.0 lineColor:[UIColor purpleColor]];
	[_eLineChart setDelegate:self];
    [_eLineChart setDataSource:self];
    [self.view addSubview:_eLineChart];
    [_eLineChart setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma -mark- ELineChart DataSource
- (NSInteger) numberOfPointsInELineChart:(ELineChart *) eLineChart
{
    //NSLog(@"%d", [_eLineChartData count]);
    return [_eLineChartData count];
}

- (NSInteger) numberOfPointsPresentedEveryTime:(ELineChart *) eLineChart
{
    return 20;
}

- (ELineChartDataModel *)     highestValueELineChart:(ELineChart *) eLineChart
{
    ELineChartDataModel *maxDataModel = nil;
    float maxValue = -FLT_MIN;
    for (ELineChartDataModel *dataModel in _eLineChartData)
    {
        if (dataModel.value > maxValue)
        {
            maxValue = dataModel.value;
            maxDataModel = dataModel;
        }
    }
    return maxDataModel;
}

- (ELineChartDataModel *)     eLineChart:(ELineChart *) eLineChart
                             valueForIndex:(NSInteger)index
{
    if (index >= [_eLineChartData count] || index < 0) return nil;
    return [_eLineChartData objectAtIndex:index];
}

#pragma -mark- ELineChart Delegate

- (void)eLineChartDidReachTheEnd:(ELineChart *)eLineChart
{
    NSLog(@"Did reach the end");
}

- (void)eLineChart:(ELineChart *)eLineChart didTapAtPoint:(ELineChartDataModel *)eLineChartDataModel
{
    NSLog(@"%d %f", eLineChartDataModel.index, eLineChartDataModel.value);
    [_numberTaped setText:[NSString stringWithFormat:@"%.f", eLineChartDataModel.value]];
    
}

- (void)eLineChart:(ELineChart *)eLineChart didHoldAndMoveToPoint:(ELineChartDataModel *)eLineChartDataModel
{
    [_numberTaped setText:[NSString stringWithFormat:@"%.f", eLineChartDataModel.value]];
}

- (void)fingerDidLeaveELineChart:(ELineChart *)eLineChart
{
    
}

#pragma -mark- Actions
- (IBAction)leftButtonPressed:(id)sender
{
    if (_eLineChart)
    {
        //[_eLineChart moveLeft];
    }
}

- (IBAction)rightButtonPressed:(id)sender
{
    if (_eLineChart)
    {
        //[_eLineChart moveRight];
    }
}


@end
