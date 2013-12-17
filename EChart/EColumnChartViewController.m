//
//  EColumnChartViewController.m
//  EChart
//
//  Created by Efergy China on 11/12/13.
//  Copyright (c) 2013年 Scott Zhu. All rights reserved.
//

#import "EColumnChartViewController.h"
#import "EColumnDataModel.h"

@interface EColumnChartViewController ()

@property (nonatomic, strong) NSArray *data;

@end

@implementation EColumnChartViewController

@synthesize eColumnChart = _eColumnChart;
@synthesize data = _data;


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
    
    
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i < 50; i++)
    {
        EColumnDataModel *eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:[NSString stringWithFormat:@"%d", i] value:i index:i];
        [temp addObject:eColumnDataModel];
    }
    _data = [NSArray arrayWithArray:temp];
    
    
    _eColumnChart = [[EColumnChart alloc] initWithFrame:CGRectMake(30, 100, 300, 200)];
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


- (IBAction)leftButtonPressed:(id)sender
{
    if (self.eColumnChart == nil) return;
    [self.eColumnChart moveLeft];
}

- (IBAction)rightButtonPressed:(id)sender
{
    if (self.eColumnChart == nil) return;
    [self.eColumnChart moveRight];
}



#pragma -mark- EColumnChartDataSource

- (NSInteger)numberOfColumnsInEColumnChart:(EColumnChart *)eColumnChart
{
    return [_data count];
}

- (NSInteger)numberOfColumnsPresentedEveryTime:(EColumnChart *)eColumnChart
{
    return 7;
}

- (float)highestValueEColumnChart:(EColumnChart *)eColumnChart
{
    return 49;
}

- (EColumnDataModel *)eColumnChart:(EColumnChart *)eColumnChart valueForIndex:(NSInteger)index
{
    if (index >= [_data count] || index < 0) return nil;
    return [_data objectAtIndex:index];
}

#pragma -mark- EColumnChartDelegate
- (void)        eColumnChart:(EColumnChart *)eColumnChart
      didSelectColumnAtIndex:(NSInteger)index
        withEColumnDataModel:(EColumnDataModel *)eColumnDataModel
{
    NSLog(@"Index: %d  Value: %f", eColumnDataModel.index, eColumnDataModel.value);
}

@end
