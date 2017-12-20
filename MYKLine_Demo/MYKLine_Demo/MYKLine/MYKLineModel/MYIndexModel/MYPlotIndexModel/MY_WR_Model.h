//
//  MY_WR_Model.h
//  XinShengInternational
//
//  Created by michelle on 2017/9/27.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 W%R是威廉指标（Williams %R）利用摆动点来量度股市的超买卖现象，可以预测循环期内的高点或低点，从而提出有效率的投资讯号，%R=100－（C－Ln）/（Hn-Ln）×100。
 其中：C为当日收市价，Ln为N日内最低价，Hn为N日内最高价，公式中N日为选设参数，一般设为14日或20日。
 */
@interface MY_WR_Model : NSObject
@property (nonatomic, assign) double WR;

@property (nonatomic, assign) double WR_Height;

@property (nonatomic, assign) double Width;
@end
