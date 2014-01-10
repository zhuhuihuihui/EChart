//
//  ELineChart.m
//  EChartDemo
//
//  Created by 朱 建慧 on 13-12-25.
//  Copyright (c) 2013年 Scott Zhu. All rights reserved.
//

#import "ELineChart.h"

#define DIRECTION  -1
#define VIRTUAL_SCREEN_COUNT 5

@interface ELineChart()
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CAShapeLayer *tempShapeLayerForAnimation;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation ELineChart
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize leftMostIndex = _leftMostIndex;
@synthesize rightMostIndex = _rightMostIndex;
@synthesize shapeLayer = _shapeLayer;
@synthesize tempShapeLayerForAnimation = _tempShapeLayerForAnimation;
@synthesize scrollView = _scrollView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor purpleColor];
        //self.clipsToBounds = YES;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [_scrollView setDelegate:self];
        [_scrollView setBackgroundColor:[UIColor grayColor]];
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * VIRTUAL_SCREEN_COUNT, CGRectGetHeight(self.frame));
        //[_scrollView setContentOffset:CGPointMake(_scrollView.contentSize.width / 2 - CGRectGetWidth(self.bounds) / 2, 0) animated:NO];
        //[_scrollView setContentOffset:CGPointMake(1, 0) animated:NO];
        [self addSubview:_scrollView];
        
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
        _rightMostIndex = ([_dataSource numberOfPointsPresentedEveryTime:self] - 1) * VIRTUAL_SCREEN_COUNT;
        [self reloadContent];
    }
}

- (void)setDelegate:(id<ELineChartDelegate>)delegate
{
    
}


- (void)reloadContent
{
    if (!_shapeLayer)
    {
        _shapeLayer = [CAShapeLayer layer];
    }
    
    CGFloat horizentalGap = _scrollView.contentSize.width / (([_dataSource numberOfPointsPresentedEveryTime:self] - 1) * VIRTUAL_SCREEN_COUNT);
    /** In order to leave some space for the heightest point */
    CGFloat highestPointValue = [_dataSource highestValueELineChart:self].value * 1.1;
    
    /** 1. Construct the Path*/
    UIBezierPath *eLineChartPath = [UIBezierPath bezierPath];
    eLineChartPath.miterLimit = -5.0;
    
    UIBezierPath *animFromPath = [UIBezierPath bezierPath];
    
    CGFloat firstPointValue = [_dataSource eLineChart:self valueForIndex:_leftMostIndex].value;
    [eLineChartPath moveToPoint:CGPointMake(0, CGRectGetHeight(_scrollView.bounds) - CGRectGetHeight(_scrollView.bounds) * (firstPointValue / highestPointValue))];
    [animFromPath moveToPoint:CGPointMake(0, CGRectGetHeight(_scrollView.bounds) - CGRectGetHeight(_scrollView.bounds) * (firstPointValue / highestPointValue))];
    for (NSInteger i = _leftMostIndex + 1; i <= _rightMostIndex; i++)
    {
        CGFloat pointValue = [_dataSource eLineChart:self valueForIndex: i].value;
        [eLineChartPath addLineToPoint:CGPointMake((i - _leftMostIndex) * horizentalGap, CGRectGetHeight(_scrollView.bounds) - CGRectGetHeight(_scrollView.bounds) * (pointValue / highestPointValue))];
        [animFromPath addLineToPoint:CGPointMake((i - _leftMostIndex) * horizentalGap, CGRectGetHeight(_scrollView.bounds) / 2)];
    }
    
    
    /** 2. Configure Layer and Add Path to it*/
    _shapeLayer.zPosition = 0.0f;
    _shapeLayer.strokeColor = [UIColor purpleColor].CGColor;
    _shapeLayer.lineWidth = 2;
    _shapeLayer.lineCap = kCALineCapRound;
    _shapeLayer.lineJoin = kCALineJoinRound;
    _shapeLayer.frame = CGRectMake(0, 0, _scrollView.contentSize.width, CGRectGetHeight(self.bounds));
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
    //    [resultLayer addAnimation:anim forKey:@"path"];
    
    //[_scrollView.layer addSublayer:_shapeLayer];
    NSLog(@"%lu layer", (unsigned long)[[_scrollView.layer sublayers] count]);
}



#pragma -mark- LineChart Control Methods


#pragma -mark- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint currentOffset = [scrollView contentOffset];
    CGFloat contentWidth = [scrollView contentSize].width;
    CGFloat centerOffsetX = (contentWidth - [self bounds].size.width) / 2.0;
    //CGFloat distanceFromCenter = fabs(currentOffset.x - centerOffsetX);
    CGFloat distanceFromCenter = currentOffset.x - centerOffsetX;
    
    if (distanceFromCenter > (contentWidth / 5.0) * 2 && _rightMostIndex < ([_dataSource numberOfPointsInELineChart:self] - 1))
    {
        scrollView.contentOffset = CGPointMake(centerOffsetX, currentOffset.y);
        //reset content layer
        _leftMostIndex += ([_dataSource numberOfPointsPresentedEveryTime:self] - 1) * 2;
        _rightMostIndex += ([_dataSource numberOfPointsPresentedEveryTime:self] - 1) * 2;
        _rightMostIndex = _rightMostIndex > ([_dataSource numberOfPointsInELineChart:self] - 1) ? [_dataSource numberOfPointsInELineChart:self] - 1: _rightMostIndex;
        [self reloadContent];
        
    }
    
    if (distanceFromCenter < - 1 * (contentWidth / 5.0) * 2 && _leftMostIndex > 0)
    {
        scrollView.contentOffset = CGPointMake(centerOffsetX, currentOffset.y);
        //reset content layer
        _leftMostIndex -= ([_dataSource numberOfPointsPresentedEveryTime:self] - 1) * 2;
        _rightMostIndex -= ([_dataSource numberOfPointsPresentedEveryTime:self] - 1) * 2;
        _leftMostIndex = _leftMostIndex < 0 ? 0 :_leftMostIndex;
        [self reloadContent];
    }
    
    //NSLog(@"%.1f contentScaleFactor = %.1f", [scrollView contentOffset].x, scrollView.contentScaleFactor);
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
}

@end
