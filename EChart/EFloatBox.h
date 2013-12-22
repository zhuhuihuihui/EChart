//
//  EFloatBox.h
//  EChart
//
//  Created by Efergy China on 17/12/13.
//  Copyright (c) 2013 Scott Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EFloatBox : UILabel
@property (nonatomic) float value;
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, strong) NSString *title;


- (id)initWithPosition:(CGPoint)point
                 value:(float)value
                  unit:(NSString *)unit
                 title:(NSString *)title;
@end
