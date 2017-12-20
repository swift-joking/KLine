//
//  MYKLine_Global.h
//  XinShengInternational
//
//  Created by michelle on 2017/9/7.
//  Copyright © 2017年 michelle. All rights reserved.
//

#ifndef MYKLine_Global_h
#define MYKLine_Global_h

// 弱引用
#define weakify(A) __weak __typeof(A) weakSelf = A

/// 分时图
#define SCREEN_WIDTH                   [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                  [UIScreen mainScreen].bounds.size.height
#define PHONE_WIDTH                    SCREEN_WIDTH/750
#define PHONE_HEIGHT                   SCREEN_HEIGHT/1334

#define BACKLINE_WIDTH 1.0;
//------------------ 颜色 ------------------
#define BACKLINE_COLOR RGB(226,226,226);              //背景虚线颜色
#define BACKLINE_CGCOLOR RGB(226,226,226).CGColor;    //背景虚线颜色CG
#define TIMESHARING_COLOR RGB(117,142,210);           //折线颜色
#define TIMESHARING_CGCOLOR RGB(117,142,210).CGColor; //折线颜色CG
#define TIMEFILL_COLOR RGB(221,229,251);              //填充颜色
#define TIMEFILL_CGCOLOR RGB(221,229,251).CGColor;    //填充颜色CG
#define TIMEAVEPRICE_COLOR RGB(232,172,44);           //均线颜色
#define TIMEAVEPRICE_CGCOLOR RGB(232,172,44).CGColor; //均线颜色CG
#define INDEX1_CGCOLOR RGB(158,190,230).CGColor;      //指标1颜色CG-蓝色
#define INDEX2_CGCOLOR RGB(230,218,73).CGColor;       //指标2颜色CG
#define INDEX3_CGCOLOR RGB(196,188,230).CGColor;      //指标3颜色CG-黄色
#define INDEX4_CGCOLOR RGB(171,218,230).CGColor;      //指标4颜色CG-紫色
#define INDEX5_CGCOLOR RGB(230,177,209).CGColor;      //指标5颜色CG-青色

#define INDEX1_COLOR RGB(158,190,230);      //指标1颜色-蓝色
#define INDEX2_COLOR RGB(230,218,73);       //指标2颜色-黄色
#define INDEX3_COLOR RGB(196,188,230);      //指标3颜色-紫色
#define INDEX4_COLOR RGB(171,218,230);      //指标4颜色-青色
#define INDEX5_COLOR RGB(230,177,209);      //指标5颜色-粉色
#define INDEX6_COLOR RGB(65,105,235);       //指标5颜色-深蓝

#define INDEXGRAY_COLOR RGB(45,45,45);                //指标4颜色
#define INDEXGRSY_CGCOLOR RGB(45,45,45).CGColor;      //指标4颜色CG-粉色

/// 设置颜色
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
/// 设置红涨绿跌和绿涨红跌/默认绿涨红跌
#define UserDefaults          [NSUserDefaults standardUserDefaults]
#define MYKLINECHANGE_COLOR [UserDefaults boolForKey:@"MYKLine_ChangeColor"]
#define MYKLineASK_COLOR MYKLINECHANGE_COLOR ? RGB(245,81,81) : RGB(16,201,112)
#define MYKLineBID_COLOR MYKLINECHANGE_COLOR ? RGB(16,201,112) : RGB(245,81,81)
#define MYKLineASK_IMAGE MYKLINECHANGE_COLOR ? @"red_rise_icon" : @"green_rise_icon"
#define MYKLineBID_IMAGE MYKLINECHANGE_COLOR ? @"green_decline_icon" : @"red_decline_icon"

#import "MYKLineTool.h"
#import "MYKLineTool+MainIndex.h"
#import "MYKLineTool+PlotIndex.h"
#import "MYKLineTool+Algorithm.h"
#import "MYKLineTool+TimeSharing.h"
#import "MYKLineVC.h"
#import "MYKLineDataModel.h"

/// 主指标model
#import "MY_Candle_Model.h"
#import "MY_BBI_Model.h"
#import "MY_BOLL_Model.h"
#import "MY_MA_Model.h"
#import "MY_MIKE_Model.h"
#import "MY_PBX_Model.h"
/// 副指标model
#import "MY_ARBR_Model.h"
#import "MY_ATR_Model.h"
#import "MY_BIAS_Model.h"
#import "MY_CCI_Model.h"
#import "MY_DKBY_Model.h"
#import "MY_KD_Model.h"
#import "MY_KDJ_Model.h"
#import "MY_LWR_Model.h"
#import "MY_MACD_Model.h"
#import "MY_QHLSR_Model.h"
#import "MY_RSI_Model.h"
#import "MY_WR_Model.h"
#import "MY_Time_Model.h"


#import "FactoryTableViewCell.h"
#import "FactoryCollectionViewCell.h"
#import "BaseTableViewCell.h"
#import "BaseCollectionViewCell.h"
#import "HexColor.h"
#import "NSObject+Tool.h"
#import "AppDelegate.h"
#import "UIView+Frame.h"
#import "UIButton+CustomButton.h"

#endif /* MYKLine_Global_h */
