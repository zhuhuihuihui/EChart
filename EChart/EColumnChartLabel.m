//
//  EColumnChartLabel.m
//  EChart
//
//  Created by Efergy China on 13/12/13.
//  Copyright (c) 2013年 Scott Zhu. All rights reserved.
//

#import "EColumnChartLabel.h"
#import "EColor.h"

@implementation EColumnChartLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setLineBreakMode:NSLineBreakByWordWrapping];
        [self setMinimumScaleFactor:11.0f];
        [self setNumberOfLines:0];
        [self setFont:[UIFont boldSystemFontOfSize:11.0f]];
        [self setTextColor: EDeepGrey];
        self.backgroundColor = [UIColor clearColor];
        [self setTextAlignment:NSTextAlignmentLeft];
        self.userInteractionEnabled = YES;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
