//
//  EScrollLineChartViewController.h
//  EChartDemo
//
//  Created by Efergy China on 9/1/14.
//  Copyright (c) 2014年 Scott Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EScrollLineChart.h"

@interface EScrollLineChartViewController : UIViewController<EScrollLineChartDataSource>
@property (strong, nonatomic) EScrollLineChart *eScrollLineChart;
@end
