//
//  MY_DKBY_Model.h
//  XinShengInternational
//
//  Created by michelle on 2017/9/27.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 多空博弈指标 DKBY
 
 当“多方”线向上与“空方”线“金叉”时为买点。当“多方”线向下与“空方”线“死叉”时为卖点。
 */
@interface MY_DKBY_Model : NSObject

@property (nonatomic, assign) double SMA;

@property (nonatomic, assign) double SELL;
@property (nonatomic, assign) double BUY;
@property (nonatomic, assign) double ENE1;
@property (nonatomic, assign) double ENE2;

@property (nonatomic, assign) double SELL_Height;
@property (nonatomic, assign) double BUY_Height;
@property (nonatomic, assign) double ENE1_Height;
@property (nonatomic, assign) double ENE2_Height;

@property (nonatomic, assign) double Width;
@end
