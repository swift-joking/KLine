//
//  MY_BOLL_Model.h
//  XinShengInternational
//
//  Created by michelle on 2017/9/27.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 布林线（Boll）指标是通过计算股价的“标准差”，再求股价的“信赖区间”。该指标在图形上画出三条线，其中上下两条线可以分别看成是股价的压力线和支撑线，而在两条线之间还有一条股价平均线，布林线指标的参数最好设为20。一般来说，股价会运行在压力线和支撑线所形成的通道中。
 */
@interface MY_BOLL_Model : NSObject

@property (nonatomic, assign) double MID;
@property (nonatomic, assign) double UPPER;
@property (nonatomic, assign) double LOWER;

@property (nonatomic, assign) double MID_Height;
@property (nonatomic, assign) double UPPER_Height;
@property (nonatomic, assign) double LOWER_Height;

@property (nonatomic, assign) double Width;
@end
