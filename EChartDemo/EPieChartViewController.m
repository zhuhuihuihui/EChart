//
//  EPieChartViewController.m
//  EChartDemo
//
//  Created by Efergy China on 24/1/14.
//  Copyright (c) 2014年 Scott Zhu. All rights reserved.
//

#import "EPieChartViewController.h"

@interface EPieChartViewController ()

@end

@implementation EPieChartViewController

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
	EPieChartDataModel *ePieChartDataModel = [[EPieChartDataModel alloc] initWithBudget:133 current:33 estimate:77];
    
//    EPieChart *ePieChart = [[EPieChart alloc] initWithFrame:CGRectMake(100, 150, 150, 150)];
    EPieChart *ePieChart = [[EPieChart alloc] initWithFrame:CGRectMake(100, 150, 150, 150)
                                         ePieChartDataModel:ePieChartDataModel];
    ePieChart.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
//    [ePieChart.frontPie setLineWidth:1];
//    [ePieChart.frontPie setRadius:30];
//    ePieChart.frontPie.currentColor = [UIColor redColor];
//    ePieChart.frontPie.budgetColor = [UIColor grayColor];
//    ePieChart.frontPie.estimateColor = [UIColor blueColor];
    [ePieChart setDelegate:self];
    [ePieChart setDataSource:self];
    
    [self.view addSubview:ePieChart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark- EPieChartDelegate

- (void)            ePieChart:(EPieChart *)ePieChart
didTurnToBackViewWithBackView:(UIView *)backView
{
//    UILabel *label = [[UILabel alloc] initWithFrame:backView.bounds];
//    label.text = @"hello";
//    [label setTextAlignment:NSTextAlignmentCenter];
//    label.center = CGPointMake(CGRectGetMidX(backView.bounds), CGRectGetMidY(backView.bounds));
//    [backView addSubview:label];
}

- (void)              ePieChart:(EPieChart *)ePieChart
didTurnToFrontViewWithFrontView:(UIView *)frontView
{
    
}

#pragma -mark- EPieChartDataSource
- (UIView *)backViewForEPieChart:(EPieChart *)ePieChart
{
    UIView *customizedView = [[UIView alloc] initWithFrame:ePieChart.backPie.bounds];
    customizedView.layer.cornerRadius = CGRectGetWidth(customizedView.bounds) / 2;
    
    UILabel *label = [[UILabel alloc] initWithFrame:customizedView.frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 3;
    label.font = [UIFont fontWithName:@"Menlo" size:15];
    label.text = @"This is Customized view";
    [customizedView addSubview:label];
    
    return customizedView;
}



@end
