//
//  ELineChart.m
//  EChartDemo
//
//  Created by 朱 建慧 on 13-12-25.
//  Copyright (c) 2013年 Scott Zhu. All rights reserved.
//
#import "EColor.h"
#import "ELineChart.h"

#define DIRECTION  -1
#define VIRTUAL_SCREEN_COUNT 5

@interface ELineChart()
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) UIView *viewWithShapeLayer;
@property (nonatomic, strong) CAShapeLayer *tempShapeLayerForAnimation;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic) CGFloat horizentalGap;
@property (nonatomic) NSInteger reloadCount;
@property (nonatomic) BOOL isInLastScreen;

@property (nonatomic, strong) CALayer *dot;

@end

@implementation ELineChart
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize leftMostIndex = _leftMostIndex;
@synthesize rightMostIndex = _rightMostIndex;
@synthesize shapeLayer = _shapeLayer;
@synthesize viewWithShapeLayer = _viewWithShapeLayer;
@synthesize tempShapeLayerForAnimation = _tempShapeLayerForAnimation;
@synthesize scrollView = _scrollView;
@synthesize horizentalGap = _horizentalGap;
@synthesize reloadCount = _reloadCount;
@synthesize isInLastScreen = _isInLastScreen;
@synthesize lineWidth = _lineWidth;
@synthesize dot = _dot;
@synthesize lineColor = _lineColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame lineWidth: 4 lineColor: EGreen];
    return self;
}

- (id)initWithFrame:(CGRect)frame
          lineWidth:(NSInteger)lineWidth
          lineColor:(UIColor *)lineColor
{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        //self.clipsToBounds = YES;
        _lineWidth = lineWidth;
        _lineColor = lineColor;
        
        /** Setup Dot*/
        _dot = [CALayer layer];
        _dot.frame = CGRectMake(0, 0, _lineWidth * 4, _lineWidth * 4);
        [_dot setBackgroundColor:_lineColor.CGColor];
        _dot.cornerRadius = _lineWidth * 2;
        
        /** Setup Scroll View*/
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.minimumZoomScale = 0.5;
        _scrollView.maximumZoomScale = 2;
        [_scrollView setDelegate:self];
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * VIRTUAL_SCREEN_COUNT, CGRectGetHeight(self.frame));
        [self addSubview:_scrollView];
        
        /** Add GestureRecognizer*/
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTaped:)];
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewLongPressed:)];
        [_scrollView addGestureRecognizer:tapGestureRecognizer];
        [_scrollView addGestureRecognizer:longPressGestureRecognizer];
        
    }
    return self;
}

#pragma -mark- View Life Circle
- (void)layoutSubviews
{
    
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
        _horizentalGap = _scrollView.contentSize.width / (([_dataSource numberOfPointsPresentedEveryTime:self] - 1) * VIRTUAL_SCREEN_COUNT);
        [self reloadContent];
    }
}

- (void)setDelegate:(id<ELineChartDelegate>)delegate
{
    if (delegate && _delegate != delegate)
    {
        _delegate = delegate;
    }
}


- (void)reloadContent
{
    _reloadCount ++;
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
    _shapeLayer.frame = CGRectMake(0, 0, _scrollView.contentSize.width, CGRectGetHeight(self.bounds) / 2);
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    /** 2. Construct the Path*/
    /** In order to leave some space for the heightest point */
    CGFloat highestPointValue = [_dataSource highestValueELineChart:self].value * 1.1;
    
    UIBezierPath *eLineChartPath = [UIBezierPath bezierPath];
    eLineChartPath.miterLimit = -5.0;
    UIBezierPath *animFromPath = [UIBezierPath bezierPath];
    CGFloat firstPointValue = [_dataSource eLineChart:self valueForIndex:_leftMostIndex].value;
    [eLineChartPath moveToPoint:CGPointMake(0, CGRectGetHeight(_shapeLayer.bounds) - CGRectGetHeight(_shapeLayer.bounds) * (firstPointValue / highestPointValue))];
    [animFromPath moveToPoint:CGPointMake(0, CGRectGetHeight(_shapeLayer.bounds))];
    for (NSInteger i = _leftMostIndex + 1; i <= _rightMostIndex; i++)
    {
        CGFloat pointValue = [_dataSource eLineChart:self valueForIndex: i].value;
        [eLineChartPath addLineToPoint:CGPointMake((i - _leftMostIndex) * _horizentalGap, CGRectGetHeight(_shapeLayer.bounds) - CGRectGetHeight(_shapeLayer.bounds) * (pointValue / highestPointValue))];
        [animFromPath addLineToPoint:CGPointMake((i - _leftMostIndex) * _horizentalGap, CGRectGetHeight(_shapeLayer.bounds))];
    }
    
    
    /** 3. Add Path to layer*/
    _shapeLayer.path = eLineChartPath.CGPath;
    
    
    
    
    /** 4. Add Animation to The Layer*/
    if (_reloadCount <= 1)
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
    
    if (!_viewWithShapeLayer)
    {
        _viewWithShapeLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_shapeLayer.frame), CGRectGetHeight(_shapeLayer.frame))];
    }
    
    [_viewWithShapeLayer.layer addSublayer:_shapeLayer];

    //[_scrollView.layer addSublayer:_shapeLayer];
    [_scrollView addSubview:_viewWithShapeLayer];
    //NSLog(@"From %d To %d", _leftMostIndex, _rightMostIndex);
    
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
    
    if (distanceFromCenter > centerOffsetX && _rightMostIndex < ([_dataSource numberOfPointsInELineChart:self] - 1))
    {
        scrollView.contentOffset = CGPointMake(centerOffsetX, currentOffset.y);
        //reset content layer
        _leftMostIndex += ([_dataSource numberOfPointsPresentedEveryTime:self] - 1) * 2;
        _rightMostIndex += ([_dataSource numberOfPointsPresentedEveryTime:self] - 1) * 2;
        if (_rightMostIndex > ([_dataSource numberOfPointsInELineChart:self] - 1))
        {
            _rightMostIndex = [_dataSource numberOfPointsInELineChart:self] - 1;
            /** Reach the end of data, decrese the contentSize.width to fit*/
            _scrollView.contentSize = CGSizeMake(_horizentalGap * (_rightMostIndex - _leftMostIndex), CGRectGetHeight(_scrollView.bounds));
            _isInLastScreen = YES;
        }
        
        [self reloadContent];
        
    }
    
    if (distanceFromCenter < - 1 * centerOffsetX && _leftMostIndex > 0)
    {
        if (_scrollView.contentSize.width < CGRectGetWidth(_scrollView.bounds) * VIRTUAL_SCREEN_COUNT)
        {
            /** contentSize.width is changed before, so change it back, So that you can set the right contentOffset*/
            _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * VIRTUAL_SCREEN_COUNT, CGRectGetHeight(self.frame));
            currentOffset = [scrollView contentOffset];
            contentWidth = [scrollView contentSize].width;
            centerOffsetX = (contentWidth - [self bounds].size.width) / 2.0;
        }
        
        scrollView.contentOffset = CGPointMake(centerOffsetX, currentOffset.y);
        
        //reset content layer
        _leftMostIndex -= ([_dataSource numberOfPointsPresentedEveryTime:self] - 1) * 2;
        _rightMostIndex = _leftMostIndex + ([_dataSource numberOfPointsPresentedEveryTime:self] - 1) * VIRTUAL_SCREEN_COUNT;
        //_rightMostIndex -= ([_dataSource numberOfPointsPresentedEveryTime:self] - 1) * 2;
        _leftMostIndex = _leftMostIndex < 0 ? 0 :_leftMostIndex;
        [self reloadContent];
    }
    
    if (_isInLastScreen)
    {
        //NSLog(@"%f %f", scrollView.contentOffset.x, (scrollView.contentSize.width - CGRectGetWidth(scrollView.bounds)));
        if (fabs(scrollView.contentOffset.x - (scrollView.contentSize.width - CGRectGetWidth(scrollView.bounds))) < 0.25)
        {
            [_delegate eLineChartDidReachTheEnd:self];
        }
    }
    //NSLog(@"%.1f contentScaleFactor = %.1f", [scrollView contentOffset].x, scrollView.contentScaleFactor);
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _viewWithShapeLayer;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
}

#pragma -mark- detect Gesture
- (ELineChartDataModel *)eLineChartDataModelForPoint:(CGPoint)point
{
    NSInteger gapCount = point.x / _horizentalGap;
    CGFloat distanceOverGapCount = fmod(point.x, _horizentalGap);
    
    if (distanceOverGapCount >= _horizentalGap / 2.0)
    {
        return [_dataSource eLineChart:self valueForIndex: _leftMostIndex + (gapCount + 1)];
    }
    else
    {
        return [_dataSource eLineChart:self valueForIndex:_leftMostIndex + gapCount];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touch began!");
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touch moved!");
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touch end!");
}

- (void)scrollViewTaped:(UITapGestureRecognizer *) tapGestureRecognizer
{
    CGPoint touchPoint = [tapGestureRecognizer locationInView:_scrollView];
    //NSLog(@"scrollViewTaped! At %f %f", touchPoint.x, touchPoint.y);
    if (_delegate && [_delegate respondsToSelector:@selector(eLineChart:didTapAtPoint:)])
    {
        [_delegate eLineChart:self didTapAtPoint:[self eLineChartDataModelForPoint:touchPoint]];
        [self putDotAt:[self eLineChartDataModelForPoint:touchPoint]];
    }
    
    
}

- (void)scrollViewLongPressed:(UILongPressGestureRecognizer *) longPressGestureRecognizer
{
    CGPoint touchPoint = [longPressGestureRecognizer locationInView:_scrollView];
    //NSLog(@"scrollViewTaped! At %f %f", touchPoint.x, touchPoint.y);
    if (_delegate && [_delegate respondsToSelector:@selector(eLineChart:didHoldAndMoveToPoint:)])
    {
        [_delegate eLineChart:self didHoldAndMoveToPoint:[self eLineChartDataModelForPoint:touchPoint]];
        [self putDotAt:[self eLineChartDataModelForPoint:touchPoint]];
    }
}
#pragma -mark- Custom method
- (void) putDotAt:(ELineChartDataModel *) eLineChartDataModel
{
    _dot.opacity = 1.0;
    CGFloat height = CGRectGetHeight(_shapeLayer.bounds);
    CGFloat dotY = height - (height * (eLineChartDataModel.value / ([_dataSource highestValueELineChart:self].value * 1.1)));
    CGPoint dotPosition = CGPointMake((eLineChartDataModel.index - _leftMostIndex) * _horizentalGap, dotY);
    [_dot setPosition:dotPosition];
    
    CABasicAnimation *animatdOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animatdOpacity.fromValue = [NSNumber numberWithFloat:1.0];
    animatdOpacity.toValue = [NSNumber numberWithFloat:0.0];
    animatdOpacity.duration = 1.0;
    [animatdOpacity setDelegate:self];
    animatdOpacity.beginTime = CACurrentMediaTime() + 1;
    [_dot addAnimation:animatdOpacity forKey:@"opacity"];
    
    [_scrollView.layer addSublayer:_dot];
    
    //TODO: When the path changed, the dot gonna still be there
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
//    [_dot removeAnimationForKey:@"opacity"];
    [CATransaction setDisableActions:YES];
    _dot.backgroundColor = [UIColor purpleColor].CGColor;

    
}

@end
