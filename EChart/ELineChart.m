//
//  ELineChart.m
//  EChartDemo
//
//  Created by 朱 建慧 on 13-12-25.
//  Copyright (c) 2013年 Scott Zhu. All rights reserved.
//

#import "ELineChart.h"

#define DIRECTION  -1

@interface ELineChart()
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@end

@implementation ELineChart
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize leftMostIndex = _leftMostIndex;
@synthesize rightMostIndex = _rightMostIndex;
@synthesize shapeLayer = _shapeLayer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}


#pragma -mark- Setter and Getter
- (void)setDataSource:(id<ELineChartDataSource>)dataSource
{
    if (dataSource && _dataSource != dataSource)
    {
        _dataSource = dataSource;
        /** Check if every dataSource is implemented*/
        
        
        _leftMostIndex = 0;
        _rightMostIndex = [_dataSource numberOfPointsPresentedEveryTime:self] - 1;
    }
}

- (void)setDelegate:(id<ELineChartDelegate>)delegate
{
    
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGFloat horizentalGap = CGRectGetWidth(rect) / ([_dataSource numberOfPointsPresentedEveryTime:self] - 1);
    /** In order to leave some space for the heightest point */
    CGFloat highestPointValue = [_dataSource highestValueELineChart:self].value * 1.1;

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /** 1. Construct the Path*/
    UIBezierPath *eLineChartPath = [UIBezierPath bezierPath];
    eLineChartPath.miterLimit = -5.0;
    
    UIBezierPath *animFromPath = [UIBezierPath bezierPath];
    
    CGFloat firstPointValue = [_dataSource eLineChart:self valueForIndex:_leftMostIndex].value;
    [eLineChartPath moveToPoint:CGPointMake(0, CGRectGetHeight(rect) - CGRectGetHeight(rect) * (firstPointValue / highestPointValue))];
    [animFromPath moveToPoint:CGPointMake(0, CGRectGetHeight(rect) - CGRectGetHeight(rect) * (firstPointValue / highestPointValue))];
    for (int i = _leftMostIndex + 1; i <= _rightMostIndex; i++)
    {
        CGFloat pointValue = [_dataSource eLineChart:self valueForIndex: i].value;
        [eLineChartPath addLineToPoint:CGPointMake((i - _leftMostIndex) * horizentalGap, CGRectGetHeight(rect) - CGRectGetHeight(rect) * (pointValue / highestPointValue))];
        [animFromPath addLineToPoint:CGPointMake((i - _leftMostIndex) * horizentalGap, CGRectGetHeight(rect) / 2)];
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
    _shapeLayer.frame = self.bounds;
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    _shapeLayer.path = eLineChartPath.CGPath;
    

    
    
    /** 3. Add Animation to The Layer*/
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
    
    /** 4. Add Layer to Your View*/
    [self.layer addSublayer:_shapeLayer];
    
    
    

}

#pragma -mark- LineChart Control Methods
- (void)moveLeft
{
    NSAssert(_dataSource, @"Important!! DataSource Not Set!");
    
    int howManyPointsShouldBeMoved = [_dataSource numberOfPointsPresentedEveryTime:self] / 3;
    howManyPointsShouldBeMoved = 1;
    int index = _leftMostIndex + howManyPointsShouldBeMoved * DIRECTION;
    ELineChartDataModel *eLineDataModel = [_dataSource eLineChart:self valueForIndex:index];
    if (nil == eLineDataModel) return;
    
    _leftMostIndex = index;
    _rightMostIndex = _rightMostIndex + howManyPointsShouldBeMoved * DIRECTION;
    
//    int totalColumnsRequired = [_dataSource numberOfPointsInELineChart:self];
//    for (int i = 0; i < totalColumnsRequired; i++)
//    {
//        EColumn *eColumn = [_eColumns objectForKey:[NSNumber numberWithInteger:_leftMostIndex - i * DIRECTION]];
//        EColumn *nextEColumn = [_eColumns objectForKey:[NSNumber numberWithInteger:_leftMostIndex - (i + 1)  * DIRECTION]];
//        EColumnChartLabel *eColumnChartLabel = [_eLabels objectForKey:[NSNumber numberWithInteger:_leftMostIndex - i * DIRECTION]];
//        EColumnChartLabel *nextEColumnChartLabel = [_eLabels objectForKey:[NSNumber numberWithInteger:_leftMostIndex - (i + 1) * DIRECTION]];
//        
//        eColumnChartLabel.frame = nextEColumnChartLabel.frame;
//        eColumn.frame = nextEColumn.frame;
//    }
    
    [self setNeedsDisplay];
}

- (void)moveRight
{
    NSAssert(_dataSource, @"Important!! DataSource Not Set!");
    
    int howManyPointsShouldBeMoved = [_dataSource numberOfPointsPresentedEveryTime:self] / 3;
    howManyPointsShouldBeMoved = 1;
    int index = _rightMostIndex - howManyPointsShouldBeMoved * DIRECTION;
    ELineChartDataModel *eLineDataModel = [_dataSource eLineChart:self valueForIndex:index];
    if (nil == eLineDataModel) return;
    
    _leftMostIndex = _leftMostIndex - howManyPointsShouldBeMoved * DIRECTION;
    _rightMostIndex = _rightMostIndex - howManyPointsShouldBeMoved * DIRECTION;
    
    CATransition *transition = [CATransition animation];
    transition.startProgress = 0;
    transition.endProgress = 0.2;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    transition.duration = 1;
    
    [_shapeLayer addAnimation:transition forKey:@"transition"];
    
    [self setNeedsDisplay];
}

@end
