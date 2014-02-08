//
//  EPieChartViewController.h
//  EChartDemo
//
//  Created by Efergy China on 24/1/14.
//  Copyright (c) 2014年 Scott Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPieChart.h"
@interface EPieChartViewController : UIViewController<EPieChartDelegate, EPieChartDataSource>
@property (weak, nonatomic) IBOutlet UIButton *turnPageButton;

@property (strong, nonatomic) EPieChart *ePieChart;

@end
