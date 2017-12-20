//
//  MY_MIKE_Model.h
//  XinShengInternational
//
//  Created by michelle on 2017/9/27.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 MIKE指标又叫麦克指标，其英文全称是“Mike Base”,是一种专门研究股价各种压力和支撑的中长期技术分析工具。
 */
@interface MY_MIKE_Model : NSObject
@property (nonatomic, assign) double WR;
@property (nonatomic, assign) double MR;
@property (nonatomic, assign) double SR;
@property (nonatomic, assign) double WS;
@property (nonatomic, assign) double MS;
@property (nonatomic, assign) double SS;

@property (nonatomic, assign) double WR_Height;
@property (nonatomic, assign) double MR_Height;
@property (nonatomic, assign) double SR_Height;
@property (nonatomic, assign) double WS_Height;
@property (nonatomic, assign) double MS_Height;
@property (nonatomic, assign) double SS_Height;

@property (nonatomic, assign) double Width;
@end
