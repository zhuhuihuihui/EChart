//
//  ELineChart.h
//  EChartDemo
//
//  Created by 朱 建慧 on 13-12-25.
//  Copyright (c) 2013年 Scott Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELineChartDataModel.h"
@class ELineChart;

@protocol ELineChartDataSource <NSObject>

@required
/** How many Points are there in total.*/
- (NSInteger) numberOfPointsInELineChart:(ELineChart *) eLineChart;

/** How many Points should be presented on the screen each time*/
- (NSInteger) numberOfPointsPresentedEveryTime:(ELineChart *) eLineChart;

/** The hightest vaule among the whole chart*/
- (ELineChartDataModel *)     highestValueELineChart:(ELineChart *) eLineChart;

/** Value for each point*/
- (ELineChartDataModel *)    eLineChart:(ELineChart *) eLineChart
                          valueForIndex:(NSInteger)index;
@optional

@end

@protocol ELineChartDelegate <NSObject>

@required

@optional

@end

@interface ELineChart : UIView

@property (nonatomic, readonly) NSInteger leftMostIndex;
@property (nonatomic, readonly) NSInteger rightMostIndex;

//@property (nonatomic, strong) UIColor *minColumnColor;
//@property (nonatomic, strong) UIColor *maxColumnColor;
//@property (nonatomic, strong) UIColor *normalColumnColor;


@property (weak, nonatomic) id <ELineChartDataSource> dataSource;
@property (weak, nonatomic) id <ELineChartDelegate> delegate;

/** Pull out the points hidden in the left*/
- (void)moveLeft;

/** Pull out the points hidden in the right*/
- (void)moveRight;
@end
