//
//  ELineChartViewController.h
//  EChartDemo
//
//  Created by 朱 建慧 on 13-12-25.
//  Copyright (c) 2013年 Scott Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELineChart.h"
#import "ELineChartDataModel.h"

@interface ELineChartViewController : UIViewController<ELineChartDataSource, ELineChartDelegate>

@property (strong, nonatomic) ELineChart *eLineChart;
@property (weak, nonatomic) IBOutlet UILabel *numberTaped;


@end
