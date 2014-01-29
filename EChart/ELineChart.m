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
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic) CGFloat horizentalGap;
@property (nonatomic) NSInteger reloadCount;
@property (nonatomic) BOOL isInLastScreen;

@property (nonatomic ,strong) ELine *eLine;
@end

@implementation ELineChart
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize leftMostIndex = _leftMostIndex;
@synthesize rightMostIndex = _rightMostIndex;
@synthesize scrollView = _scrollView;
@synthesize horizentalGap = _horizentalGap;
@synthesize reloadCount = _reloadCount;
@synthesize isInLastScreen = _isInLastScreen;
@synthesize lineWidth = _lineWidth;
@synthesize lineColor = _lineColor;

@synthesize eLine = _eLine;

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
        
        /** Setup Scroll View*/
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.minimumZoomScale = 0.5;
        _scrollView.maximumZoomScale = 2;
        _scrollView.showsHorizontalScrollIndicator = NO;
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
    if (!_eLine)
    {
        _eLine = [[ELine alloc] initWithFrame:CGRectMake(0, 0, _scrollView.contentSize.width, CGRectGetHeight(_scrollView.bounds) / 2) lineColor:_lineColor lineWidth:_lineWidth];
        [_eLine setDataSource:self];
    }
    [_eLine reloadDataWithAnimation:(_reloadCount <= 1)];
    [_scrollView addSubview:_eLine];
    
    NSLog(@"From %d To %d", _leftMostIndex, _rightMostIndex);
}


- (void) reloadContentAtScale: (float)scale
{
    
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
        NSLog(@"Scroll.ContentSize %@", NSStringFromCGSize(_scrollView.contentSize));
        scrollView.contentOffset = CGPointMake(centerOffsetX, currentOffset.y);
        //reset content layer
        _leftMostIndex += ([_dataSource numberOfPointsPresentedEveryTime:self] - 1) * 2;
        _rightMostIndex += ([_dataSource numberOfPointsPresentedEveryTime:self] - 1) * 2;
        if (_rightMostIndex > ([_dataSource numberOfPointsInELineChart:self] - 1))
        {
            _rightMostIndex = [_dataSource numberOfPointsInELineChart:self] - 1;
            /** Reach the end of data, decrese the contentSize.width to fit*/
            _scrollView.contentSize = CGSizeMake(_horizentalGap * (_rightMostIndex - _leftMostIndex), CGRectGetHeight(_scrollView.bounds));
            _eLine.frame = CGRectMake(CGRectGetMinX(_eLine.frame), CGRectGetMinY(_eLine.frame), _scrollView.contentSize.width, CGRectGetHeight(_eLine.frame));
            _isInLastScreen = YES;
        }
        
        [self reloadContent];
        
    }
    
    if (distanceFromCenter < - 1 * centerOffsetX && _leftMostIndex > 0)
    {
        NSLog(@"Scroll.ContentSize %@", NSStringFromCGSize(_scrollView.contentSize));
        if (_scrollView.contentSize.width < CGRectGetWidth(_scrollView.bounds) * VIRTUAL_SCREEN_COUNT)
        {
            /** contentSize.width is changed before, so change it back, So that you can set the right contentOffset*/
            _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * VIRTUAL_SCREEN_COUNT, CGRectGetHeight(self.frame));
            _eLine.frame = CGRectMake(CGRectGetMinX(_eLine.frame), CGRectGetMinY(_eLine.frame), _scrollView.contentSize.width, CGRectGetHeight(_eLine.frame));
            currentOffset = [scrollView contentOffset];
            contentWidth = [scrollView contentSize].width;
            centerOffsetX = (contentWidth - [self bounds].size.width) / 2.0;
        }
        
        scrollView.contentOffset = CGPointMake(centerOffsetX, currentOffset.y);
        
        //reset content layer
        _leftMostIndex -= ([_dataSource numberOfPointsPresentedEveryTime:self] - 1) * 2;
        _rightMostIndex = _leftMostIndex + ([_dataSource numberOfPointsPresentedEveryTime:self] - 1) * VIRTUAL_SCREEN_COUNT;
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

//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
//{
//    return _eLine;
//}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView
                       withView:(UIView *)view
                        atScale:(CGFloat)scale
{
    //_eLine.transform = CGAffineTransformIdentity;
    NSLog(@"View.Frame %@", NSStringFromCGRect(view.frame) );
    NSLog(@"Scroll.ContentSize %@", NSStringFromCGSize(_scrollView.contentSize));
    NSLog(@"Scale %f", scale);
    [_delegate eLineChart:self didZoomToScale:scale];
    [self reloadContentAtScale:scale];
    
    //_scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width * scale, _scrollView.contentSize.height);
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
        return [_dataSource eLineChart:self valueForIndex: _leftMostIndex + gapCount];
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
        NSInteger index = [self eLineChartDataModelForPoint:touchPoint].index - _leftMostIndex;
        [_eLine putDotAt: index];
    }
    
    
}

- (void)scrollViewLongPressed:(UILongPressGestureRecognizer *) longPressGestureRecognizer
{
    CGPoint touchPoint = [longPressGestureRecognizer locationInView:_scrollView];
    //NSLog(@"scrollViewTaped! At %f %f", touchPoint.x, touchPoint.y);
    if (_delegate && [_delegate respondsToSelector:@selector(eLineChart:didHoldAndMoveToPoint:)])
    {
        [_delegate eLineChart:self didHoldAndMoveToPoint:[self eLineChartDataModelForPoint:touchPoint]];
        NSInteger index = [self eLineChartDataModelForPoint:touchPoint].index - _leftMostIndex;
        [_eLine putDotAt: index];
    }
}
#pragma -mark- Custom method



#pragma -mark- Animation Delegate


#pragma -mark- ELine DataSource Delegate
- (ELineChartDataModel *)eLine:(ELine *)eLine valueForIndex:(NSInteger)index
{
    return [_dataSource eLineChart:self valueForIndex: (_leftMostIndex + index)];
}

- (NSInteger)numberOfPointsInELine:(ELine *)eLine
{
    return _rightMostIndex - _leftMostIndex + 1;
}

- (ELineChartDataModel *)highestValueInELine:(ELine *)eLine
{
    return [_dataSource highestValueELineChart:self];
}


@end
