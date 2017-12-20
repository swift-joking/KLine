//
//  TimeSharingVC.h
//  XinShengInternational
//
//  Created by michelle on 2017/9/6.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MYKLineDataModel;

@interface TimeSharingVC : UIViewController


/**
 绘制分时图
 */
- (void)dealWithData;


/**
 刷新MYKLineVC的PriceLabel
 */
@property (nonatomic, copy) void (^updatePriceLabel)(void);

@end
