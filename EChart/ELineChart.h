//
//  ELineChart.h
//  EChartDemo
//
//  Created by 朱 建慧 on 13-12-25.
//  Copyright (c) 2013年 Scott Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELineChartDataModel.h"
#import "ELine.h"
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
- (void) eLineChartDidReachTheEnd:(ELineChart *)eLineChart;

- (void) eLineChart:(ELineChart *)eLineChart
      didTapAtPoint:(ELineChartDataModel *)eLineChartDataModel;

- (void)    eLineChart:(ELineChart *)eLineChart
 didHoldAndMoveToPoint:(ELineChartDataModel *)eLineChartDataModel;

- (void) fingerDidLeaveELineChart:(ELineChart *)eLineChart;

- (void) eLineChart:(ELineChart *)eLineChart
     didZoomToScale:(float)scale;



@optional

@end


@interface ELineChart : UIView <ELineDataSource, UIScrollViewDelegate>

@property (nonatomic, readonly) NSInteger leftMostIndex;
@property (nonatomic, readonly) NSInteger rightMostIndex;

@property (nonatomic) NSInteger lineWidth;
@property (nonatomic, strong) UIColor *lineColor;

//@property (nonatomic, strong) UIColor *minColumnColor;
//@property (nonatomic, strong) UIColor *maxColumnColor;
//@property (nonatomic, strong) UIColor *normalColumnColor;


@property (weak, nonatomic) id <ELineChartDataSource> dataSource;
@property (weak, nonatomic) id <ELineChartDelegate> delegate;

- (id)initWithFrame:(CGRect)frame
          lineWidth:(NSInteger)lineWidth
          lineColor:(UIColor *)lineColor;

@end
