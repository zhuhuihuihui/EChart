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
	// Do any additional setup after loading the view.
    
    EPieChart *ePieChart = [[EPieChart alloc] initWithFrame:CGRectMake(100, 150, 150, 150)];
    ePieChart.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    [ePieChart setDelegate:self];
    
    [self.view addSubview:ePieChart];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)            ePieChart:(EPieChart *)ePieChart
didTurnToBackViewWithBackView:(UIView *)backView
{
//    UILabel *label = [[UILabel alloc] initWithFrame:backView.bounds];
//    label.text = @"hello";
//    [label setTextAlignment:NSTextAlignmentCenter];
//    label.center = CGPointMake(CGRectGetMidX(backView.bounds), CGRectGetMidY(backView.bounds));
//    [backView addSubview:label];
}

- (void)ePieChart:(EPieChart *)ePieChart didTurnToFrontViewWithFrontView:(UIView *)frontView
{
    
}

@end
