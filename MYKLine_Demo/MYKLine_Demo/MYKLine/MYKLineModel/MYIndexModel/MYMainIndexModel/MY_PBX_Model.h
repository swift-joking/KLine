//
//  MY_PBX_Model.h
//  XinShengInternational
//
//  Created by michelle on 2017/9/27.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 瀑布线(PBX)是欧美国家九十年代初，广泛应用于金融领域中的判断股价运行趋势的主要分析方法，因此经由汇聚向下发散时呈瀑布状而得名。属于传统大势价格趋势线，它的真正名称叫做非线性加权移动平均线，是由六条非线性加权移动平均线组合而成，每条平均线分别代表着不同时间周期的股价成本状况，方便进行对比分析。
 
 瀑布线是一种中线指标，一般用来研究股价的中期走势，与普通均线系统相比较，它具有反应速度快，给出的买卖点明确的特点，并能过滤掉盘中主力震仓洗盘或下跌行情中的小幅反弹，可直观有效地把握住大盘和个股的运动趋势，是目前判断大势和个股股价运行趋势颇为有效的均线系统。
 */
@interface MY_PBX_Model : NSObject

@property (nonatomic, assign) double EMA1;
@property (nonatomic, assign) double EMA2;
@property (nonatomic, assign) double EMA3;
@property (nonatomic, assign) double EMA4;
@property (nonatomic, assign) double EMA5;
@property (nonatomic, assign) double EMA6;

@property (nonatomic, assign) double PBX1;
@property (nonatomic, assign) double PBX2;
@property (nonatomic, assign) double PBX3;
@property (nonatomic, assign) double PBX4;
@property (nonatomic, assign) double PBX5;
@property (nonatomic, assign) double PBX6;

@property (nonatomic, assign) double PBX1_Height;
@property (nonatomic, assign) double PBX2_Height;
@property (nonatomic, assign) double PBX3_Height;
@property (nonatomic, assign) double PBX4_Height;
@property (nonatomic, assign) double PBX5_Height;
@property (nonatomic, assign) double PBX6_Height;

@property (nonatomic, assign) double Width;
@end
