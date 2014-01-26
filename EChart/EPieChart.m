//
//  EPieChart.m
//  EChartDemo
//
//  Created by Efergy China on 24/1/14.
//  Copyright (c) 2014年 Scott Zhu. All rights reserved.
//

#import "EPieChart.h"
#import "EColor.h"

@implementation EPieChart
@synthesize ePie = _ePie;
@synthesize backPie = _backPie;
@synthesize isUpsideDown = _isUpsideDown;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _isUpsideDown = NO;
        //self.backgroundColor = ELightGrey;
        EPieChartDataModel *ePieChartDataModel = [[EPieChartDataModel alloc] init];
        _ePie = [[EPie alloc] initWithCenter: CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0)
                                      radius: MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2.0
                          ePieChartDataModel:ePieChartDataModel];
        
        _ePie.layer.shadowOffset = CGSizeMake(0, 3);
        _ePie.layer.shadowRadius = 5;
        _ePie.layer.shadowColor = EGrey.CGColor;
        _ePie.layer.shadowOpacity = 0.8;
        
        _backPie = [[EPie alloc] initWithCenter: CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0)
                                         radius: MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2.0 ];
        
        [self addSubview:_ePie];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped:)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

- (void) taped:(UITapGestureRecognizer *) tapGestureRecognizer
{
    [UIView transitionWithView:self duration:0.3 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        if (_isUpsideDown)
        {
            [self.ePie removeFromSuperview];
            [self addSubview:_backPie];
        }
        else
        {
            [self.backPie removeFromSuperview];
            [self addSubview:_ePie];
        }
        
    } completion:nil];
    
    _isUpsideDown = _isUpsideDown * -1;
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
@property (nonatomic) CGFloat radius;

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


- (id)initWithCenter:(CGPoint) center
              radius:(CGFloat) radius
{
    self = [super initWithFrame:CGRectMake(center.x - radius, center.y - radius, radius * 2, radius * 2)];
    if (self)
    {
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
        /** Default settings*/
        _budgetColor = [UIColor whiteColor];
        _currentColor = EGrey;
        _estimateColor = EBlueGreenColor;
        _lineWidth = radius / 5;
        
        
        _center = center;
        _radius = radius;
        self.backgroundColor = EGreen;
        self.layer.cornerRadius = CGRectGetWidth(self.bounds) / 2.0;
        _ePieChartDataModel = ePieChartDataModel;
        
        //self.layer.shadowColor = EGrey.CGColor;
        
        [self reloadContent];
        
    }
    return self;
}



- (void) reloadContent
{
    UIBezierPath* circleBudgetPath = [UIBezierPath bezierPathWithArcCenter:self.center
                                                                    radius:self.frame.size.height*0.4
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
    
    UIBezierPath* circleCurrentPath = [UIBezierPath bezierPathWithArcCenter: self.center
                                                                     radius: self.frame.size.height*0.4
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
    
    UIBezierPath* circleEstimatePath = [UIBezierPath bezierPathWithArcCenter:self.center
                                                                      radius:self.frame.size.height*0.4
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
