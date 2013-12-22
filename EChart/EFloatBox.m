//
//  EFloatBox.m
//  EChart
//
//  Created by Efergy China on 17/12/13.
//  Copyright (c) 2013 Scott Zhu. All rights reserved.
//

#import "EFloatBox.h"
#import "EColor.h"

@implementation EFloatBox
@synthesize value = _value;
@synthesize unit = _unit;
@synthesize title = _title;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}


- (id)initWithPosition:(CGPoint)point
                 value:(float)value
                  unit:(NSString *)unit
                 title:(NSString *)title
{
    self = [self initWithFrame:CGRectMake(point.x, point.y, 100, 100)];
    if (self)
    {
        _title = title;
        _value = value;
        _unit = unit;
        
        self.text = [self makeString];;
        self.backgroundColor = EBlueGreenColor;
        self.layer.cornerRadius = 3.0;
        //[self setFont:[UIFont systemFontOfSize:10.0f]];
        [self setFont:[UIFont fontWithName:@"ChalkboardSE-Regular" size:10.0f]];
        [self setTextColor: [UIColor blackColor]];
        [self setTextAlignment:NSTextAlignmentCenter];
        
        [self sizeToFit];
    }
    return self;
    
    
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize resultSize = [super sizeThatFits:size];
    resultSize = CGSizeMake(resultSize.width + 8, resultSize.height + 4);
    return resultSize;
}


- (void)setValue:(float)value
{
    _value = value;
    self.text = [self makeString];
}

- (NSString *)makeString
{
    NSString *finalText = nil;
    if (_title)
    {
        [self setNumberOfLines:2];
        if (_unit)
        {
            finalText = [_title stringByAppendingString:[[NSString stringWithFormat:@"\n%.1f ", _value] stringByAppendingString:_unit]];
        }
        else
        {
            finalText = [_title stringByAppendingString:[NSString stringWithFormat:@"\n%.1f", _value]];
        }
    }
    else
    {
        [self setNumberOfLines:1];
        if (_unit)
        {
            finalText = [[NSString stringWithFormat:@"%.1f ", _value] stringByAppendingString:_unit];
        }
        else
        {
            finalText = [NSString stringWithFormat:@"%.1f", _value];
        }
    }
    
    return finalText;
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
