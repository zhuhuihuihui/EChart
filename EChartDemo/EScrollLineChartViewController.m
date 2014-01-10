//
//  EScrollLineChartViewController.m
//  EChartDemo
//
//  Created by Efergy China on 9/1/14.
//  Copyright (c) 2014年 Scott Zhu. All rights reserved.
//

#import "EScrollLineChartViewController.h"

@interface EScrollLineChartViewController ()
@property (strong, nonatomic) NSArray *eScrollLineChartData;
@end

@implementation EScrollLineChartViewController
@synthesize eScrollLineChart = _eScrollLineChart;
@synthesize eScrollLineChartData = _eScrollLineChartData;

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
	// Do any additional setup after loading the view.
    
    /** Generate data for _eLineChart*/
	NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0 ; i < 1000; i++)
    {
        int number = arc4random() % 100;
        ELineChartDataModel *eLineChartDataModel = [[ELineChartDataModel alloc] initWithLabel:[NSString stringWithFormat:@"%d", i] value:number index:i unit:@"kWh"];
        [tempArray addObject:eLineChartDataModel];
    }
    _eScrollLineChartData = [NSArray arrayWithArray:tempArray];
    
    _eScrollLineChart = [[EScrollLineChart alloc] initWithFrame:CGRectMake(40, 100, 250, 200)];
    [_eScrollLineChart setDataSource:self];
    [self.view addSubview:_eScrollLineChart];
    [_eScrollLineChart setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -mark- ELineChart DataSource
- (NSInteger) numberOfPointsInELineChart:(EScrollLineChart *) eLineChart
{
    return [_eScrollLineChartData count];
}

- (NSInteger) numberOfPointsPresentedEveryTime:(EScrollLineChart *) eLineChart
{
    return 20;
}

- (ELineChartDataModel *)     highestValueELineChart:(EScrollLineChart *) eLineChart
{
    ELineChartDataModel *maxDataModel = nil;
    float maxValue = -FLT_MIN;
    for (ELineChartDataModel *dataModel in _eScrollLineChartData)
    {
        if (dataModel.value > maxValue)
        {
            maxValue = dataModel.value;
            maxDataModel = dataModel;
        }
    }
    return maxDataModel;
}

- (ELineChartDataModel *)     eLineChart:(EScrollLineChart *) eLineChart
                           valueForIndex:(NSInteger)index
{
    if (index >= [_eScrollLineChartData count] || index < 0) return nil;
    return [_eScrollLineChartData objectAtIndex:index];
}
@end
