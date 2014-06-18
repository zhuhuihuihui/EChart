//
//  EColumnChartViewController.m
//  EChart
//
//  Created by Efergy China on 11/12/13.
//  Copyright (c) 2013 Scott Zhu. All rights reserved.
//

#import "EColumnChartViewController.h"
#import "EColumnDataModel.h"
#import "EColumnChartLabel.h"
#import "EFloatBox.h"
#import "EColor.h"
#include <stdlib.h>

@interface EColumnChartViewController ()

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) EFloatBox *eFloatBox;

@property (nonatomic, strong) EColumn *eColumnSelected;
@property (nonatomic, strong) UIColor *tempColor;

@end

@implementation EColumnChartViewController
@synthesize tempColor = _tempColor;
@synthesize eFloatBox = _eFloatBox;
@synthesize eColumnChart = _eColumnChart;
@synthesize data = _data;
@synthesize eColumnSelected = _eColumnSelected;
@synthesize valueLabel = _valueLabel;



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
        int value = arc4random() % 100;
        EColumnDataModel *eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:[NSString stringWithFormat:@"%d", i] value:value index:i unit:@"kWh"];
        [temp addObject:eColumnDataModel];
    }
    _data = [NSArray arrayWithArray:temp];
    
    
    _eColumnChart = [[EColumnChart alloc] initWithFrame:CGRectMake(40, 100, 250, 200)];
    //[_eColumnChart setNormalColumnColor:[UIColor purpleColor]];
    [_eColumnChart setColumnsIndexStartFromLeft:YES];
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

#pragma -mark- Actions
- (IBAction)highlightMaxAndMinChanged:(id)sender
{
    UISwitch *mySwith = (UISwitch *)sender;
    if ([mySwith isOn])
    {
        [_eColumnChart setShowHighAndLowColumnWithColor:YES];
    }
    else
    {
        [_eColumnChart setShowHighAndLowColumnWithColor:NO];
    }
}

- (IBAction)eventHandleChanged:(id)sender
{
    UISwitch *mySwith = (UISwitch *)sender;
    if ([mySwith isOn])
    {
        [_eColumnChart setDelegate:self];
    }
    else
    {
        [_eColumnChart setDelegate:nil];
    }
}

- (IBAction)shouldOnlyShowInteger:(id)sender
{
    UISwitch *mySwith = (UISwitch *)sender;
    if ([mySwith isOn])
    {
        [_eColumnChart removeFromSuperview];
        _eColumnChart = nil;
        _eColumnChart = [[EColumnChart alloc] initWithFrame:CGRectMake(40, 100, 250, 200)];
        [_eColumnChart setColumnsIndexStartFromLeft:YES];
        [_eColumnChart setShowHorizontalLabelsWithInteger:YES];
        [_eColumnChart setDelegate:self];
        [_eColumnChart setDataSource:self];
        [self.view addSubview:_eColumnChart];
    }
    else
    {
        [_eColumnChart removeFromSuperview];
        _eColumnChart = nil;
        _eColumnChart = [[EColumnChart alloc] initWithFrame:CGRectMake(40, 100, 250, 200)];
        [_eColumnChart setColumnsIndexStartFromLeft:YES];
        [_eColumnChart setDelegate:self];
        [_eColumnChart setDataSource:self];
        [self.view addSubview:_eColumnChart];
    }
}


- (IBAction)chartDirectionChanged:(id)sender
{
    UISwitch *mySwith = (UISwitch *)sender;
    if ([mySwith isOn])
    {
        [_eColumnChart removeFromSuperview];
        _eColumnChart = nil;
        _eColumnChart = [[EColumnChart alloc] initWithFrame:CGRectMake(40, 100, 250, 200)];
        [_eColumnChart setShowHorizontalLabelsWithInteger:YES];
        [_eColumnChart setDelegate:self];
        [_eColumnChart setDataSource:self];
        [self.view addSubview:_eColumnChart];
    }
    else
    {
        [_eColumnChart removeFromSuperview];
        _eColumnChart = nil;
        _eColumnChart = [[EColumnChart alloc] initWithFrame:CGRectMake(40, 100, 250, 200)];
        [_eColumnChart setDelegate:self];
        [_eColumnChart setDataSource:self];
        [self.view addSubview:_eColumnChart];
    }
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

- (EColumnDataModel *)highestValueEColumnChart:(EColumnChart *)eColumnChart
{
    EColumnDataModel *maxDataModel = nil;
    float maxValue = -FLT_MIN;
    for (EColumnDataModel *dataModel in _data)
    {
        if (dataModel.value > maxValue)
        {
            maxValue = dataModel.value;
            maxDataModel = dataModel;
        }
    }
    return maxDataModel;
}

- (EColumnDataModel *)eColumnChart:(EColumnChart *)eColumnChart valueForIndex:(NSInteger)index
{
    if (index >= [_data count] || index < 0) return nil;
    return [_data objectAtIndex:index];
}

//- (UIColor *)colorForEColumn:(EColumn *)eColumn
//{
//    if (eColumn.eColumnDataModel.index < 5)
//    {
//        return [UIColor purpleColor];
//    }
//    else
//    {
//        return [UIColor redColor];
//    }
//    
//}

#pragma -mark- EColumnChartDelegate
- (void)eColumnChart:(EColumnChart *)eColumnChart
     didSelectColumn:(EColumn *)eColumn
{
    NSLog(@"Index: %d  Value: %f", eColumn.eColumnDataModel.index, eColumn.eColumnDataModel.value);
    
    if (_eColumnSelected)
    {
        _eColumnSelected.barColor = _tempColor;
    }
    _eColumnSelected = eColumn;
    _tempColor = eColumn.barColor;
    eColumn.barColor = [UIColor blackColor];
    
    _valueLabel.text = [NSString stringWithFormat:@"%.1f",eColumn.eColumnDataModel.value];
}

- (void)eColumnChart:(EColumnChart *)eColumnChart
fingerDidEnterColumn:(EColumn *)eColumn
{
    /**The EFloatBox here, is just to show an example of 
     taking adventage of the event handling system of the Echart.
     You can do even better effects here, according to your needs.*/
    NSLog(@"Finger did enter %d", eColumn.eColumnDataModel.index);
    CGFloat eFloatBoxX = eColumn.frame.origin.x + eColumn.frame.size.width * 1.25;
    CGFloat eFloatBoxY = eColumn.frame.origin.y + eColumn.frame.size.height * (1-eColumn.grade);
    if (_eFloatBox)
    {
        [_eFloatBox removeFromSuperview];
        _eFloatBox.frame = CGRectMake(eFloatBoxX, eFloatBoxY, _eFloatBox.frame.size.width, _eFloatBox.frame.size.height);
        [_eFloatBox setValue:eColumn.eColumnDataModel.value];
        [eColumnChart addSubview:_eFloatBox];
    }
    else
    {
        _eFloatBox = [[EFloatBox alloc] initWithPosition:CGPointMake(eFloatBoxX, eFloatBoxY) value:eColumn.eColumnDataModel.value unit:@"kWh" title:@"Title"];
        _eFloatBox.alpha = 0.0;
        [eColumnChart addSubview:_eFloatBox];

    }
    eFloatBoxY -= (_eFloatBox.frame.size.height + eColumn.frame.size.width * 0.25);
    _eFloatBox.frame = CGRectMake(eFloatBoxX, eFloatBoxY, _eFloatBox.frame.size.width, _eFloatBox.frame.size.height);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        _eFloatBox.alpha = 1.0;
        
    } completion:^(BOOL finished) {
    }];
    
}

- (void)eColumnChart:(EColumnChart *)eColumnChart
fingerDidLeaveColumn:(EColumn *)eColumn
{
    NSLog(@"Finger did leave %d", eColumn.eColumnDataModel.index);

}

- (void)fingerDidLeaveEColumnChart:(EColumnChart *)eColumnChart
{
    if (_eFloatBox)
    {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            _eFloatBox.alpha = 0.0;
            _eFloatBox.frame = CGRectMake(_eFloatBox.frame.origin.x, _eFloatBox.frame.origin.y + _eFloatBox.frame.size.height, _eFloatBox.frame.size.width, _eFloatBox.frame.size.height);
        } completion:^(BOOL finished) {
            [_eFloatBox removeFromSuperview];
            _eFloatBox = nil;
        }];
        
    }

}

@end
