//
//  EViewSwitcherViewController.h
//  EChartDemo
//
//  Created by Scott Zhu on 14-1-30.
//  Copyright (c) 2014年 Scott Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EViewSwitcher.h"
#import "EPieChart.h"
#import "EColor.h"

@interface EViewSwitcherViewController : UIViewController<EViewSwitcherDataSource, EViewSwitcherDelegate>
@property (strong, nonatomic) EViewSwitcher *eViewSwitcher;

@property (strong, nonatomic) NSArray *arrayOfViews;
@end
