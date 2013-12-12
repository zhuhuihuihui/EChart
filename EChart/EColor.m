//
//  EColor.m
//  EChart
//
//  Created by Efergy China on 12/12/13.
//  Copyright (c) 2013年 Scott Zhu. All rights reserved.
//

#import "EColor.h"

@implementation EColor
-(id)init{
    if (self = [super init]) {
        
        
    }
    return self;
}



-(UIImage *)imageFromColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   [color CGColor]);
    //  [[UIColor colorWithRed:222./255 green:227./255 blue: 229./255 alpha:1] CGColor]) ;
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
@end
