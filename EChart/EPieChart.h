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

@end

@interface EPie : UIView

@property (strong, nonatomic) EPieChartDataModel *ePieChartDataModel;

- (id)initWithCenter:(CGPoint) center
              radius:(CGFloat) radiu
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