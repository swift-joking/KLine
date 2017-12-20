//
//  MY_ARBR_Model.h
//  XinShengInternational
//
//  Created by michelle on 2017/9/27.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 AR指标是反映市场当前情况下多空双方力量发展对比的结果。它是以当日的开盘价为基点。与当日最高价相比较，依固定公式计算出来的强弱指标。
 */
@interface MY_ARBR_Model : NSObject
@property (nonatomic, assign) NSInteger N;
@property (nonatomic, assign) double AR;
@property (nonatomic, assign) double BR;

@property (nonatomic, assign) double AR_Height;
@property (nonatomic, assign) double BR_Height;

@property (nonatomic, assign) double Width;
@end
