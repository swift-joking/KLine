//
//  MYKLineTool.h
//  XinShengInternational
//
//  Created by michelle on 2017/9/7.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MYKLineTool : NSObject

#pragma mark - 分时图
/// 根据小数点位数保留string
+ (NSString *)getNumberWithDigits:(int)Digits Number:(double)Number;

/// 根据price转换成对应的y点
+ (CGFloat)priceTurnToY:(double)price
               maxValue:(double)maxValue
               minValue:(double)minValue
             viewHeight:(double)viewHeight;

/// 根据y点转换成对应的price
+ (CGFloat)YTurnToPrice:(double)y
               maxValue:(double)maxValue
               minValue:(double)minValue
             viewHeight:(double)viewHeight;

/// 计算firstNume和lastNume
+ (void)getFirstNumeLastNum:(NSMutableArray *)KLineDataArray;

/// 根据x点转换成对应的priceTime
+ (NSString *)XTurnToPriceTime:(double)x
               viewWidth:(double)viewWidth
          KLineDataArray:(NSMutableArray *)KLineDataArray;

/// 处理分数图左侧价格的区间定价
+ (NSMutableArray *)setTimeSharingLeftPrice:(NSMutableArray *)KLineArray
                              digits:(int)digits;


#pragma mark - minute图
+ (void)drawMainIndexBackgroundLineWithView:(UIView *)view;

+ (void)drawPlotIndexBackgroundLineWithView:(UIView *)view;

/// 移除所有子试图
+ (UIView *)removeAllSubView:(UIView *)view;


/// 简单平滑移动平均线-MA
+ (double)getAveragePriceWithDataArray:(NSMutableArray *)dataArray
                            currentDay:(int)currentDay
                                aveDay:(int)aveDay;
/// 指数平滑移动平均线-EXPMA
+ (double)getEXPMAWithDataArray:(NSMutableArray *)dataArray
                            currentDay:(int)currentDay
                                aveDay:(int)aveDay
                      yesterEMA:(double)yesterEMA;

/// 设置主指标最大值和最小值
+ (void)setMainIndexMaxValueMinValue:(NSString *)indexName;

/// 设置副指标最大值和最小值
+ (void)setPlotIndexMaxValueMinValue:(NSString *)indexName;

/// 计算MainPriceLabel的值
+ (void)setMainPriceValueWithView:(UIView *)view;

/// 计算PlotPriceLabel的值
+ (void)setPlotPriceValueWithView:(UIView *)view;

/// 获得宽度
+ (double)getWidthWith:(NSInteger)i
                  view:(UIView *)view;

/// 设置蜡烛图的Height
+ (void)setMainIndexHeightWithView:(UIView *)view
                      indexName:(NSString *)indexName;

/// 设置蜡烛图的Height
+ (void)setPlotIndexHeightWithView:(UIView *)view
                         indexName:(NSString *)indexName;

/// 画现价线
+ (void)drawCurrentPriceLine:(UIView *)view
                   dataArray:(NSMutableArray *)dataArray;


/// 绘制指标折线图
+ (void)drawIndexLineChart:(UIView *)view
                pointArray:(NSMutableArray *)pointArray
                 lineColor:(UIColor *)lineColor;

/// 画指标图
+ (void)drawIndexLine:(NSString *)indexName
                 view:(UIView *)view
            dataArray:(NSMutableArray *)dataArray;
@end
