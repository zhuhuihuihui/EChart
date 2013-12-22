//
//  EColumn.h
//  EChart
//
//  Created by Efergy China on 11/12/13.
//  Copyright (c) 2013 Scott Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EColumnDataModel.h"
@class EColumn;

@protocol EColumnDelegate <NSObject>

- (void)eColumnTaped:(EColumn *)eColumn;


@end


@interface EColumn : UIView

@property (nonatomic) float grade;

@property (nonatomic,strong) CAShapeLayer * chartLine;

@property (nonatomic, strong) UIColor * barColor;

@property (nonatomic, strong) EColumnDataModel *eColumnDataModel;

-(void)rollBack;

@property (weak, nonatomic) id <EColumnDelegate> delegate;
@end
