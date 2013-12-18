//
//  EColumnDataModel.h
//  EChart
//
//  Created by 朱 建慧 on 13-12-12.
//  Copyright (c) 2013年 Scott Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EColumnDataModel : NSObject

@property (strong, nonatomic) NSString *label;
@property (nonatomic) float value;
@property (nonatomic) NSInteger index;
@property (nonatomic, strong) NSString *unit;

- (id)initWithLabel:(NSString *)label
              value:(float)vaule
              index:(NSInteger)index
               unit:(NSString *)unit;

@end
