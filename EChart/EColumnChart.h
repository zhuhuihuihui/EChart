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
- (EColumnDataModel *)     highestValueEColumnChart:(EColumnChart *) eColumnChart;

- (EColumnDataModel *)     eColumnChart:(EColumnChart *) eColumnChart
                        valueForIndex:(NSInteger)index;
/**再提供一个定制column的接口，可以定制Ecolumn*/

@end


@protocol EColumnChartDelegate <NSObject>

- (void)        eColumnChart:(EColumnChart *) eColumnChart
             didSelectColumn:(EColumn *) eColumn;

- (void)        eColumnChart:(EColumnChart *) eColumnChart
        fingerDidEnterColumn:(EColumn *) eColumn;

/**When finger leaves certain column, will 
 tell you which column you are leaving*/
- (void)        eColumnChart:(EColumnChart *) eColumnChart
        fingerDidLeaveColumn:(EColumn *) eColumn;

/**When finger leaves wherever in the chart, 
 will trigger both if finger is leaving from a column */
- (void) fingerDidLeaveEColumnChart:(EColumnChart *)eColumnChart;

@end



@interface EColumnChart : UIView <EColumnDelegate>
@property (nonatomic) NSInteger leftMostIndex;
@property (nonatomic) NSInteger rightMostIndex;

@property (nonatomic, strong) UIColor *minColumnColor;
@property (nonatomic, strong) UIColor *maxColumnColor;
@property (nonatomic, strong) UIColor *normalColumnColor;

@property (nonatomic) BOOL showHighAndLowColumnWithColor;


- (void)moveLeft;
- (void)moveRight;
- (void)initData;
- (void)reloadData;

@property (weak, nonatomic) id <EColumnChartDataSource> dataSource;
@property (weak, nonatomic) id <EColumnChartDelegate> delegate;
@end
