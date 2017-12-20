//
//  MY_KD_Model.h
//  XinShengInternational
//
//  Created by michelle on 2017/9/27.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 随机指标（KD）适用于中短期股票的技术分析。KD线的随机观念与移动平均线相比，各有所长。移动平均线在习惯上只以收盘价来计算，因而无法表现出一段行情的真正波幅。换句话说，当日或最近数日的最高价、最低价、无法在移动平均线上体现。因而有些专家才慢慢开创出一些更进步的技术理论，将移动平均线的运用发挥的淋漓尽致。KD线就是其中一个颇具代表性的杰作。
 */
@interface MY_KD_Model : NSObject
@property (nonatomic, assign) double RSV;

@property (nonatomic, assign) double K;
@property (nonatomic, assign) double D;

@property (nonatomic, assign) double K_Height;
@property (nonatomic, assign) double D_Height;

@property (nonatomic, assign) double Width;
@end
