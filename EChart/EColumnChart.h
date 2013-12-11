//
//  EColumnChart.h
//  EChart
//
//  Created by Efergy China on 11/12/13.
//  Copyright (c) 2013年 Scott Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EColumnChart;

@protocol EColumnChartDataSource <NSObject>

- (NSInteger) numberOfColumnsInEColumnChart:(EColumnChart *) eColumnChart;
- (NSInteger) numberOfColumnsPresentedEveryTime:(EColumnChart *) eColumnChart;
- (float)     highestValueEColumnChart:(EColumnChart *) eColumnChart;
- (float)     eColumnChart:(EColumnChart *) eColumnChart
             valueForIndex:(NSInteger)index;

@end


@protocol EColumnChartDelegate <NSObject>



@end

@interface EColumnChart : UIView



@property (weak, nonatomic) id <EColumnChartDataSource> dataSource;
@property (weak, nonatomic) id <EColumnChartDelegate> delegate;
@end
