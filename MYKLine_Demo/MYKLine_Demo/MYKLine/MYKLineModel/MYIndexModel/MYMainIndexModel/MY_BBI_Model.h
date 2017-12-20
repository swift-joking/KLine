//
//  MY_BBI_Model.h
//  XinShengInternational
//
//  Created by michelle on 2017/9/27.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 多空线(BBI)是一个统计性指标。它是将主动买、主动卖的成交按时间区间分别统计而形成的一个曲线。多空线有两条线，以交叉方式提示买入卖出。
 */
@interface MY_BBI_Model : NSObject
@property (nonatomic, assign) double BBI;
@property (nonatomic, assign) double BBI_Height;

@property (nonatomic, assign) double Width;
@end
