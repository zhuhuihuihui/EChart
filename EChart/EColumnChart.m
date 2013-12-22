//
//  EColumnChart.m
//  EChart
//
//  Created by Efergy China on 11/12/13.
//  Copyright (c) 2013 Scott Zhu. All rights reserved.
//

#import "EColumnChart.h"
#import "EColor.h"
#import "EColumnChartLabel.h"
#import "EFloatBox.h"
#define BOTTOM_LINE_HEIGHT 2
#define HORIZONTAL_LINE_HEIGHT 0.5
#define Y_COORDINATE_LABEL_WIDTH 30


@interface EColumnChart()

@property (strong, nonatomic) NSMutableDictionary *eColumns;
@property (strong, nonatomic) NSMutableDictionary *eLabels;
@property (strong, nonatomic) EColumn *fingerIsInThisEColumn;

@end

@implementation EColumnChart
@synthesize showHighAndLowColumnWithColor = _showHighAndLowColumnWithColor;
@synthesize fingerIsInThisEColumn = _fingerIsInThisEColumn;
@synthesize minColumnColor = _minColumnColor;
@synthesize maxColumnColor = _maxColumnColor;
@synthesize normalColumnColor = _normalColumnColor;
@synthesize eColumns = _eColumns;
@synthesize eLabels = _eLabels;
@synthesize leftMostIndex = _leftMostIndex;
@synthesize rightMostIndex = _rightMostIndex;
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;


#pragma -mark- Setter and Getter
- (void)setDelegate:(id<EColumnChartDelegate>)delegate
{
    if (_delegate != delegate)
    {
        _delegate = delegate;
        
        if (![_delegate respondsToSelector:@selector(eColumnChart: didSelectColumn:)])
        {
            NSLog(@"@selector(eColumnChart: didSelectColumn:) Not Implemented!");
            return;
        }
        
        if (![_delegate respondsToSelector:@selector(eColumnChart:fingerDidEnterColumn:)])
        {
            NSLog(@"@selector(eColumnChart:fingerDidEnterColumn:) Not Implemented!");
            return;
        }
        
        if (![_delegate respondsToSelector:@selector(eColumnChart:fingerDidLeaveColumn:)])
        {
            NSLog(@"@selector(eColumnChart:fingerDidLeaveColumn:) Not Implemented!");
            return;
        }
        
        if (![_delegate respondsToSelector:@selector(fingerDidLeaveEColumnChart:)])
        {
            NSLog(@"@selector(fingerDidLeaveEColumnChart:) Not Implemented!");
            return;
        }
    }
}

- (void)setDataSource:(id<EColumnChartDataSource>)dataSource
{
    if (_dataSource != dataSource)
    {
        _dataSource = dataSource;
        
        if (![_dataSource respondsToSelector:@selector(numberOfColumnsInEColumnChart:)])
        {
            NSLog(@"@selector(numberOfColumnsInEColumnChart:) Not Implemented!");
            return;
        }
        
        if (![_dataSource respondsToSelector:@selector(numberOfColumnsPresentedEveryTime:)])
        {
            NSLog(@"@selector(numberOfColumnsPresentedEveryTime:) Not Implemented!");
            return;
        }
        
        if (![_dataSource respondsToSelector:@selector(highestValueEColumnChart:)])
        {
            NSLog(@"@selector(highestValueEColumnChart:) Not Implemented!");
            return;
        }
        
        if (![_dataSource respondsToSelector:@selector(eColumnChart:valueForIndex:)])
        {
            NSLog(@"@selector(eColumnChart:valueForIndex:) Not Implemented!");
            return;
        }
        
        {
            int totalColumnsRequired = 0;
            totalColumnsRequired = [_dataSource numberOfColumnsPresentedEveryTime:self];
            int totalColumns = 0;
            totalColumns = [_dataSource numberOfColumnsInEColumnChart:self];
            /** Currently only support columns layout from right to left, WILL ADD OPTIONS LATER*/
            _rightMostIndex = 0;
            _leftMostIndex = _rightMostIndex + totalColumnsRequired - 1;
            /** Initialize colors for max and min column*/
            _minColumnColor = EMinValueColor;
            _maxColumnColor = EMaxValueColor;
            _showHighAndLowColumnWithColor = YES;
            
            /** Start construct horizontal lines*/
            /** Start construct value labels for horizontal lines*/
            
            /** In order to leave some space for the heightest column */
            float highestValueEColumnChart = [_dataSource highestValueEColumnChart:self].value * 1.1;
            for (int i = 0; i < 11; i++)
            {
                float heightGap = self.frame.size.height / 10.0;
                float valueGap = highestValueEColumnChart / 10.0;
                UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, heightGap * i, self.frame.size.width, HORIZONTAL_LINE_HEIGHT)];
                horizontalLine.backgroundColor = ELightGrey;
                [self addSubview:horizontalLine];
                
                EColumnChartLabel *eColumnChartLabel = [[EColumnChartLabel alloc] initWithFrame:CGRectMake(-1 * Y_COORDINATE_LABEL_WIDTH, -heightGap / 2.0 + heightGap * i, Y_COORDINATE_LABEL_WIDTH, heightGap)];
                [eColumnChartLabel setTextAlignment:NSTextAlignmentCenter];
                eColumnChartLabel.text = [[NSString stringWithFormat:@"%.1f ", valueGap * (10 - i)] stringByAppendingString:[_dataSource highestValueEColumnChart:self].unit];;
                
                //eColumnChartLabel.backgroundColor = ELightBlue;
                [self addSubview:eColumnChartLabel];
            }
        }
        
        [self reloadData];
    }
}
- (void)setMaxColumnColor:(UIColor *)maxColumnColor
{
    _maxColumnColor = maxColumnColor;
    [self reloadData];
}

- (void)setMinColumnColor:(UIColor *)minColumnColor
{
    _minColumnColor = minColumnColor;
    [self reloadData];
}

- (void)setShowHighAndLowColumnWithColor:(BOOL)showHighAndLowColumnWithColor
{
    _showHighAndLowColumnWithColor = showHighAndLowColumnWithColor;
    [self reloadData];
}


#pragma -mark- Custom Methed
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        /** Should i release these two objects before self have been destroyed*/
        _eLabels = [NSMutableDictionary dictionary];
        _eColumns = [NSMutableDictionary dictionary];
    }
    return self;
}



- (void)initData
{
    
}

- (void)reloadData
{
    if (nil == _dataSource)
    {
        NSLog(@"Important!! DataSource Not Set!");
        return;
    }
    
    int totalColumnsRequired = 0;
    totalColumnsRequired = [_dataSource numberOfColumnsPresentedEveryTime:self];
    float highestValueEColumnChart = [_dataSource highestValueEColumnChart:self].value * 1.1;
    
    float widthOfTheColumnShouldBe = self.frame.size.width / (float)(totalColumnsRequired + (totalColumnsRequired + 1) * 0.5);
    float minValue = 1000000.0;
    float maxValue = 0.0;
    NSInteger minIndex = 0;
    NSInteger maxIndex = 0;
    
    for (int i = 0; i < totalColumnsRequired; i++)
    {
        NSInteger currentIndex = _leftMostIndex - i;
        EColumnDataModel *eColumnDataModel = [_dataSource eColumnChart:self valueForIndex:currentIndex];
        if (eColumnDataModel == nil)
            eColumnDataModel = [[EColumnDataModel alloc] init];
        /** Judge which is the max value and which is min, then set color correspondingly */
        if (eColumnDataModel.value > maxValue) {
            maxIndex =  currentIndex;
            maxValue = eColumnDataModel.value;
        }
        if (eColumnDataModel.value < minValue) {
            minIndex = currentIndex;
            minValue = eColumnDataModel.value;
        }
        
        /** Construct Columns*/
        EColumn *eColumn = [_eColumns objectForKey: [NSNumber numberWithInteger:currentIndex ]];
        if (nil == eColumn)
        {
            eColumn = [[EColumn alloc] initWithFrame:CGRectMake(widthOfTheColumnShouldBe * 0.5 + (i * widthOfTheColumnShouldBe * 1.5), 0, widthOfTheColumnShouldBe, self.frame.size.height)];
            eColumn.barColor = EGrey;
            eColumn.backgroundColor = [UIColor clearColor];
            eColumn.grade = eColumnDataModel.value / highestValueEColumnChart;
            eColumn.eColumnDataModel = eColumnDataModel;
            [eColumn setDelegate:self];
            [self addSubview:eColumn];
            [_eColumns setObject:eColumn forKey:[NSNumber numberWithInteger:currentIndex ]];
        }
        eColumn.barColor = EGrey;
        
        /** Construct labels for corresponding columns */
        EColumnChartLabel *eColumnChartLabel = [_eLabels objectForKey:[NSNumber numberWithInteger:(currentIndex)]];
        if (nil == eColumnChartLabel)
        {
            eColumnChartLabel = [[EColumnChartLabel alloc] initWithFrame:CGRectMake(widthOfTheColumnShouldBe * 0.5 + (i * widthOfTheColumnShouldBe * 1.5), self.frame.size.height, widthOfTheColumnShouldBe, 20)];
            [eColumnChartLabel setTextAlignment:NSTextAlignmentCenter];
            eColumnChartLabel.text = eColumnDataModel.label;
            //eColumnChartLabel.backgroundColor = ELightBlue;
            [self addSubview:eColumnChartLabel];
            [_eLabels setObject:eColumnChartLabel forKey:[NSNumber numberWithInteger:(currentIndex)]];
        }
    }
    
    if (_showHighAndLowColumnWithColor)
    {
        EColumn *eColumn = [_eColumns objectForKey: [NSNumber numberWithInteger: maxIndex]];
        eColumn.barColor = _maxColumnColor;
        eColumn = [_eColumns objectForKey: [NSNumber numberWithInteger: minIndex]];
        eColumn.barColor = _minColumnColor;
    }
    
    
    
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^
    {
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, 0, BOTTOM_LINE_HEIGHT)];
        bottomLine.backgroundColor = [UIColor blackColor];
        bottomLine.layer.cornerRadius = 2.0;
        [self addSubview:bottomLine];
        [bottomLine setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, BOTTOM_LINE_HEIGHT)];
        
    } completion:nil];
    
}



- (void)moveLeft
{
    if (nil == _dataSource)
    {
        NSLog(@"Important!! DataSource Not Set!");
        return;
    }
    int index = _leftMostIndex + 1;
    EColumnDataModel *eColumnDataModel = [_dataSource eColumnChart:self valueForIndex:index];
    if (nil == eColumnDataModel) return;
    
    _leftMostIndex++;
    _rightMostIndex++;
    
    int totalColumnsRequired = [_dataSource numberOfColumnsInEColumnChart:self];
    for (int i = 0; i < totalColumnsRequired; i++)
    {
        EColumn *eColumn = [_eColumns objectForKey:[NSNumber numberWithInteger:_leftMostIndex - i]];
        EColumn *nextEColumn = [_eColumns objectForKey:[NSNumber numberWithInteger:_leftMostIndex - i - 1]];
        EColumnChartLabel *eColumnChartLabel = [_eLabels objectForKey:[NSNumber numberWithInteger:_leftMostIndex - i]];
        EColumnChartLabel *nextEColumnChartLabel = [_eLabels objectForKey:[NSNumber numberWithInteger:_leftMostIndex - i - 1]];
        
        eColumnChartLabel.frame = nextEColumnChartLabel.frame;
        eColumn.frame = nextEColumn.frame;
    }
    
    [self reloadData];
}
- (void)moveRight
{
    if (nil == _dataSource)
    {
        NSLog(@"Important!! DataSource Not Set!");
        return;
    }
    int index = _rightMostIndex - 1;
    EColumnDataModel *eColumnDataModel = [_dataSource eColumnChart:self valueForIndex:index];
    if (nil == eColumnDataModel) return;
    
    _leftMostIndex--;
    _rightMostIndex--;
    
    int totalColumnsRequired = [_dataSource numberOfColumnsInEColumnChart:self];
    for (int i = 0; i < totalColumnsRequired; i++)
    {
        EColumn *eColumn = [_eColumns objectForKey:[NSNumber numberWithInteger:_rightMostIndex + i]];
        EColumn *nextEColumn = [_eColumns objectForKey:[NSNumber numberWithInteger:_rightMostIndex + i + 1]];
        EColumnChartLabel *eColumnChartLabel = [_eLabels objectForKey:[NSNumber numberWithInteger:_rightMostIndex + i]];
        EColumnChartLabel *nextEColumnChartLabel = [_eLabels objectForKey:[NSNumber numberWithInteger:_rightMostIndex + i + 1]];
        
        
        eColumnChartLabel.frame = nextEColumnChartLabel.frame;
        eColumn.frame = nextEColumn.frame;
        /** Do not inlclude animations at the moment*/
//        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//            eColumn.frame = nextEColumn.frame;
//        } completion:nil];
        
    }
    
    [self reloadData];
}


#pragma -mark- EColumnDelegate
- (void)eColumnTaped:(EColumn *)eColumn
{
    [_delegate eColumnChart:self didSelectColumn:eColumn];
    [_delegate fingerDidLeaveEColumnChart:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma -mark- detect Gesture

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (nil == _delegate) return;
    [_delegate fingerDidLeaveEColumnChart:self];
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    for (EColumn *view in _eColumns.objectEnumerator)
    {
        if(CGRectContainsPoint(view.frame, touchLocation))
        {
            [_delegate eColumnChart:self fingerDidLeaveColumn:view];
            _fingerIsInThisEColumn = nil;
            return;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (nil == _delegate) return;
    UITouch *touch = [[event allTouches] anyObject];
    /** We do not want the coordinate system of the columns here, 
     we need coordinate system of the Echart instead, so we use self*/
    //CGPoint touchLocation = [touch locationInView:touch.view];
    CGPoint touchLocation = [touch locationInView:self];
    
    if (nil == _fingerIsInThisEColumn)
    {
        for (EColumn *view in _eColumns.objectEnumerator)
        {
            if(CGRectContainsPoint(view.frame, touchLocation) )
            {
                [_delegate eColumnChart:self fingerDidEnterColumn:view];
                _fingerIsInThisEColumn = view;
                return ;
            }
        }
    }
    if (_fingerIsInThisEColumn && !CGRectContainsPoint(_fingerIsInThisEColumn.frame, touchLocation))
    {
        [_delegate eColumnChart:self fingerDidLeaveColumn:_fingerIsInThisEColumn];
        _fingerIsInThisEColumn = nil;
    }
    
    return ;
}



@end
