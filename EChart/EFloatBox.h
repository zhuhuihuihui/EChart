//
//  EFloatBox.h
//  EChart
//
//  Created by Efergy China on 17/12/13.
//  Copyright (c) 2013年 Scott Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EFloatBox : UIView
@property (nonatomic) float value;
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, strong) NSString *title;

- (id)initWithFrame:(CGRect)frame
              value:(float)value
               unit:(NSString *)unit
              title:(NSString *)title;

- (id)initWithValue:(float)value
               unit:(NSString *)unit
              title:(NSString *)title;

@end
