//
//  EViewSwitcher.h
//  EChartDemo
//
//  Created by Scott Zhu on 14-1-30.
//  Copyright (c) 2014年 Scott Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EViewSwitcher;

@protocol EViewSwitcherDataSource <NSObject>

@required
- (NSInteger) numberOfViewsInEViewSwitcher:(EViewSwitcher *)eViewSwitcher;

- (UIView *) eSwitcher:(EViewSwitcher *)eViewSwitcher
           viewAtIndex:(NSInteger)index;


@end

@protocol EViewSwitcherDelegate <NSObject>

@optional

@end

@interface EViewSwitcher : UIView

@property (strong, nonatomic) NSArray *arrayOfViews;
@property (strong, nonatomic) UIView *topView;

@property (weak, nonatomic) id <EViewSwitcherDataSource> dataSource;
@property (weak, nonatomic) id <EViewSwitcherDelegate> delegate;


@end
