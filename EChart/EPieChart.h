//
//  EPieChart.h
//  EChartDemo
//
//  Created by Efergy China on 24/1/14.
//  Copyright (c) 2014年 Scott Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EPie;
@class EPieChartDataModel;
@class EPieChart;

@protocol EPieChartDataSource <NSObject>

@optional
/** You can customize the front view by implimenting
    this dataSoure, If it's not implimented, it will use
    default view*/
- (UIView *) frontViewForEPieChart:(EPieChart *) ePieChart;

/** You can customize the back view by implimenting
 this dataSoure, If it's not implimented, it will use
 default view*/
- (UIView *) backViewForEPieChart:(EPieChart *) ePieChart;

@end

@protocol EPieChartDelegate <NSObject>

@optional
- (void)                ePieChart:(EPieChart *)ePieChart
  didTurnToFrontViewWithFrontView:(UIView *)frontView;

- (void)                ePieChart:(EPieChart *)ePieChart
    didTurnToBackViewWithBackView:(UIView *)backView;

@end


@interface EPieChart : UIView

@property (strong, nonatomic) EPie *ePie;

@property (strong, nonatomic) EPie *backPie;

@property (nonatomic) BOOL isUpsideDown;

@property (weak, nonatomic) id <EPieChartDelegate> delegate;

@property (weak ,nonatomic) id <EPieChartDataSource> dataSource;

@end

@interface EPie : UIView

@property (nonatomic) CGFloat lineWidth;

@property (strong, nonatomic) UIColor *budgetColor;
@property (strong, nonatomic) UIColor *currentColor;
@property (strong, nonatomic) UIColor *estimateColor;

@property (strong, nonatomic) EPieChartDataModel *ePieChartDataModel;

- (id)initWithCenter:(CGPoint) center
              radius:(CGFloat) radius;

- (id)initWithCenter:(CGPoint) center
              radius:(CGFloat) radius
  ePieChartDataModel:(EPieChartDataModel *)ePieChartDataModel;
@end


@interface EPieChartDataModel : NSObject
@property (nonatomic) CGFloat budget;
@property (nonatomic) CGFloat current;
@property (nonatomic) CGFloat estimate;

- (id)initWithBudget:(CGFloat) budget
             current:(CGFloat) current
            estimate:(CGFloat) estimate;
@end