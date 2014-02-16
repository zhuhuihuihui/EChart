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

@property (nonatomic) float eLineChartScale;
@end

@implementation ELineChartViewController

@synthesize eLineChart = _eLineChart;
@synthesize eLineChartData = _eLineChartData;
@synthesize numberTaped = _numberTaped;
@synthesize eLineChartScale = _eLineChartScale;

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
    _eLineChartScale = 1;
    
    /** Generate data for _eLineChart*/
	NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0 ; i < 300; i++)
    {
        int number = arc4random() % 100;
        ELineChartDataModel *eLineChartDataModel = [[ELineChartDataModel alloc] initWithLabel:[NSString stringWithFormat:@"%d", i] value:number index:i unit:@"kWh"];
        [tempArray addObject:eLineChartDataModel];
    }
    _eLineChartData = [NSArray arrayWithArray:tempArray];
    
    /** The Actual frame for the line is half height of the frame you specified, because the bottom half is for the touch control, but it's empty */
    //_eLineChart = [[ELineChart alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.frame), 400)];
    _eLineChart = [[ELineChart alloc] initWithFrame:CGRectMake(0, 150, CGRectGetWidth(self.view.frame), 300)];
    //[_eLineChart setELineIndexStartFromRight: YES];
	[_eLineChart setDelegate:self];
    [_eLineChart setDataSource:self];
    [self.view addSubview:_eLineChart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma -mark- ELineChart DataSource
- (NSInteger) numberOfPointsInELineChart:(ELineChart *) eLineChart
{
    return [_eLineChartData count];
}

- (NSInteger) numberOfPointsPresentedEveryTime:(ELineChart *) eLineChart
{
//    NSInteger num = 20 * (1.0 / _eLineChartScale);
//    NSLog(@"%d", num);
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

- (void)eLineChart:(ELineChart *)eLineChart
     didTapAtPoint:(ELineChartDataModel *)eLineChartDataModel
{
    NSLog(@"%d %f", eLineChartDataModel.index, eLineChartDataModel.value);
    [_numberTaped setText:[NSString stringWithFormat:@"%.f", eLineChartDataModel.value]];
    
}

- (void)    eLineChart:(ELineChart *)eLineChart
 didHoldAndMoveToPoint:(ELineChartDataModel *)eLineChartDataModel
{
    [_numberTaped setText:[NSString stringWithFormat:@"%.f", eLineChartDataModel.value]];
}

- (void)fingerDidLeaveELineChart:(ELineChart *)eLineChart
{
    
}

- (void)eLineChart:(ELineChart *)eLineChart
    didZoomToScale:(float)scale
{
//    _eLineChartScale = scale;
//    [_eLineChart removeFromSuperview];
//    _eLineChart = nil;
//    _eLineChart = [[ELineChart alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.frame), 300)];
//	[_eLineChart setDelegate:self];
//    [_eLineChart setDataSource:self];
//    [self.view addSubview:_eLineChart];
}

#pragma -mark- Actions

- (IBAction)chartDirectionChanged:(id)sender
{
    UISwitch *mySwith = (UISwitch *)sender;
    if ([mySwith isOn])
    {
        [_eLineChart removeFromSuperview];
        _eLineChart = nil;
        _eLineChart = [[ELineChart alloc] initWithFrame:CGRectMake(0, 150, CGRectGetWidth(self.view.frame), 300)];
        [_eLineChart setELineIndexStartFromRight:YES];
        [_eLineChart setDelegate:self];
        [_eLineChart setDataSource:self];
        [self.view addSubview:_eLineChart];
    }
    else
    {
        [_eLineChart removeFromSuperview];
        _eLineChart = nil;
        _eLineChart = [[ELineChart alloc] initWithFrame:CGRectMake(0, 150, CGRectGetWidth(self.view.frame), 300)];
        [_eLineChart setDelegate:self];
        [_eLineChart setDataSource:self];
        [self.view addSubview:_eLineChart];
    }
}

@end
