//
//  MYKLineDataModel.h
//  XinShengInternational
//
//  Created by michelle on 2017/9/8.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MY_Candle_Model;
@class MY_BBI_Model;
@class MY_BOLL_Model;
@class MY_MA_Model;
@class MY_MIKE_Model;
@class MY_PBX_Model;
@class MY_ARBR_Model;
@class MY_ATR_Model;
@class MY_BIAS_Model;
@class MY_CCI_Model;
@class MY_DKBY_Model;
@class MY_KD_Model;
@class MY_KDJ_Model;
@class MY_LWR_Model;
@class MY_MACD_Model;
@class MY_QHLSR_Model;
@class MY_RSI_Model;
@class MY_WR_Model;
@class MY_Time_Model;

@interface MYKLineDataModel : NSObject


@property (nonatomic, retain) NSNumber *OpenPrice;
@property (nonatomic, retain) NSNumber *ClosePrice;
@property (nonatomic, retain) NSNumber *LowPrice;
@property (nonatomic, retain) NSNumber *HighPrice;
@property (nonatomic, retain) NSNumber *Volume;
@property (nonatomic, retain) NSString *PriceTime;

//@property (nonatomic, assign) double MA_Value;
@property (nonatomic, retain) MY_Time_Model *timeSharing;
/// 蜡烛图
@property (nonatomic, retain) MY_Candle_Model *Candle;
/// minute图数据 - 主指标
@property (nonatomic, retain) MY_BBI_Model *BBI;
@property (nonatomic, retain) MY_BOLL_Model *BOLL;
@property (nonatomic, retain) MY_MA_Model *MA;
@property (nonatomic, retain) MY_MIKE_Model *MIKE;
@property (nonatomic, retain) MY_PBX_Model *PBX;
/// minute图数据 - 副指标
@property (nonatomic, retain) MY_ARBR_Model *ARBR;
@property (nonatomic, retain) MY_ATR_Model *ATR;
@property (nonatomic, retain) MY_BIAS_Model *BIAS;
@property (nonatomic, retain) MY_CCI_Model *CCI;
@property (nonatomic, retain) MY_DKBY_Model *DKBY;
@property (nonatomic, retain) MY_KD_Model *KD;
@property (nonatomic, retain) MY_KDJ_Model *KDJ;
@property (nonatomic, retain) MY_LWR_Model *LWR;
@property (nonatomic, retain) MY_MACD_Model *MACD;
@property (nonatomic, retain) MY_QHLSR_Model *QHLSR;
@property (nonatomic, retain) MY_RSI_Model *RSI;
@property (nonatomic, retain) MY_WR_Model *WR;
@end
