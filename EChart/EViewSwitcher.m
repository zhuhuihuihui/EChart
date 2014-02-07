//
//  EViewSwitcher.m
//  EChartDemo
//
//  Created by Scott Zhu on 14-1-30.
//  Copyright (c) 2014年 Scott Zhu. All rights reserved.
//

#import "EViewSwitcher.h"
@interface EViewSwitcher()

@end

@implementation EViewSwitcher
@synthesize arrayOfViews = _arrayOfViews;
@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;
@synthesize topView = _topView;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor purpleColor];
    }
    return self;
}


#pragma -mark- Setter and Getter
-(void)setDataSource:(id<EViewSwitcherDataSource>)dataSource
{
    if (dataSource && dataSource != _dataSource)
    {
        _dataSource = dataSource;
    }
}

- (void)setDelegate:(id<EViewSwitcherDelegate>)delegate
{
    if (delegate && delegate != _delegate)
    {
        _delegate = delegate;
    }
}


@end
