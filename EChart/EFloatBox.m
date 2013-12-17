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

- (id)initWithVaule:(float)value
               unit:(NSString *)unit
              title:(NSString *)title
{
    
    self = [self initWithFrame:CGRectMake(0, 0, 50, 50)];
    if (self)
    {
        self.backgroundColor = ELightYellow;
        self.layer.cornerRadius = 2.0;
        
//        if (<#condition#>) {
//            <#statements#>
//        }
//        UILabel *title = [[UILabel alloc]init];
        
        [self sizeToFit];
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
