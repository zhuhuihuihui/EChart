//
//  EColumnDataModel.m
//  EChart
//
//  Created by 朱 建慧 on 13-12-12.
//  Copyright (c) 2013年 Scott Zhu. All rights reserved.
//

#import "EColumnDataModel.h"

@implementation EColumnDataModel
@synthesize label = _label;
@synthesize value = _value;

- (id)init
{
    self = [super init];
    if (self)
    {
        _label = @"Empty";
        _value = 0;
    }
    return self;
}

- (id)initWithLabel:(NSString *)label
              Value:(float)vaule
{
    self = [self init];
    if (self)
    {
        _label = label;
        _value = vaule;
    }
    return self;
}


@end
