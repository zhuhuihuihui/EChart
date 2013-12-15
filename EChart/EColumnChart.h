//
//  EColumnChart.h
//  EChart
//
//  Created by Efergy China on 11/12/13.
//  Copyright (c) 2013年 Scott Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EColumn.h"
#import "EColumnDataModel.h"
@class EColumnChart;

@protocol EColumnChartDataSource <NSObject>

- (NSInteger) numberOfColumnsInEColumnChart:(EColumnChart *) eColumnChart;
- (NSInteger) numberOfColumnsPresentedEveryTime:(EColumnChart *) eColumnChart;
- (float)     highestValueEColumnChart:(EColumnChart *) eColumnChart;

- (EColumnDataModel *)     eColumnChart:(EColumnChart *) eColumnChart
                        valueForIndex:(NSInteger)index;
/**再提供一个定制column的接口，可以定制Ecolumn*/

@end


@protocol EColumnChartDelegate <NSObject>

- (void)        eColumnChart:(EColumnChart *) eColumnChart
      didSelectColumnAtIndex:(NSInteger)index
        withEColumnDataModel:(EColumnDataModel *)eColumnDataModel;

@end



@interface EColumnChart : UIView
@property (nonatomic) NSInteger leftMostIndex;
@property (nonatomic) NSInteger rightMostIndex;

@property (nonatomic, strong) UIColor *minColumnColor;
@property (nonatomic, strong) UIColor *maxColumnColor;
@property (nonatomic, strong) UIColor *normalColumnColor;


- (void)moveLeft;
- (void)moveRight;
- (void)initData;
- (void)reloadData;

@property (weak, nonatomic) id <EColumnChartDataSource> dataSource;
@property (weak, nonatomic) id <EColumnChartDelegate> delegate;
@end
