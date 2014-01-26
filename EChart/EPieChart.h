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

@interface EPieChart : UIView

@property (strong, nonatomic) EPie *ePie;

@property (strong, nonatomic) EPie *backPie;

@property (nonatomic) BOOL isUpsideDown;

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