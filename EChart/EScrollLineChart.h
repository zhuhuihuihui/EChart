//
//  EScrollLineChart.h
//  EChartDemo
//
//  Created by Efergy China on 9/1/14.
//  Copyright (c) 2014年 Scott Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELineChartDataModel.h"

@class EScrollLineChart;

@protocol EScrollLineChartDataSource <NSObject>

@required
/** How many Points are there in total.*/
- (NSInteger) numberOfPointsInELineChart:(EScrollLineChart *) eLineChart;

/** How many Points should be presented on the screen each time*/
- (NSInteger) numberOfPointsPresentedEveryTime:(EScrollLineChart *) eLineChart;

/** The hightest vaule among the whole chart*/
- (ELineChartDataModel *)     highestValueELineChart:(EScrollLineChart *) eLineChart;

/** Value for each point*/
- (ELineChartDataModel *)    eLineChart:(EScrollLineChart *) eLineChart
                          valueForIndex:(NSInteger)index;
@optional

@end

//@protocol ELineChartDelegate <NSObject>
//
//@required
//
//@optional
//
//@end

@interface EScrollLineChart : UIScrollView
@property (nonatomic, readonly) NSInteger leftMostIndex;
@property (nonatomic, readonly) NSInteger rightMostIndex;

//@property (nonatomic, strong) UIColor *minColumnColor;
//@property (nonatomic, strong) UIColor *maxColumnColor;
//@property (nonatomic, strong) UIColor *normalColumnColor;


@property (weak, nonatomic) id <EScrollLineChartDataSource> dataSource;
//@property (weak, nonatomic) id <ELineChartDelegate> delegate;

/** Pull out the points hidden in the left*/
- (void)moveLeft;

/** Pull out the points hidden in the right*/
- (void)moveRight;
@end
