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
    int highestValueEColumnChart = [_dataSource highestValueEColumnChart:self];
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
        
        EColumn *eColumn = [_eColumns objectForKey: [NSNumber numberWithInteger:currentIndex ]];
        if (nil == eColumn)
        {
            eColumn = [[EColumn alloc] initWithFrame:CGRectMake(widthOfTheColumnShouldBe * 0.5 + (i * widthOfTheColumnShouldBe * 1.5), 0, widthOfTheColumnShouldBe, self.frame.size.height)];
            eColumn.backgroundColor = [UIColor whiteColor];
            eColumn.barColor = EGrey;
            eColumn.grade = eColumnDataModel.value / highestValueEColumnChart;
            [self addSubview:eColumn];
            [_eColumns setObject:eColumn forKey:[NSNumber numberWithInteger:currentIndex ]];
        }
        eColumn.barColor = EGrey;
        
        
        EColumnChartLabel *eColumnChartLabel = [_eLabels objectForKey:[NSNumber numberWithInteger:(currentIndex)]];
        if (nil == eColumnChartLabel)
        {
            eColumnChartLabel = [[EColumnChartLabel alloc] initWithFrame:CGRectMake(widthOfTheColumnShouldBe * 0.5 + (i * widthOfTheColumnShouldBe * 1.5), self.frame.size.height, widthOfTheColumnShouldBe, 20)];
            [eColumnChartLabel setTextAlignment:NSTextAlignmentCenter];
            eColumnChartLabel.text = eColumnDataModel.label;
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
