//
//  ELine.m
//  EChartDemo
//
//  Created by Efergy China on 15/1/14.
//  Copyright (c) 2014年 Scott Zhu. All rights reserved.
//

#import "ELine.h"

@interface ELine ()
@property (nonatomic) CGFloat horizentalGap;

@end

@implementation ELine
@synthesize lineWidth = _lineWidth;
@synthesize lineColor = _lineColor;
@synthesize shapeLayer = _shapeLayer;
@synthesize dot = _dot;
@synthesize dataSource = _dataSource;
@synthesize horizentalGap = _horizentalGap;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
          lineColor:(UIColor *)lineColor
          lineWidth:(NSInteger)lineWidth
{
    self = [self initWithFrame:frame];
    if (self)
    {
        _lineColor = lineColor;
        _lineWidth = lineWidth;
        
        //[self setBackgroundColor:[UIColor purpleColor]];
    }
    
    return self;
}

- (void)setDataSource:(id<ELineDataSource>)dataSource
{
    if (dataSource && dataSource != _dataSource)
    {
        _dataSource = dataSource;
    }
}

- (void) reloadDataWithAnimation: (BOOL) shouldAnimation
{
    [_dot.layer removeAllAnimations];
    _dot = nil;
    
    if (!_shapeLayer)
    {
        _shapeLayer = [CAShapeLayer layer];
    }
    /** 1. Configure Layer*/
    _shapeLayer.zPosition = 0.0f;
    _shapeLayer.strokeColor = _lineColor.CGColor;
    _shapeLayer.lineWidth = _lineWidth;
    _shapeLayer.lineCap = kCALineCapRound;
    _shapeLayer.lineJoin = kCALineJoinRound;
    _shapeLayer.frame = self.frame;
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    /** 2. Construct the Path*/
    /** In order to leave some space for the heightest point */
    CGFloat highestPointValue = [_dataSource highestValueInELine:self].value * 1.1;
    _horizentalGap = CGRectGetWidth(self.bounds) / ([_dataSource numberOfPointsInELine:self] - 1);
    
    UIBezierPath *eLineChartPath = [UIBezierPath bezierPath];
    eLineChartPath.miterLimit = -5.0;
    UIBezierPath *animFromPath = [UIBezierPath bezierPath];
    CGFloat firstPointValue = [_dataSource eLine:self valueForIndex: 0].value;
    [eLineChartPath moveToPoint:CGPointMake(0, CGRectGetHeight(_shapeLayer.bounds) - CGRectGetHeight(_shapeLayer.bounds) * (firstPointValue / highestPointValue))];
    [animFromPath moveToPoint:CGPointMake(0, CGRectGetHeight(_shapeLayer.bounds))];
    for (NSInteger i = 1; i < [_dataSource numberOfPointsInELine:self]; i++)
    {
        CGFloat pointValue = [_dataSource eLine:self valueForIndex: i].value;
        [eLineChartPath addLineToPoint:CGPointMake(i * _horizentalGap, CGRectGetHeight(_shapeLayer.bounds) - CGRectGetHeight(_shapeLayer.bounds) * (pointValue / highestPointValue))];
        [animFromPath addLineToPoint:CGPointMake(i * _horizentalGap, CGRectGetHeight(_shapeLayer.bounds))];
    }
    
    
    /** 3. Add Path to layer*/
    _shapeLayer.path = eLineChartPath.CGPath;
    
    
    
    /** 4. Add Animation to The Layer*/
    if (shouldAnimation)
    {
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
        [anim setRemovedOnCompletion:YES];
        anim.fromValue = (id)animFromPath.CGPath;
        anim.toValue = (id)eLineChartPath.CGPath;
        anim.duration = 0.75f;
        anim.removedOnCompletion = NO;
        anim.fillMode = kCAFillModeForwards;
        anim.autoreverses = NO;
        anim.repeatCount = 0;
        [anim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [_shapeLayer addAnimation:anim forKey:@"path"];
    }
    else
    {
        [_shapeLayer removeAnimationForKey:@"path"];
    }
    
    [self.layer addSublayer:_shapeLayer];
    
}


- (void) putDotAt:(NSInteger)index
{
    CGFloat height = CGRectGetHeight(_shapeLayer.bounds);
    CGFloat dotY = height - (height * ([_dataSource eLine:self valueForIndex:index].value / ([_dataSource highestValueInELine:self].value * 1.1)));
    CGPoint dotPosition = CGPointMake(index * _horizentalGap, dotY);
    
    if (!_dot)
    {
        _dot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _lineWidth * 4, _lineWidth * 4)];
        [_dot setBackgroundColor:_lineColor];
        _dot.layer.cornerRadius = _lineWidth * 2;
        [_dot setCenter:dotPosition];
    }
    _dot.alpha = 1;
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut  animations:^{
        [_dot setCenter:dotPosition];
    } completion:nil];
    
    [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _dot.alpha = 0;
        
    } completion:^(BOOL finished) {
        
    }];

    NSLog(@"x = %.1f", _dot.frame.origin.x);
    [self addSubview:_dot];

    //TODO: When the path changed, the dot gonna still be there
}

#pragma -mark- UIView Delegate
- (void)setTransform:(CGAffineTransform)newValue;
{
    newValue.d = 1.0;
    [super setTransform:newValue];
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
