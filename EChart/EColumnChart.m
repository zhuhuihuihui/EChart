//
//  EColumnChart.m
//  EChart
//
//  Created by Efergy China on 11/12/13.
//  Copyright (c) 2013年 Scott Zhu. All rights reserved.
//

#import "EColumnChart.h"
#import "EColor.h"
#import "EColumnChartLabel.h"
#define BOTTOM_LINE_HEIGHT 2
#define HORIZONTAL_LINE_HEIGHT 0.5
#define Y_COORDINATE_LABEL_WIDTH 30


@interface EColumnChart()

@property (strong, nonatomic) NSMutableDictionary *eColumns;
@property (strong, nonatomic) NSMutableDictionary *eLabels;

@end

@implementation EColumnChart
@synthesize minColumnColor = _minColumnColor;
@synthesize maxColumnColor = _maxColumnColor;
@synthesize normalColumnColor = _normalColumnColor;
@synthesize eColumns = _eColumns;
@synthesize eLabels = _eLabels;
@synthesize leftMostIndex = _leftMostIndex;
@synthesize rightMostIndex = _rightMostIndex;
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        /**还没释放，uiview结束的时候，是不是需要释放资源*/
        _eLabels = [NSMutableDictionary dictionary];
        _eColumns = [NSMutableDictionary dictionary];
    }
    return self;
}


- (void)setDelegate:(id<EColumnChartDelegate>)delegate
{
    if (_delegate != delegate)
    {
        _delegate = delegate;
    }
}

- (void)setDataSource:(id<EColumnChartDataSource>)dataSource
{
    if (_dataSource != dataSource)
    {
        _dataSource = dataSource;
        
        {
            int totalColumnsRequired = 0;
            totalColumnsRequired = [_dataSource numberOfColumnsPresentedEveryTime:self];
            int totalColumns = 0;
            totalColumns = [_dataSource numberOfColumnsInEColumnChart:self];
            if (0 == totalColumns)
            {
                NSLog(@"numberOfColumnsInEColumnChart haven't been set!");
                return ;
            }
            if (0 == totalColumnsRequired) {
                NSLog(@"numberOfColumnsPresentedEveryTime haven't been set!");
                return ;
            }
            /**暂时只支持，从右向左布局，也就是最右边的是原点*/
            _rightMostIndex = 0;
            _leftMostIndex = _rightMostIndex + totalColumnsRequired - 1;
            /**初始化，最高最低值的颜色*/
            _minColumnColor = EMinValueColor;
            _maxColumnColor = EMaxValueColor;
            
            /**构建横向坐标线*/
            /**构建横向坐标线的数值*/
            float highestValueEColumnChart = [_dataSource highestValueEColumnChart:self] * 1.1;//为了给最高值留一点余地
            for (int i = 0; i < 11; i++)
            {
                float heightGap = self.frame.size.height / 10.0;
                float valueGap = highestValueEColumnChart / 10.0;
                UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, heightGap * i, self.frame.size.width, HORIZONTAL_LINE_HEIGHT)];
                horizontalLine.backgroundColor = ELightGrey;
                [self addSubview:horizontalLine];
                
                EColumnChartLabel *eColumnChartLabel = [[EColumnChartLabel alloc] initWithFrame:CGRectMake(-1 * Y_COORDINATE_LABEL_WIDTH, -heightGap / 2.0 + heightGap * i, Y_COORDINATE_LABEL_WIDTH, heightGap)];
                [eColumnChartLabel setTextAlignment:NSTextAlignmentCenter];
                eColumnChartLabel.text = [NSString stringWithFormat:@"%.1f kWh", valueGap * (10 - i)];

                //eColumnChartLabel.backgroundColor = ELightBlue;
                [self addSubview:eColumnChartLabel];
            }
            
        }

        [self reloadData];
    }
}

- (void)initData
{
    
}

- (void)reloadData
{
    //self.backgroundColor = [UIColor grayColor];
    
    int totalColumnsRequired = 0;
    totalColumnsRequired = [_dataSource numberOfColumnsPresentedEveryTime:self];
    float highestValueEColumnChart = [_dataSource highestValueEColumnChart:self] * 1.1;//为了给最高值留一点余地
    if (0 == totalColumnsRequired)
    {
        NSLog(@"numberOfColumnsPresentedEveryTime haven't been set.");
        return;
    }
    if (0 == highestValueEColumnChart)
    {
        NSLog(@"highestValueEColumnChart haven't been set.");
        return;
    }
    
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
        /**判断当前最大最小值，并设置为响应的颜色*/
        if (eColumnDataModel.value > maxValue) {
            maxIndex =  currentIndex;
            maxValue = eColumnDataModel.value;
        }
        if (eColumnDataModel.value < minValue) {
            minIndex = currentIndex;
            minValue = eColumnDataModel.value;
        }
        
        /**构建Column*/
        EColumn *eColumn = [_eColumns objectForKey: [NSNumber numberWithInteger:currentIndex ]];
        if (nil == eColumn)
        {
            eColumn = [[EColumn alloc] initWithFrame:CGRectMake(widthOfTheColumnShouldBe * 0.5 + (i * widthOfTheColumnShouldBe * 1.5), 0, widthOfTheColumnShouldBe, self.frame.size.height)];
            eColumn.backgroundColor = [UIColor whiteColor];
            eColumn.barColor = EGrey;
            eColumn.backgroundColor = [UIColor clearColor];
            eColumn.grade = eColumnDataModel.value / highestValueEColumnChart;
            eColumn.eColumnDataModel = eColumnDataModel;
            [eColumn setDelegate:self];
            [self addSubview:eColumn];
            [_eColumns setObject:eColumn forKey:[NSNumber numberWithInteger:currentIndex ]];
        }
        eColumn.barColor = EGrey;
        
        /**构建Column对应的label*/
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
    EColumn *eColumn = [_eColumns objectForKey: [NSNumber numberWithInteger: maxIndex]];
    eColumn.barColor = _maxColumnColor;
    eColumn = [_eColumns objectForKey: [NSNumber numberWithInteger: minIndex]];
    eColumn.barColor = _minColumnColor;
    
    
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
        /**暂时不实现动画效果*/
//        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//            eColumn.frame = nextEColumn.frame;
//        } completion:nil];
        
    }
    
    [self reloadData];
}


#pragma -mark- EColumnDelegate
- (void)eColumnTaped:(EColumn *)eColumn
{
    [_delegate eColumnChart:self didSelectColumnAtIndex:eColumn.eColumnDataModel.index withEColumnDataModel:eColumn.eColumnDataModel];
}

- (void)eColumnLongPressed:(EColumn *)eColumn
{
    NSLog(@"Index: %d Value: %.1f",  eColumn.eColumnDataModel.index, eColumn.eColumnDataModel.value);
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
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *view = [self touchedViewWithTouches:touches andEvent:event];
    NSLog(@"%@",view);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *view = [self touchedViewWithTouches:touches andEvent:event];
    NSLog(@"%@",view);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *view = [self touchedViewWithTouches:touches andEvent:event];
    //NSLog(@"%@",view);
}

- (UIView *)touchedViewWithTouches:(NSSet *)touches andEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];

    UIView *touchedView;

    for (EColumn *view in _eColumns.objectEnumerator)
    {
        if(CGRectContainsPoint(view.frame, touchLocation))
        {
            touchedView = view;
            NSLog(@"%@",view);
            break;
        }
    }

    return touchedView;
}

@end
