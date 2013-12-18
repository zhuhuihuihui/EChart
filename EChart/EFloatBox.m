//
//  EFloatBox.m
//  EChart
//
//  Created by Efergy China on 17/12/13.
//  Copyright (c) 2013年 Scott Zhu. All rights reserved.
//

#import "EFloatBox.h"
#import "EColor.h"

@implementation EFloatBox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
              value:(float)value
               unit:(NSString *)unit
              title:(NSString *)title
{
    
    self = [self initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = ELightBlue;
        self.layer.cornerRadius = 2.0;
        
//        if (<#condition#>) {
//            <#statements#>
//        }
//        UILabel *title = [[UILabel alloc]init];
        
        [self sizeToFit];
    }
    return self;
}

- (id)initWithValue:(float)value
               unit:(NSString *)unit
              title:(NSString *)title
{
    NSInteger requestWidth = 0;
    NSInteger requestHeight = 0;
    
    UILabel *valueLabel = [[UILabel alloc] init];
    [valueLabel setNumberOfLines:1];
    [valueLabel setFont:[UIFont boldSystemFontOfSize:11.0f]];
    valueLabel.text = [NSString stringWithFormat:@"%.1f", value];
    
    UILabel *unitLabel = [[UILabel alloc] init];
    [unitLabel setNumberOfLines:1];
    [unitLabel setFont:[UIFont boldSystemFontOfSize:11.0f]];
    unitLabel.text = unit;
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
