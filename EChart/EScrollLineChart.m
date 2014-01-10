//
//  EScrollLineChart.m
//  EChartDemo
//
//  Created by Efergy China on 9/1/14.
//  Copyright (c) 2014年 Scott Zhu. All rights reserved.
//

#import "EScrollLineChart.h"
@interface EScrollLineChart()
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@end

@implementation EScrollLineChart

@synthesize dataSource = _dataSource;
//@synthesize delegate = _delegate;
@synthesize leftMostIndex = _leftMostIndex;
@synthesize rightMostIndex = _rightMostIndex;
@synthesize shapeLayer = _shapeLayer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

#pragma -mark- Setter and Getter
- (void)setDataSource:(id<EScrollLineChartDataSource>)dataSource
{
    if (dataSource && _dataSource != dataSource)
    {
        _dataSource = dataSource;
        /** Check if every dataSource is implemented*/
        _leftMostIndex = 0;
        _rightMostIndex = [_dataSource numberOfPointsPresentedEveryTime:self] - 1;
        
        CGFloat horizentalGap = CGRectGetWidth(self.bounds) / ([_dataSource numberOfPointsPresentedEveryTime:self] - 1);
        self.contentSize = CGSizeMake(horizentalGap * [_dataSource numberOfPointsInELineChart:self], CGRectGetHeight(self.bounds));
        
        /** In order to leave some space for the heightest point */
        CGFloat highestPointValue = [_dataSource highestValueELineChart:self].value * 1.1;
        
        /** 1. Construct the Path*/
        UIBezierPath *eLineChartPath = [UIBezierPath bezierPath];
        eLineChartPath.miterLimit = -5.0;
        
        UIBezierPath *animFromPath = [UIBezierPath bezierPath];
        
        //    CGFloat firstPointValue = [_dataSource eLineChart:self valueForIndex:_leftMostIndex].value;
        //    [eLineChartPath moveToPoint:CGPointMake(0, CGRectGetHeight(rect) - CGRectGetHeight(rect) * (firstPointValue / highestPointValue))];
        //    [animFromPath moveToPoint:CGPointMake(0, CGRectGetHeight(rect) - CGRectGetHeight(rect) * (firstPointValue / highestPointValue))];
        //    for (int i = _leftMostIndex + 1; i <= _rightMostIndex; i++)
        //    {
        //        CGFloat pointValue = [_dataSource eLineChart:self valueForIndex: i].value;
        //        [eLineChartPath addLineToPoint:CGPointMake((i - _leftMostIndex) * horizentalGap, CGRectGetHeight(rect) - CGRectGetHeight(rect) * (pointValue / highestPointValue))];
        //        [animFromPath addLineToPoint:CGPointMake((i - _leftMostIndex) * horizentalGap, CGRectGetHeight(rect) / 2)];
        //    }
        
        CGFloat firstPointValue = [_dataSource eLineChart:self valueForIndex:0].value;
        [eLineChartPath moveToPoint:CGPointMake(0, CGRectGetHeight(self.frame) - CGRectGetHeight(self.frame) * (firstPointValue / highestPointValue))];
        [animFromPath moveToPoint:CGPointMake(0, CGRectGetHeight(self.frame) - CGRectGetHeight(self.frame) * (firstPointValue / highestPointValue))];
        for (int i = 1; i <= [_dataSource numberOfPointsInELineChart:self]; i++)
        {
            CGFloat pointValue = [_dataSource eLineChart:self valueForIndex: i].value;
            [eLineChartPath addLineToPoint:CGPointMake(i * horizentalGap, CGRectGetHeight(self.frame) - CGRectGetHeight(self.frame) * (pointValue / highestPointValue))];
            [animFromPath addLineToPoint:CGPointMake(i * horizentalGap, CGRectGetHeight(self.frame) / 2)];
        }
        
        
        
        
        /** 2. Configure Layer and Add Path to it*/
        if (!_shapeLayer)
        {
            _shapeLayer = [CAShapeLayer layer];
        }
        _shapeLayer.zPosition = 0.0f;
        _shapeLayer.strokeColor = [UIColor purpleColor].CGColor;
        _shapeLayer.lineWidth = 1;
        _shapeLayer.lineCap = kCALineCapRound;
        _shapeLayer.lineJoin = kCALineJoinRound;
        _shapeLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.path = eLineChartPath.CGPath;
        
        
        
        
        /** 3. Add Animation to The Layer*/
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
        [anim setRemovedOnCompletion:NO];
        anim.fromValue = (id)animFromPath.CGPath;
        anim.toValue = (id)eLineChartPath.CGPath;
        anim.duration = 0.75f;
        anim.removedOnCompletion = NO;
        anim.fillMode = kCAFillModeForwards;
        anim.autoreverses = NO;
        anim.repeatCount = 0;
        [anim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [_shapeLayer addAnimation:anim forKey:@"path"];
        
        /** 4. Add Layer to Your View*/
        [self.layer addSublayer:_shapeLayer];
        
    }
}

//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    CGFloat horizentalGap = CGRectGetWidth(rect) / ([_dataSource numberOfPointsPresentedEveryTime:self] - 1);
//    /** In order to leave some space for the heightest point */
//    CGFloat highestPointValue = [_dataSource highestValueELineChart:self].value * 1.1;
//
//    /** 1. Construct the Path*/
//    UIBezierPath *eLineChartPath = [UIBezierPath bezierPath];
//    eLineChartPath.miterLimit = -5.0;
//
//    UIBezierPath *animFromPath = [UIBezierPath bezierPath];
//
////    CGFloat firstPointValue = [_dataSource eLineChart:self valueForIndex:_leftMostIndex].value;
////    [eLineChartPath moveToPoint:CGPointMake(0, CGRectGetHeight(rect) - CGRectGetHeight(rect) * (firstPointValue / highestPointValue))];
////    [animFromPath moveToPoint:CGPointMake(0, CGRectGetHeight(rect) - CGRectGetHeight(rect) * (firstPointValue / highestPointValue))];
////    for (int i = _leftMostIndex + 1; i <= _rightMostIndex; i++)
////    {
////        CGFloat pointValue = [_dataSource eLineChart:self valueForIndex: i].value;
////        [eLineChartPath addLineToPoint:CGPointMake((i - _leftMostIndex) * horizentalGap, CGRectGetHeight(rect) - CGRectGetHeight(rect) * (pointValue / highestPointValue))];
////        [animFromPath addLineToPoint:CGPointMake((i - _leftMostIndex) * horizentalGap, CGRectGetHeight(rect) / 2)];
////    }
//    
//    CGFloat firstPointValue = [_dataSource eLineChart:self valueForIndex:0].value;
//    [eLineChartPath moveToPoint:CGPointMake(0, CGRectGetHeight(rect) - CGRectGetHeight(rect) * (firstPointValue / highestPointValue))];
//    [animFromPath moveToPoint:CGPointMake(0, CGRectGetHeight(rect) - CGRectGetHeight(rect) * (firstPointValue / highestPointValue))];
//    for (int i = 1; i <= [_dataSource numberOfPointsInELineChart:self]; i++)
//    {
//        CGFloat pointValue = [_dataSource eLineChart:self valueForIndex: i].value;
//        [eLineChartPath addLineToPoint:CGPointMake(i * horizentalGap, CGRectGetHeight(rect) - CGRectGetHeight(rect) * (pointValue / highestPointValue))];
//        [animFromPath addLineToPoint:CGPointMake(i * horizentalGap, CGRectGetHeight(rect) / 2)];
//    }
//    
//    
//
//
//    /** 2. Configure Layer and Add Path to it*/
//    if (!_shapeLayer)
//    {
//        _shapeLayer = [CAShapeLayer layer];
//    }
//    _shapeLayer.zPosition = 0.0f;
//    _shapeLayer.strokeColor = [UIColor purpleColor].CGColor;
//    _shapeLayer.lineWidth = 1;
//    _shapeLayer.lineCap = kCALineCapRound;
//    _shapeLayer.lineJoin = kCALineJoinRound;
//    _shapeLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
//    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
//    _shapeLayer.path = eLineChartPath.CGPath;
//    
//    
//    
//    
//    /** 3. Add Animation to The Layer*/
//    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
//    [anim setRemovedOnCompletion:NO];
//    anim.fromValue = (id)animFromPath.CGPath;
//    anim.toValue = (id)eLineChartPath.CGPath;
//    anim.duration = 0.75f;
//    anim.removedOnCompletion = NO;
//    anim.fillMode = kCAFillModeForwards;
//    anim.autoreverses = NO;
//    anim.repeatCount = 0;
//    [anim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
//    [_shapeLayer addAnimation:anim forKey:@"path"];
//    
//    /** 4. Add Layer to Your View*/
//    [self.layer addSublayer:_shapeLayer];
//    
//    NSLog(@"%d layers", [[self.layer sublayers] count]);
//
//    
//}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self setNeedsDisplay];
//}


@end
