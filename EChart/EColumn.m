//
//  EColumn.m
//  EChart
//
//  Created by Efergy China on 11/12/13.
//  Copyright (c) 2013 Scott Zhu. All rights reserved.
//

#import "EColumn.h"
#import "EColor.h"

@implementation EColumn
@synthesize barColor = _barColor;
@synthesize eColumnDataModel = _eColumnDataModel;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _chartLine              = [CAShapeLayer layer];
        _chartLine.lineCap      = kCALineCapButt;
        _chartLine.fillColor    = [[UIColor whiteColor] CGColor];
        _chartLine.lineWidth    = self.frame.size.width;
        _chartLine.strokeEnd    = 0.0;
        self.clipsToBounds      = YES;
		[self.layer addSublayer:_chartLine];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

-(void)setGrade:(float)grade
{
    _grade = grade;

    if(_chartLine.path == nil)
    {
        UIBezierPath *_progressline = [UIBezierPath bezierPath];
        if (_prevGrade != 0.0f) {
            if (grade < _prevGrade) { //Bar graph going down
                [_progressline moveToPoint:CGPointMake(self.frame.size.width/2.0, (1 + _prevGrade) * self.frame.size.height)];
            } else { //Bar graph going up
                [_progressline moveToPoint:CGPointMake(self.frame.size.width/2.0, (1 - _prevGrade) * self.frame.size.height)];
            }
        } else {
            [_progressline moveToPoint:CGPointMake(self.frame.size.width/2.0, self.frame.size.height)];
        }
        [_progressline addLineToPoint:CGPointMake(self.frame.size.width/2.0, (1 - grade) * self.frame.size.height)];

        _chartLine.path = _progressline.CGPath;
        _chartLine.strokeEnd = 1.0;
    }else
    {
        CAKeyframeAnimation *morph = [CAKeyframeAnimation animationWithKeyPath:@"path"];
        morph.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        morph.values = [self getPathValuesForAnimation:_chartLine startGrade:_prevGrade neededGrade:_grade];
        morph.duration = 1;
        morph.removedOnCompletion = YES;
        morph.fillMode = kCAFillModeForwards;
        morph.delegate = self;
        [_chartLine addAnimation:morph forKey:@"pathAnimation"];
        _chartLine.path = (__bridge CGPathRef _Nullable)((id)[morph.values lastObject]);
    }
    _prevGrade = grade;
}


//this method return values for path animation

-(NSArray*)getPathValuesForAnimation:(CAShapeLayer*)layer startGrade:(float)currentGrade neededGrade:(float)neededGrade
{

    NSMutableArray * values = [NSMutableArray array];
    if(_prevGrade != 0.0f)
        [values addObject:(id)layer.path];

    UIBezierPath * finalPath = [UIBezierPath bezierPath];

    [finalPath moveToPoint:CGPointMake(self.frame.size.width/2.0, self.frame.size.height)];
    [finalPath addLineToPoint:CGPointMake(self.frame.size.width/2.0,(1 - neededGrade)*self.frame.size.height)];

    [values addObject:(id)[finalPath CGPath]];

    return values;
}

- (void)setBarColor:(UIColor *)barColor
{
    _chartLine.strokeColor = [barColor CGColor];
}

- (UIColor *)barColor
{
    return [UIColor colorWithCGColor:_chartLine.strokeColor];
}

-(void)rollBack{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _chartLine.strokeColor = [UIColor clearColor].CGColor;
    } completion:nil];
    
    
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	//Draw BG
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
	CGContextFillRect(context, rect);
    
}


#pragma -mark- detect Geusture

- (void) taped:(UITapGestureRecognizer *)tapGesture
{
    [_delegate eColumnTaped:self];
}



@end
