//
//  MY_BIAS_Model.h
//  XinShengInternational
//
//  Created by michelle on 2017/9/27.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 乖离，指市场指数或收盘价与某条移动平均价格之间的差距。
 乖离率(BIAS)，又称偏离率，简称Y值，是通过计算市场指数或收盘价与某条移动平均线之间的差距百分比，以反映一定时期内价格与其MA偏离程度的指标，从而得出价格在剧烈波动时因偏离移动平均趋势而造成回档或反弹的可能性，以及价格在正常波动范围内移动而形成继续原有势的可信度。

 */
@interface MY_BIAS_Model : NSObject
@property (nonatomic, assign) double BIAS1;
@property (nonatomic, assign) double BIAS2;
@property (nonatomic, assign) double BIAS3;


@property (nonatomic, assign) double BIAS1_Height;
@property (nonatomic, assign) double BIAS2_Height;
@property (nonatomic, assign) double BIAS3_Height;

@property (nonatomic, assign) double Width;
@end
