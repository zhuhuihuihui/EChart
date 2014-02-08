//
//  EPieChart.m
//  EChartDemo
//
//  Created by Efergy China on 24/1/14.
//  Copyright (c) 2014年 Scott Zhu. All rights reserved.
//

#import "EPieChart.h"
#import "EColor.h"
#import "UICountingLabel.h"

@implementation EPieChart
@synthesize frontPie = _frontPie;
@synthesize backPie = _backPie;
@synthesize isUpsideDown = _isUpsideDown;
@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;
@synthesize ePieChartDataModel = _ePieChartDataModel;

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame ePieChartDataModel:nil];
}

- (id)initWithFrame:(CGRect)frame
 ePieChartDataModel:(EPieChartDataModel *)ePieChartDataModel
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _isUpsideDown = NO;
        
        if (nil == ePieChartDataModel)
        {
            _frontPie = [[EPie alloc] initWithCenter: CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0)
                                             radius: MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2.5 ];
        }
        else
        {
            _ePieChartDataModel = ePieChartDataModel;
            _frontPie = [[EPie alloc] initWithCenter: CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0)
                                              radius: MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2.5
                                  ePieChartDataModel: _ePieChartDataModel];
        }
        
        
        _frontPie.layer.shadowOffset = CGSizeMake(0, 3);
        _frontPie.layer.shadowRadius = 5;
        _frontPie.layer.shadowColor = EGrey.CGColor;
        _frontPie.layer.shadowOpacity = 0.8;
        [self addSubview:_frontPie];
        
        
        
        _backPie = [[EPie alloc] initWithCenter: CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0)
                                         radius: MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2.5 ];
        _backPie.layer.shadowOffset = CGSizeMake(0, 3);
        _backPie.layer.shadowRadius = 5;
        _backPie.layer.shadowColor = EGrey.CGColor;
        _backPie.layer.shadowOpacity = 0.8;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped:)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

- (void) taped:(UITapGestureRecognizer *) tapGestureRecognizer
{
    [self turnPie];

}


- (void)turnPie
{
    [UIView transitionWithView:self
                      duration:0.3
                       options:_isUpsideDown?UIViewAnimationOptionTransitionFlipFromLeft:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^
     {
         if (_isUpsideDown)
         {
             if ([_delegate respondsToSelector:@selector(ePieChart:didTurnToFrontViewWithFrontView:)])
             {
                 [_delegate ePieChart:self didTurnToFrontViewWithFrontView:_frontPie];
             }
             
             [_backPie removeFromSuperview];
             [self addSubview:_frontPie];
         }
         else
         {
             if ([_delegate respondsToSelector:@selector(ePieChart:didTurnToBackViewWithBackView:)])
             {
                 [_delegate ePieChart:self didTurnToBackViewWithBackView:_backPie];
             }
             
             [_frontPie removeFromSuperview];
             [self addSubview:_backPie];
             
         }
         
     } completion:nil];
    
    _isUpsideDown = _isUpsideDown ? NO: YES;
}


- (void)setDelegate:(id<EPieChartDelegate>)delegate
{
    if (delegate && delegate != _delegate)
    {
        _delegate = delegate;
    }
}

- (void)setDataSource:(id<EPieChartDataSource>)dataSource
{
    if (dataSource && dataSource != _dataSource)
    {
        _dataSource = dataSource;
        
        if ([_dataSource respondsToSelector:@selector(backViewForEPieChart:)])
        {
            _backPie.contentView = [_dataSource backViewForEPieChart:self];
        }
        
        if ([_dataSource respondsToSelector:@selector(frontViewForEPieChart:)])
        {
            _frontPie.contentView = [_dataSource frontViewForEPieChart:self];
        }
        
        
    }
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


@interface EPie ()

@property (nonatomic, strong) CAShapeLayer *circleBudget;
@property (nonatomic, strong) CAShapeLayer *circleCurrent;
@property (nonatomic, strong) CAShapeLayer *circleEstimate;
@property (nonatomic) CGPoint center;

@end

@implementation EPie
@synthesize ePieChartDataModel = _ePieChartDataModel;
@synthesize circleBudget = _circleBudget;
@synthesize circleCurrent = _circleCurrent;
@synthesize circleEstimate = _circleEstimate;
@synthesize center = _center;
@synthesize radius = _radius;
@synthesize budgetColor = _budgetColor;
@synthesize currentColor = _currentColor;
@synthesize estimateColor = _estimateColor;
@synthesize lineWidth = _lineWidth;
@synthesize contentView = _contentView;


- (id)initWithCenter:(CGPoint) center
              radius:(CGFloat) radius
{
    self = [super initWithFrame:CGRectMake(center.x - radius, center.y - radius, radius * 2, radius * 2)];
    if (self)
    {
        //self.clipsToBounds = YES;
        _center = center;
        _radius = radius;
        
        self.backgroundColor = EGreen;
        self.layer.cornerRadius = CGRectGetWidth(self.bounds) / 2.0;

    }
    return self;
}

- (id)initWithCenter:(CGPoint) center
              radius:(CGFloat) radius
  ePieChartDataModel:(EPieChartDataModel *)ePieChartDataModel
{
    self = [super initWithFrame:CGRectMake(center.x - radius, center.y - radius, radius * 2, radius * 2)];
    if (self)
    {
        //self.clipsToBounds = YES;
        /** Default settings*/
        _budgetColor = [UIColor whiteColor];
        _currentColor = EYellow;
        _estimateColor = [EYellow colorWithAlphaComponent:0.3];;
        _lineWidth = radius / 6;
        
        
        _center = center;
        _radius = radius;
        self.backgroundColor = EGreen;
        self.layer.cornerRadius = CGRectGetWidth(self.bounds) / 2.0;
        _ePieChartDataModel = ePieChartDataModel;
        
        /** Default Content View*/
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
        _contentView.clipsToBounds = YES;
        
        UILabel *title = [[UILabel alloc] initWithFrame:self.frame];
        title.text = @"Dec";
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont fontWithName:@"Menlo-Bold" size:15];
        title.textColor = [UIColor whiteColor];
        title.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) * 0.6);
        [_contentView addSubview:title];
        
        
        UIView *line = [[UIView alloc] initWithFrame:self.bounds];
        line.backgroundColor = [UIColor whiteColor];
        line.bounds = CGRectMake(0, 0, CGRectGetWidth(self.bounds) * 0.6, 2);
        line.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) * 0.8);
        [_contentView addSubview:line];
        
        
        UICountingLabel *budgetLabel = [[UICountingLabel alloc] initWithFrame:self.frame];
        budgetLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) * 1);
        budgetLabel.textAlignment = NSTextAlignmentCenter;
        budgetLabel.method = UILabelCountingMethodEaseInOut;
        budgetLabel.font = [UIFont fontWithName:@"Menlo" size:13];
        budgetLabel.textColor = [UIColor whiteColor];
        budgetLabel.format = @"B:%.1f";
        [_contentView addSubview:budgetLabel];
        [budgetLabel countFrom:0 to:_ePieChartDataModel.budget withDuration:2.0f];
        
        UICountingLabel *currentLabel = [[UICountingLabel alloc] initWithFrame:self.frame];
        currentLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) * 1.2);
        currentLabel.textAlignment = NSTextAlignmentCenter;
        currentLabel.method = UILabelCountingMethodEaseInOut;
        currentLabel.font = [UIFont fontWithName:@"Menlo" size:13];
        currentLabel.textColor = [UIColor whiteColor];
        currentLabel.format = @"C:%.1f";
        [_contentView addSubview:currentLabel];
        [currentLabel countFrom:0 to:_ePieChartDataModel.current withDuration:2.0f];
        
        UICountingLabel *estimateLabel = [[UICountingLabel alloc] initWithFrame:self.frame];
        estimateLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) * 1.4);
        estimateLabel.textAlignment = NSTextAlignmentCenter;
        estimateLabel.method = UILabelCountingMethodEaseInOut;
        estimateLabel.font = [UIFont fontWithName:@"Menlo" size:13];
        estimateLabel.textColor = [UIColor whiteColor];
        estimateLabel.format = @"E:%.1f";
        [_contentView addSubview:estimateLabel];
        [estimateLabel countFrom:0 to:_ePieChartDataModel.estimate withDuration:2.0f];
        
        [self reloadContent];
        
    }
    return self;
}

#pragma -mark- Setter and Getter
- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    [self reloadContent];
}

- (void)setRadius:(CGFloat)radius
{
    _radius = radius;
    [self reloadContent];
}

- (void)setCurrentColor:(UIColor *)currentColor
{
    _currentColor = currentColor;
    [self reloadContent];
}

-(void)setBudgetColor:(UIColor *)budgetColor
{
    _budgetColor = budgetColor;
    [self reloadContent];
}

- (void)setEstimateColor:(UIColor *)estimateColor
{
    _estimateColor = estimateColor;
    [self reloadContent];
}

- (void)setContentView:(UIView *)contentView
{
    if (contentView)
    {
        [_contentView removeFromSuperview];
        _contentView = contentView;
        [self addSubview:_contentView];
        
        NSLog(@"_contentView %@", NSStringFromCGRect(_contentView.frame));
        NSLog(@"self %@", NSStringFromCGRect(self.frame));
    }
}




- (void) reloadContent
{
    UIBezierPath* circleBudgetPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
                                                                    radius: _radius * 0.8
                                                                startAngle: 0
                                                                  endAngle: 2 * M_PI
                                                                 clockwise:NO];
    if (!_circleBudget)
        _circleBudget = [CAShapeLayer layer];
    _circleBudget.path = circleBudgetPath.CGPath;
    _circleBudget.fillColor = [UIColor clearColor].CGColor;
    _circleBudget.strokeColor = _budgetColor.CGColor;
    _circleBudget.lineCap = kCALineCapRound;
    _circleBudget.lineWidth = _lineWidth;
    _circleBudget.zPosition = -1;
    
    UIBezierPath* circleCurrentPath = [UIBezierPath bezierPathWithArcCenter: CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
                                                                     radius: _radius * 0.8
                                                                 startAngle: M_PI_2 * 3
                                                                   endAngle: M_PI_2 * 3 - (_ePieChartDataModel.current / _ePieChartDataModel.budget) * (M_PI * 2)
                                                                  clockwise: NO];
    if (!_circleCurrent)
        _circleCurrent = [CAShapeLayer layer];
    _circleCurrent.path = circleCurrentPath.CGPath;
    _circleCurrent.fillColor = [UIColor clearColor].CGColor;
    _circleCurrent.strokeColor = _currentColor.CGColor;
    _circleCurrent.lineCap = kCALineCapRound;
    _circleCurrent.lineWidth = _lineWidth;
    _circleCurrent.zPosition = 1;
    
    UIBezierPath* circleEstimatePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
                                                                      radius: _radius * 0.8
                                                                  startAngle: M_PI_2 * 3
                                                                    endAngle: M_PI_2 * 3 - (_ePieChartDataModel.estimate / _ePieChartDataModel.budget) * (M_PI * 2)
                                                                   clockwise:NO];
    if (!_circleEstimate)
        _circleEstimate = [CAShapeLayer layer];
    _circleEstimate.path = circleEstimatePath.CGPath;
    _circleEstimate.fillColor = [UIColor clearColor].CGColor;
    _circleEstimate.strokeColor = _estimateColor.CGColor;
    _circleEstimate.lineCap = kCALineCapRound;
    _circleEstimate.lineWidth = _lineWidth;
    _circleEstimate.zPosition = 0;
    
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 2.0;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [_circleCurrent addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    [_circleEstimate addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    
    [self.layer addSublayer:_circleBudget];
    [self.layer addSublayer:_circleCurrent];
    [self.layer addSublayer:_circleEstimate];
    
    
    if (_contentView)
    {
        [self addSubview:_contentView];
    }
    
}

- (void) reloadContentWithEPieChartDataModel:(EPieChartDataModel *)ePieChartDataModel
{
    _ePieChartDataModel = ePieChartDataModel;
    [self reloadContent];
}

@end


@implementation EPieChartDataModel
@synthesize current = _current;
@synthesize budget = _budget;
@synthesize estimate = _estimate;


- (id)init
{
    self = [super init];
    if (self)
    {
        _budget = 100;
        _current = 40;
        _estimate = 80;
    }
    return self;
}

- (id)initWithBudget:(CGFloat) budget
             current:(CGFloat) current
            estimate:(CGFloat) estimate
{
    self = [self init];
    if (self)
    {
        _budget = budget;
        _current = current;
        _estimate = estimate;
    }
    return self;
}



@end
