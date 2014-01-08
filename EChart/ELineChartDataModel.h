//
//  ELineChartDataModel.h
//  EChartDemo
//
//  Created by Scott Zhu on 14-1-5.
//  Copyright (c) 2014年 Scott Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELineChartDataModel : NSObject
@property (strong, nonatomic) NSString *label;
@property (nonatomic) float value;
@property (nonatomic) NSInteger index;
@property (nonatomic, strong) NSString *unit;

- (id)initWithLabel:(NSString *)label
              value:(float)vaule
              index:(NSInteger)index
               unit:(NSString *)unit;
@end
