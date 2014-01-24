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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //self.backgroundColor = ELightGrey;
        EPieChartDataModel *ePieChartDataModel = [[EPieChartDataModel alloc] init];
        _ePie = [[EPie alloc] initWithCenter: CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0)
                                      radius: MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2.0
                          ePieChartDataModel:ePieChartDataModel];
        [self addSubview:_ePie];
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


- (id)initWithCenter:(CGPoint) center
              radius:(CGFloat) radius
  ePieChartDataModel:(EPieChartDataModel *)ePieChartDataModel
{
    self = [super initWithFrame:CGRectMake(center.x - radius, center.y - radius, radius * 2, radius * 2)];
    if (self)
    {
        _center = center;
        _radius = radius;
        self.backgroundColor = EGreen;
        self.layer.cornerRadius = CGRectGetWidth(self.bounds) / 2.0;
        _ePieChartDataModel = ePieChartDataModel;
        
        [self reloadContent];
        
    }
    return self;
}



- (void) reloadContent
{
    if (!_circleBudget)
    {
        UIBezierPath* circleBudgetPath = [UIBezierPath bezierPathWithArcCenter:self.center
                                                                        radius:self.frame.size.height*0.4
                                                                    startAngle:0
                                                                      endAngle: 2 * M_PI
                                                                     clockwise:NO];
        _circleBudget = [CAShapeLayer layer];
        _circleBudget.path = circleBudgetPath.CGPath;
        _circleBudget.fillColor = [UIColor clearColor].CGColor;
        _circleBudget.strokeColor = [UIColor whiteColor].CGColor;
        _circleBudget.lineCap = kCALineCapRound;
        _circleBudget.lineWidth = 13;
        
        UIBezierPath* circleCurrentPath = [UIBezierPath bezierPathWithArcCenter: self.center
                                                                        radius: self.frame.size.height*0.4
                                                                    startAngle: M_PI_2 * 3
                                                                      endAngle: M_PI_2 * 3 - (_ePieChartDataModel.current / _ePieChartDataModel.budget) * (M_PI * 2)
                                                                     clockwise: NO];
        _circleCurrent = [CAShapeLayer layer];
        _circleCurrent.path = circleCurrentPath.CGPath;
        _circleCurrent.fillColor = [UIColor clearColor].CGColor;
        _circleCurrent.strokeColor = EGrey.CGColor;
        _circleCurrent.lineCap = kCALineCapRound;
        _circleCurrent.lineWidth = 13;
        
        
        
        
        
        
        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 1.0;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:(_ePieChartDataModel.current / _ePieChartDataModel.budget)];
        [_circleCurrent addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        
        [self.layer addSublayer:_circleBudget];
        [self.layer addSublayer:_circleCurrent];
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
