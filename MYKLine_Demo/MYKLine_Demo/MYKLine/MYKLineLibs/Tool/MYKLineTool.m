//
//  MYKLineTool.m
//  XinShengInternational
//
//  Created by michelle on 2017/9/7.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import "MYKLineTool.h"

@implementation MYKLineTool
/// 根据小数点位数保留string
+ (NSString *)getNumberWithDigits:(int)Digits Number:(double)Number{
    NSString *string = [NSString stringWithFormat:@"%@%@f",@"%",[NSString stringWithFormat:@".%d",Digits]];
    NSString *numberStr = [NSString stringWithFormat:string,Number];
    return numberStr;
}

/// 根据price转换成对应的y点
+ (CGFloat)priceTurnToY:(double)price
               maxValue:(double)maxValue
               minValue:(double)minValue
             viewHeight:(double)viewHeight{
    double resule = 0;
    if ((maxValue - minValue) != 0) {
        resule = (maxValue - price) * viewHeight / (maxValue - minValue);
    } else {
        resule = viewHeight / 2;
    }
    return resule;
}

/// 根据y点转换成对应的price
+ (CGFloat)YTurnToPrice:(double)y
               maxValue:(double)maxValue
               minValue:(double)minValue
             viewHeight:(double)viewHeight{
    return maxValue - y * (maxValue - minValue) / viewHeight;
}

/// 计算firstNume和lastNume
+ (void)getFirstNumeLastNum:(NSMutableArray *)KLineDataArray {
    NSInteger lastNum;
    NSInteger firstNum;
    if (KLineDataArray.count < MYKLineVC.shareMYKLineVC.lastDataCount) {
        MYKLineVC.shareMYKLineVC.lastDataCount = KLineDataArray.count;
    }
    lastNum = MYKLineVC.shareMYKLineVC.lastDataCount;
    firstNum = MYKLineVC.shareMYKLineVC.lastDataCount - MYKLineVC.shareMYKLineVC.candleNum;
    
    if (firstNum < 0) {
        if (MYKLineVC.shareMYKLineVC.lastDataCount < KLineDataArray.count) {
            firstNum = KLineDataArray.count - MYKLineVC.shareMYKLineVC.candleNum;
            lastNum = KLineDataArray.count;
            if (firstNum < 0) {
                firstNum = 0;
            }
        } else {
            if (KLineDataArray.count < MYKLineVC.shareMYKLineVC.candleNum) {
                firstNum = 0;
                lastNum = KLineDataArray.count;
            }
        }
    }
    
    MYKLineVC.shareMYKLineVC.firstNum = firstNum;
    MYKLineVC.shareMYKLineVC.lastNum = lastNum;
}

/// 根据x点转换成对应的priceTime
+ (NSString *)XTurnToPriceTime:(double)x
               viewWidth:(double)viewWidth
          KLineDataArray:(NSMutableArray *)KLineDataArray{

    NSInteger currentNum = (x - 5) * MYKLineVC.shareMYKLineVC.candleNum / (viewWidth - 10) + MYKLineVC.shareMYKLineVC.firstNum;
    MYKLineDataModel *currentModel = KLineDataArray[currentNum];
    NSString *timeStr = [NSString stringWithString:currentModel.PriceTime];
    return timeStr;
}

/// 处理分数图左侧价格的区间定价
+ (NSMutableArray *)setTimeSharingLeftPrice:(NSMutableArray *)KLineArray
                                     digits:(int)digits{
    NSMutableArray *resultArray = [NSMutableArray array];
//    if (KLineArray.count) {
        BOOL maxDevIsHeight = YES;
        NSNumber *maxValue = [NSNumber numberWithDouble:0];
        NSNumber *minValue = [NSNumber numberWithDouble:MAXFLOAT];
        double devValue = 0;
        for (MYKLineDataModel *model in KLineArray) {
            maxValue = [maxValue doubleValue] > [model.HighPrice doubleValue] ? maxValue : model.HighPrice;
            minValue = [minValue doubleValue] < [model.LowPrice doubleValue] ? minValue : model.LowPrice;
        }
        devValue = fabs([maxValue doubleValue] - [((MYKLineDataModel *)KLineArray[0]).OpenPrice doubleValue]) > fabs([minValue doubleValue] - [((MYKLineDataModel *)KLineArray[0]).OpenPrice doubleValue]) ? fabs([maxValue doubleValue] - [((MYKLineDataModel *)KLineArray[0]).OpenPrice doubleValue]) : fabs([minValue doubleValue] - [((MYKLineDataModel *)KLineArray[0]).OpenPrice doubleValue]);
        maxDevIsHeight = fabs([maxValue doubleValue] - [((MYKLineDataModel *)KLineArray[0]).OpenPrice doubleValue]) > fabs([minValue doubleValue] - [((MYKLineDataModel *)KLineArray[0]).OpenPrice doubleValue]) ? YES : NO;
        
        for (int i = 0; i < 7; i++) {
//            UILabel *label = self.priceLabelAry[i];
            NSString *price = [NSString string];
            if (i == 3) {
                price = [((MYKLineDataModel *)KLineArray[0]).OpenPrice stringValue];
            } else if (i < 3) {
                NSNumber *newValue = [NSNumber numberWithDouble:[((MYKLineDataModel *)KLineArray[0]).OpenPrice doubleValue] + devValue * (3 - i) / 3];
                //                label.text = [newValue stringValue];
                price = [self getNumberWithDigits:digits Number:[newValue doubleValue]];
            } else {
                NSNumber *newValue = [NSNumber numberWithDouble:[((MYKLineDataModel *)KLineArray[0]).OpenPrice doubleValue] - devValue * (i - 3) / 3];
                price = [self getNumberWithDigits:digits Number:[newValue doubleValue]];
            }
            if (i == 0) {
                if (maxDevIsHeight) {
                    price = [maxValue stringValue];
                }
            }
            if (i == 6) {
                if (!maxDevIsHeight) {
                    price = [minValue stringValue];
                }
            }
            [resultArray addObject:price];
        }
//    }
    return resultArray;
}


#pragma mark - minute图
/// 画主指标图背景线和价格label
+ (void)drawMainIndexBackgroundLineWithView:(UIView *)view{
    double width = view.frame.size.width;
    double height = view.frame.size.height;
    // 画横线
    for (int i = 1; i < 4; i++) {
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        pathLayer.lineCap     = kCALineCapRound;
        pathLayer.lineJoin    = kCALineJoinBevel;
        pathLayer.fillColor   = [[UIColor blueColor] CGColor];
        [view.layer addSublayer:pathLayer];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineWidth = BACKLINE_WIDTH;
        [path setLineCapStyle:kCGLineCapRound];
        [path setLineJoinStyle:kCGLineJoinRound];
        [path moveToPoint:CGPointMake(0, height / 4 * i)];
        [path addLineToPoint:CGPointMake(width, height / 4 * i)];
        pathLayer.path = path.CGPath;
        pathLayer.strokeColor = BACKLINE_CGCOLOR;//设置线的颜色
    }
}

/// 画副指标图背景线和价格label
+ (void)drawPlotIndexBackgroundLineWithView:(UIView *)view{
    double width = view.frame.size.width;
    double height = view.frame.size.height;
    // 画横线
    for (int i = 1; i < 2; i++) {
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        pathLayer.lineCap     = kCALineCapRound;
        pathLayer.lineJoin    = kCALineJoinBevel;
        pathLayer.fillColor   = [[UIColor blueColor] CGColor];
        [view.layer addSublayer:pathLayer];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineWidth = BACKLINE_WIDTH;
        [path setLineCapStyle:kCGLineCapRound];
        [path setLineJoinStyle:kCGLineJoinRound];
        [path moveToPoint:CGPointMake(0, height / 2 * i)];
        [path addLineToPoint:CGPointMake(width, height / 2 * i)];
        pathLayer.path = path.CGPath;
        pathLayer.strokeColor = BACKLINE_CGCOLOR;//设置线的颜色
    }
}

// 蜡烛图
+ (void)drawCandlestickChartsWithDataArray:(NSMutableArray *)dataArray
                                 pathLayer:(CAShapeLayer *)pathLayer
                                      path:(UIBezierPath *)path {
    
}

/// 移除所有子试图
+ (UIView *)removeAllSubView:(UIView *)view {
    for (UIView *subView in view.subviews) {
        [subView removeFromSuperview];
    }
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    [view addSubview:subView];
    return subView;
}

/// 简单平滑移动平均线-MA
+ (double)getAveragePriceWithDataArray:(NSMutableArray *)dataArray
                            currentDay:(int)currentDay
                                aveDay:(int)aveDay{
    double result = 0;
    if (currentDay < aveDay - 1) {
        for (int j = 0; j <= currentDay; j++) {
            MYKLineDataModel *detailModel = dataArray[j];
            result += [detailModel.ClosePrice doubleValue];
        }
        result = result / (currentDay + 1);
    } else {
        for (int j = currentDay - aveDay + 1; j <= currentDay; j++) {
            MYKLineDataModel *detailModel = dataArray[j];
            result += [detailModel.ClosePrice doubleValue];
        }
        result = result / aveDay;
    }
    return result;
}

/// 指数平滑移动平均线-EXPMA
+ (double)getEXPMAWithDataArray:(NSMutableArray *)dataArray
                     currentDay:(int)currentDay
                         aveDay:(int)aveDay
                      yesterEMA:(double)yesterEMA{
    double result = 0;
    if (currentDay == 0) {    // 第一天EMA默认为closePrice
        MYKLineDataModel *detailModel = dataArray[0];
        result = [detailModel.ClosePrice doubleValue];
    } else {
        if (currentDay < aveDay - 1) {
            MYKLineDataModel *detailModel = dataArray[currentDay];
            result = 2 * [detailModel.ClosePrice doubleValue] / (currentDay + 1 + 1) + (currentDay + 1 - 1) * yesterEMA / (currentDay + 1 + 1);
            
        } else {
            MYKLineDataModel *detailModel = dataArray[currentDay];
            result = 2 * [detailModel.ClosePrice doubleValue] / (aveDay + 1) + (aveDay - 1) * yesterEMA / (aveDay + 1);
        }
    }
    return result;
}

/// 设置主指标最大值和最小值
+ (void)setMainIndexMaxValueMinValue:(NSString *)indexName {
    double maxValue = 0;
    double minValue = MAXFLOAT;
    MYKLineVC.shareMYKLineVC.mainIndex_maxValue = 0;
    MYKLineVC.shareMYKLineVC.mainIndex_minValue = MAXFLOAT;
    for (NSInteger i = MYKLineVC.shareMYKLineVC.firstNum ; i < MYKLineVC.shareMYKLineVC.lastNum ; i++) {
        MYKLineDataModel *model = MYKLineVC.shareMYKLineVC.KLineDataArray[i];
        maxValue = maxValue > [model.OpenPrice doubleValue] ? maxValue : [model.OpenPrice doubleValue];
        maxValue = maxValue > [model.ClosePrice doubleValue] ? maxValue : [model.ClosePrice doubleValue];
        maxValue = maxValue > [model.HighPrice doubleValue] ? maxValue : [model.HighPrice doubleValue];
        maxValue = maxValue > [model.LowPrice doubleValue] ? maxValue : [model.LowPrice doubleValue];
        minValue = minValue < [model.OpenPrice doubleValue] ? minValue : [model.OpenPrice doubleValue];
        minValue = minValue < [model.ClosePrice doubleValue] ? minValue : [model.ClosePrice doubleValue];
        minValue = minValue < [model.HighPrice doubleValue] ? minValue : [model.HighPrice doubleValue];
        minValue = minValue < [model.LowPrice doubleValue] ? minValue : [model.LowPrice doubleValue];
        if ([indexName isEqualToString:@"BBI"]) {
            maxValue = maxValue > model.BBI.BBI ? maxValue : model.BBI.BBI;
            minValue = minValue < model.BBI.BBI ? minValue : model.BBI.BBI;
        } else if ([indexName isEqualToString:@"BOLL"]){
            maxValue = maxValue > model.BOLL.MID ? maxValue : model.BOLL.MID;
            maxValue = maxValue > model.BOLL.UPPER ? maxValue : model.BOLL.UPPER;
            maxValue = maxValue > model.BOLL.LOWER ? maxValue : model.BOLL.LOWER;
            minValue = minValue < model.BOLL.MID ? minValue : model.BOLL.MID;
            minValue = minValue < model.BOLL.UPPER ? minValue : model.BOLL.UPPER;
            minValue = minValue < model.BOLL.LOWER ? minValue : model.BOLL.LOWER;
        } else if ([indexName isEqualToString:@"MA"]) {
            maxValue = maxValue > model.MA.L1 ? maxValue : model.MA.L1;
            maxValue = maxValue > model.MA.L2 ? maxValue : model.MA.L2;
            maxValue = maxValue > model.MA.L3 ? maxValue : model.MA.L3;
            maxValue = maxValue > model.MA.L4 ? maxValue : model.MA.L4;
            maxValue = maxValue > model.MA.L5 ? maxValue : model.MA.L5;
            minValue = minValue < model.MA.L1 ? minValue : model.MA.L1;
            minValue = minValue < model.MA.L2 ? minValue : model.MA.L2;
            minValue = minValue < model.MA.L3 ? minValue : model.MA.L3;
            minValue = minValue < model.MA.L4 ? minValue : model.MA.L4;
            minValue = minValue < model.MA.L5 ? minValue : model.MA.L5;
        } else if ([indexName isEqualToString:@"MIKE"]) {
            maxValue = maxValue > model.MIKE.WR ? maxValue : model.MIKE.WR;
            maxValue = maxValue > model.MIKE.MR ? maxValue : model.MIKE.MR;
            maxValue = maxValue > model.MIKE.SR ? maxValue : model.MIKE.SR;
            maxValue = maxValue > model.MIKE.WS ? maxValue : model.MIKE.WS;
            maxValue = maxValue > model.MIKE.MS ? maxValue : model.MIKE.MS;
            maxValue = maxValue > model.MIKE.SS ? maxValue : model.MIKE.SS;
            
            minValue = minValue < model.MIKE.WR ? minValue : model.MIKE.WR;
            minValue = minValue < model.MIKE.MR ? minValue : model.MIKE.MR;
            minValue = minValue < model.MIKE.SR ? minValue : model.MIKE.SR;
            minValue = minValue < model.MIKE.WS ? minValue : model.MIKE.WS;
            minValue = minValue < model.MIKE.MS ? minValue : model.MIKE.MS;
            minValue = minValue < model.MIKE.SS ? minValue : model.MIKE.SS;
        } else if ([indexName isEqualToString:@"PBX"]) {
            maxValue = maxValue > model.PBX.PBX1 ? maxValue : model.PBX.PBX1;
            maxValue = maxValue > model.PBX.PBX2 ? maxValue : model.PBX.PBX2;
            maxValue = maxValue > model.PBX.PBX3 ? maxValue : model.PBX.PBX3;
            maxValue = maxValue > model.PBX.PBX4 ? maxValue : model.PBX.PBX4;
            maxValue = maxValue > model.PBX.PBX5 ? maxValue : model.PBX.PBX5;
            maxValue = maxValue > model.PBX.PBX6 ? maxValue : model.PBX.PBX6;
            
            minValue = minValue < model.PBX.PBX1 ? minValue : model.PBX.PBX1;
            minValue = minValue < model.PBX.PBX2 ? minValue : model.PBX.PBX2;
            minValue = minValue < model.PBX.PBX3 ? minValue : model.PBX.PBX3;
            minValue = minValue < model.PBX.PBX4 ? minValue : model.PBX.PBX4;
            minValue = minValue < model.PBX.PBX5 ? minValue : model.PBX.PBX5;
            minValue = minValue < model.PBX.PBX6 ? minValue : model.PBX.PBX6;
        }  else if ([indexName isEqualToString:@"ARBR"]) {
            maxValue = maxValue > model.ARBR.AR ? maxValue : model.ARBR.AR;
            maxValue = maxValue > model.ARBR.BR ? maxValue : model.ARBR.BR;
            
            minValue = minValue < model.ARBR.AR ? minValue : model.ARBR.AR;
            minValue = minValue < model.ARBR.BR ? minValue : model.ARBR.BR;
        }
    }
    MYKLineVC.shareMYKLineVC.mainIndex_maxValue = maxValue;
    MYKLineVC.shareMYKLineVC.mainIndex_minValue = minValue;
};


/// 设置副指标最大值和最小值
+ (void)setPlotIndexMaxValueMinValue:(NSString *)indexName {
    double maxValue = 0;
    double minValue = MAXFLOAT;
    MYKLineVC.shareMYKLineVC.plotIndex_maxValue = 0;
    MYKLineVC.shareMYKLineVC.plotIndex_minValue = MAXFLOAT;
    for (NSInteger i = MYKLineVC.shareMYKLineVC.firstNum ; i < MYKLineVC.shareMYKLineVC.lastNum ; i++) {
        MYKLineDataModel *model = MYKLineVC.shareMYKLineVC.KLineDataArray[i];
        if ([indexName isEqualToString:@"ARBR"]) {
            maxValue = maxValue > model.ARBR.AR ? maxValue : model.ARBR.AR;
            maxValue = maxValue > model.ARBR.BR ? maxValue : model.ARBR.BR;
            
            minValue = minValue < model.ARBR.AR ? minValue : model.ARBR.AR;
            minValue = minValue < model.ARBR.BR ? minValue : model.ARBR.BR;
        } else if ([indexName isEqualToString:@"ATR"]) {
            maxValue = maxValue > model.ATR.TR ? maxValue : model.ATR.TR;
            maxValue = maxValue > model.ATR.ATR ? maxValue : model.ATR.ATR;
            minValue = minValue < model.ATR.TR ? minValue : model.ATR.TR;
            minValue = minValue < model.ATR.ATR ? minValue : model.ATR.ATR;
        } else if ([indexName isEqualToString:@"BIAS"]) {
            maxValue = maxValue > model.BIAS.BIAS1 ? maxValue : model.BIAS.BIAS1;
            maxValue = maxValue > model.BIAS.BIAS2 ? maxValue : model.BIAS.BIAS2;
            maxValue = maxValue > model.BIAS.BIAS3 ? maxValue : model.BIAS.BIAS3;
            minValue = minValue < model.BIAS.BIAS1 ? minValue : model.BIAS.BIAS1;
            minValue = minValue < model.BIAS.BIAS2 ? minValue : model.BIAS.BIAS2;
            minValue = minValue < model.BIAS.BIAS3 ? minValue : model.BIAS.BIAS3;
        } else if ([indexName isEqualToString:@"CCI"]) {
            maxValue = maxValue > model.CCI.CCI ? maxValue : model.CCI.CCI;
            minValue = minValue < model.CCI.CCI ? minValue : model.CCI.CCI;
        } else if ([indexName isEqualToString:@"DKBY"]) {
            maxValue = maxValue > model.DKBY.BUY ? maxValue : model.DKBY.BUY;
            maxValue = maxValue > model.DKBY.SELL ? maxValue : model.DKBY.SELL;
            maxValue = maxValue > model.DKBY.ENE1 ? maxValue : model.DKBY.ENE1;
            maxValue = maxValue > model.DKBY.ENE2 ? maxValue : model.DKBY.ENE2;
            
            minValue = minValue < model.DKBY.BUY ? minValue : model.DKBY.BUY;
            minValue = minValue < model.DKBY.SELL ? minValue : model.DKBY.SELL;
            minValue = minValue < model.DKBY.ENE1 ? minValue : model.DKBY.ENE1;
            minValue = minValue < model.DKBY.ENE2 ? minValue : model.DKBY.ENE2;
        } else if ([indexName isEqualToString:@"KD"]) {
            maxValue = maxValue > model.KD.K ? maxValue : model.KD.K;
            maxValue = maxValue > model.KD.D ? maxValue : model.KD.D;
            
            minValue = minValue < model.KD.K ? minValue : model.KD.K;
            minValue = minValue < model.KD.D ? minValue : model.KD.D;
        } else if ([indexName isEqualToString:@"KDJ"]) {
            maxValue = maxValue > model.KDJ.K ? maxValue : model.KDJ.K;
            maxValue = maxValue > model.KDJ.D ? maxValue : model.KDJ.D;
            maxValue = maxValue > model.KDJ.J ? maxValue : model.KDJ.J;
            
            minValue = minValue < model.KDJ.K ? minValue : model.KD.K;
            minValue = minValue < model.KDJ.D ? minValue : model.KDJ.D;
            minValue = minValue < model.KDJ.J ? minValue : model.KDJ.J;
        } else if ([indexName isEqualToString:@"LW&R"]) {
            maxValue = maxValue > model.LWR.LWR1? maxValue : model.LWR.LWR1;
            maxValue = maxValue > model.LWR.LWR2 ? maxValue : model.LWR.LWR2;
            minValue = minValue < model.LWR.LWR1 ? minValue : model.LWR.LWR1;
            minValue = minValue < model.LWR.LWR2 ? minValue : model.LWR.LWR2;
        } else if ([indexName isEqualToString:@"MACD"]) {
            maxValue = maxValue > model.MACD.DIF ? maxValue : model.MACD.DIF;
            maxValue = maxValue > model.MACD.DEA ? maxValue : model.MACD.DEA;
            maxValue = maxValue > model.MACD.M ? maxValue : model.MACD.M;
            
            minValue = minValue < model.MACD.DIF ? minValue : model.MACD.DIF;
            minValue = minValue < model.MACD.DEA ? minValue : model.MACD.DEA;
            minValue = minValue < model.MACD.M ? minValue  : model.MACD.M;
        } else if ([indexName isEqualToString:@"QHLSR"]) {
            maxValue = maxValue > model.QHLSR.QHL5? maxValue : model.QHLSR.QHL5;
            maxValue = maxValue > model.QHLSR.QHL10 ? maxValue : model.QHLSR.QHL10;
            minValue = minValue < model.QHLSR.QHL5 ? minValue : model.QHLSR.QHL5;
            minValue = minValue < model.QHLSR.QHL10 ? minValue : model.QHLSR.QHL10;
        } else if ([indexName isEqualToString:@"RSI"]) {
            maxValue = maxValue > model.RSI.RSI1 ? maxValue : model.RSI.RSI1;
            maxValue = maxValue > model.RSI.RSI2 ? maxValue : model.RSI.RSI2;
            maxValue = maxValue > model.RSI.RSI3 ? maxValue : model.RSI.RSI3;
            minValue = minValue < model.RSI.RSI1 ? minValue : model.RSI.RSI1;
            minValue = minValue < model.RSI.RSI2 ? minValue : model.RSI.RSI2;
            minValue = minValue < model.RSI.RSI3 ? minValue : model.RSI.RSI3;
        } else if ([indexName isEqualToString:@"W&R"]) {
            maxValue = maxValue > model.WR.WR ? maxValue : model.WR.WR;
            minValue = minValue < model.WR.WR ? minValue : model.WR.WR;
        }
    }
    MYKLineVC.shareMYKLineVC.plotIndex_maxValue = maxValue;
    MYKLineVC.shareMYKLineVC.plotIndex_minValue = minValue;
}

/// 计算MainPriceLabel的值
+ (void)setMainPriceValueWithView:(UIView *)view{
    for (int i = 0; i < 5; i++) {
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width + 2, 0, 100 * PHONE_WIDTH, 30 * PHONE_HEIGHT)];
        double high = view.frame.size.height / 4;
        priceLabel.frame = CGRectMake(priceLabel.frame.origin.x, high * i - 15 * PHONE_HEIGHT, priceLabel.frame.size.width, priceLabel.frame.size.height);
        
        priceLabel.font = [UIFont systemFontOfSize:20 * PHONE_WIDTH];
        priceLabel.text = [self getNumberWithDigits:[MYKLineVC shareMYKLineVC].digits Number:(MYKLineVC.shareMYKLineVC.mainIndex_maxValue - (MYKLineVC.shareMYKLineVC.mainIndex_maxValue - MYKLineVC.shareMYKLineVC.mainIndex_minValue) / 5 * i)];
        [view addSubview:priceLabel];
    }
}

/// 计算PlotPriceLabel的值
+ (void)setPlotPriceValueWithView:(UIView *)view {
    double maxValue = MYKLineVC.shareMYKLineVC.plotIndex_maxValue;
    double minValue = MYKLineVC.shareMYKLineVC.plotIndex_minValue;
    
    for (int i = 0; i < 3; i++) {
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width + 2, 0, 100 * PHONE_WIDTH, 30 * PHONE_HEIGHT)];
        double high = view.frame.size.height / 2;
//        priceLabel.centerY = high * i;
         priceLabel.frame = CGRectMake(priceLabel.frame.origin.x, high * i - 15 * PHONE_HEIGHT, priceLabel.frame.size.width, priceLabel.frame.size.height);
        priceLabel.font = [UIFont systemFontOfSize:20 * PHONE_WIDTH];
        if (i == 0) {
            priceLabel.text = [self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:maxValue];
        } else if (i == 1) {
            priceLabel.text = [self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:(maxValue - (maxValue - minValue) / 2)];
        } else {
            priceLabel.text = [self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:minValue];
        }
        [view addSubview:priceLabel];
    }
};

/// 获得宽度
+ (double)getWidthWith:(NSInteger)i
                  view:(UIView *)view{
    double width = 0;
    width = (view.frame.size.width - 10) / [MYKLineVC shareMYKLineVC].candleNum * (i - (MYKLineVC.shareMYKLineVC.lastDataCount - MYKLineVC.shareMYKLineVC.candleNum)) + (view.frame.size.width - 10) / [MYKLineVC shareMYKLineVC].candleNum / 2 + 5;
    return width;
}

/// 设置蜡烛图的Height
+ (void)setMainIndexHeightWithView:(UIView *)view
              indexName:(NSString *)indexName{
    for (NSInteger i = MYKLineVC.shareMYKLineVC.firstNum; i < MYKLineVC.shareMYKLineVC.lastNum; i++) {
        //获得数据
        MYKLineDataModel *model = MYKLineVC.shareMYKLineVC.KLineDataArray[i];
        //设置蜡烛图的高度
        model.Candle = nil;
        model.Candle = [[MY_Candle_Model alloc] init];
        model.Candle.height = [self priceTurnToY:[model.HighPrice doubleValue] maxValue:MYKLineVC.shareMYKLineVC.mainIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.mainIndex_minValue viewHeight:view.frame.size.height];
        model.Candle.low = [self priceTurnToY:[model.LowPrice doubleValue] maxValue:MYKLineVC.shareMYKLineVC.mainIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.mainIndex_minValue viewHeight:view.frame.size.height];
        model.Candle.open = [self priceTurnToY:[model.OpenPrice doubleValue] maxValue:MYKLineVC.shareMYKLineVC.mainIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.mainIndex_minValue viewHeight:view.frame.size.height];
        model.Candle.close = [self priceTurnToY:[model.ClosePrice doubleValue] maxValue:MYKLineVC.shareMYKLineVC.mainIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.mainIndex_minValue viewHeight:view.frame.size.height];
        model.Candle.width = [self getWidthWith:i view:view];
        
        if ([indexName isEqualToString:@"BBI"]) {
            //设置BBI的高度
            model.BBI.BBI_Height = [self priceTurnToY:model.BBI.BBI maxValue:MYKLineVC.shareMYKLineVC.mainIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.mainIndex_minValue viewHeight:view.frame.size.height];
            model.BBI.Width = [self getWidthWith:i view:view];
        } else if ([indexName isEqualToString:@"BOLL"]) {
            //设置BOLL的高度
            model.BOLL.MID_Height = [self priceTurnToY:model.BOLL.MID maxValue:MYKLineVC.shareMYKLineVC.mainIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.mainIndex_minValue viewHeight:view.frame.size.height];
            model.BOLL.UPPER_Height = [self priceTurnToY:model.BOLL.UPPER maxValue:MYKLineVC.shareMYKLineVC.mainIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.mainIndex_minValue viewHeight:view.frame.size.height];
            model.BOLL.LOWER_Height = [self priceTurnToY:model.BOLL.LOWER maxValue:MYKLineVC.shareMYKLineVC.mainIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.mainIndex_minValue viewHeight:view.frame.size.height];
            model.BOLL.Width = [self getWidthWith:i view:view];
        }else if ([indexName isEqualToString:@"MA"]) {
            model.MA.L1_Height = [self priceTurnToY:model.MA.L1 maxValue:MYKLineVC.shareMYKLineVC.mainIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.mainIndex_minValue viewHeight:view.frame.size.height];
            model.MA.L2_Height = [self priceTurnToY:model.MA.L2 maxValue:MYKLineVC.shareMYKLineVC.mainIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.mainIndex_minValue viewHeight:view.frame.size.height];
            model.MA.L3_Height = [self priceTurnToY:model.MA.L3 maxValue:MYKLineVC.shareMYKLineVC.mainIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.mainIndex_minValue viewHeight:view.frame.size.height];
            model.MA.L4_Height = [self priceTurnToY:model.MA.L4 maxValue:MYKLineVC.shareMYKLineVC.mainIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.mainIndex_minValue viewHeight:view.frame.size.height];
            model.MA.L5_Height = [self priceTurnToY:model.MA.L5 maxValue:MYKLineVC.shareMYKLineVC.mainIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.mainIndex_minValue viewHeight:view.frame.size.height];
            model.MA.Width = [self getWidthWith:i view:view];
        }else if ([indexName isEqualToString:@"MIKE"]) {
            model.MIKE.WR_Height = [self priceTurnToY:model.MIKE.WR maxValue:MYKLineVC.shareMYKLineVC.mainIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.mainIndex_minValue viewHeight:view.frame.size.height];
            model.MIKE.MR_Height = [self priceTurnToY:model.MIKE.MR maxValue:MYKLineVC.shareMYKLineVC.mainIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.mainIndex_minValue viewHeight:view.frame.size.height];
            model.MIKE.SR_Height = [self priceTurnToY:model.MIKE.SR maxValue:MYKLineVC.shareMYKLineVC.mainIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.mainIndex_minValue viewHeight:view.frame.size.height];
            model.MIKE.WS_Height = [self priceTurnToY:model.MIKE.WS maxValue:MYKLineVC.shareMYKLineVC.mainIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.mainIndex_minValue viewHeight:view.frame.size.height];
            model.MIKE.MS_Height = [self priceTurnToY:model.MIKE.MS maxValue:MYKLineVC.shareMYKLineVC.mainIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.mainIndex_minValue viewHeight:view.frame.size.height];
            model.MIKE.SS_Height = [self priceTurnToY:model.MIKE.SS maxValue:MYKLineVC.shareMYKLineVC.mainIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.mainIndex_minValue viewHeight:view.frame.size.height];
            model.MIKE.Width = [self getWidthWith:i view:view];
        }else if ([indexName isEqualToString:@"PBX"]) {
            model.PBX.PBX1_Height = [self priceTurnToY:model.PBX.PBX1 maxValue:MYKLineVC.shareMYKLineVC.mainIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.mainIndex_minValue viewHeight:view.frame.size.height];
            model.PBX.PBX2_Height = [self priceTurnToY:model.PBX.PBX2 maxValue:MYKLineVC.shareMYKLineVC.mainIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.mainIndex_minValue viewHeight:view.frame.size.height];
            model.PBX.PBX3_Height = [self priceTurnToY:model.PBX.PBX3 maxValue:MYKLineVC.shareMYKLineVC.mainIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.mainIndex_minValue viewHeight:view.frame.size.height];
            model.PBX.PBX4_Height = [self priceTurnToY:model.PBX.PBX4 maxValue:MYKLineVC.shareMYKLineVC.mainIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.mainIndex_minValue viewHeight:view.frame.size.height];
            model.PBX.PBX5_Height = [self priceTurnToY:model.PBX.PBX5 maxValue:MYKLineVC.shareMYKLineVC.mainIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.mainIndex_minValue viewHeight:view.frame.size.height];
            model.PBX.PBX6_Height = [self priceTurnToY:model.PBX.PBX6 maxValue:MYKLineVC.shareMYKLineVC.mainIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.mainIndex_minValue viewHeight:view.frame.size.height];
            model.PBX.Width = [self getWidthWith:i view:view];
        }
        
    }
};

/// 设置蜡烛图的Height
+ (void)setPlotIndexHeightWithView:(UIView *)view
                         indexName:(NSString *)indexName {
    for (NSInteger i = MYKLineVC.shareMYKLineVC.firstNum; i < MYKLineVC.shareMYKLineVC.lastNum; i++) {
        //获得数据
        MYKLineDataModel *model = MYKLineVC.shareMYKLineVC.KLineDataArray[i];
        if ([indexName isEqualToString:@"ARBR"]) {
            model.ARBR.AR_Height = [self priceTurnToY:model.ARBR.AR maxValue:MYKLineVC.shareMYKLineVC.plotIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.plotIndex_minValue viewHeight:view.frame.size.height];
            model.ARBR.BR_Height = [self priceTurnToY:model.ARBR.BR maxValue:MYKLineVC.shareMYKLineVC.plotIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.plotIndex_minValue viewHeight:view.frame.size.height];
            model.ARBR.Width = [self getWidthWith:i view:view];
        } else if ([indexName isEqualToString:@"ATR"]) {
            model.ATR.ATR_Height = [self priceTurnToY:model.ATR.ATR maxValue:MYKLineVC.shareMYKLineVC.plotIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.plotIndex_minValue viewHeight:view.frame.size.height];
            model.ATR.TR_Height = [self priceTurnToY:model.ATR.TR maxValue:MYKLineVC.shareMYKLineVC.plotIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.plotIndex_minValue viewHeight:view.frame.size.height];
            model.ATR.Width = [self getWidthWith:i view:view];
        } else if ([indexName isEqualToString:@"BIAS"]) {
            model.BIAS.BIAS1_Height = [self priceTurnToY:model.BIAS.BIAS1 maxValue:MYKLineVC.shareMYKLineVC.plotIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.plotIndex_minValue viewHeight:view.frame.size.height];
            model.BIAS.BIAS2_Height = [self priceTurnToY:model.BIAS.BIAS2 maxValue:MYKLineVC.shareMYKLineVC.plotIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.plotIndex_minValue viewHeight:view.frame.size.height];
            model.BIAS.BIAS3_Height = [self priceTurnToY:model.BIAS.BIAS3 maxValue:MYKLineVC.shareMYKLineVC.plotIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.plotIndex_minValue viewHeight:view.frame.size.height];
            model.BIAS.Width = [self getWidthWith:i view:view];
        } else if ([indexName isEqualToString:@"CCI"]) {
            model.CCI.CCI_Height = [self priceTurnToY:model.CCI.CCI maxValue:MYKLineVC.shareMYKLineVC.plotIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.plotIndex_minValue viewHeight:view.frame.size.height];
            model.CCI.Width = [self getWidthWith:i view:view];
        } else if ([indexName isEqualToString:@"DKBY"]) {
            model.DKBY.SELL_Height = [self priceTurnToY:model.DKBY.SELL maxValue:MYKLineVC.shareMYKLineVC.plotIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.plotIndex_minValue viewHeight:view.frame.size.height];
            model.DKBY.BUY_Height = [self priceTurnToY:model.DKBY.BUY maxValue:MYKLineVC.shareMYKLineVC.plotIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.plotIndex_minValue viewHeight:view.frame.size.height];
            model.DKBY.ENE1_Height = [self priceTurnToY:model.DKBY.ENE1 maxValue:MYKLineVC.shareMYKLineVC.plotIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.plotIndex_minValue viewHeight:view.frame.size.height];
            model.DKBY.ENE2_Height = [self priceTurnToY:model.DKBY.ENE2 maxValue:MYKLineVC.shareMYKLineVC.plotIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.plotIndex_minValue viewHeight:view.frame.size.height];
            model.DKBY.Width = [self getWidthWith:i view:view];
        } else if ([indexName isEqualToString:@"KD"]) {
            model.KD.K_Height = [self priceTurnToY:model.KD.K maxValue:MYKLineVC.shareMYKLineVC.plotIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.plotIndex_minValue viewHeight:view.frame.size.height];
            model.KD.D_Height = [self priceTurnToY:model.KD.D maxValue:MYKLineVC.shareMYKLineVC.plotIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.plotIndex_minValue viewHeight:view.frame.size.height];
            model.KD.Width = [self getWidthWith:i view:view];
        } else if ([indexName isEqualToString:@"KDJ"]) {
            model.KDJ.K_Height = [self priceTurnToY:model.KDJ.K maxValue:MYKLineVC.shareMYKLineVC.plotIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.plotIndex_minValue viewHeight:view.frame.size.height];
            model.KDJ.D_Height = [self priceTurnToY:model.KDJ.D maxValue:MYKLineVC.shareMYKLineVC.plotIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.plotIndex_minValue viewHeight:view.frame.size.height];
            model.KDJ.J_Height = [self priceTurnToY:model.KDJ.J maxValue:MYKLineVC.shareMYKLineVC.plotIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.plotIndex_minValue viewHeight:view.frame.size.height];
            model.KDJ.Width = [self getWidthWith:i view:view];
        } else if ([indexName isEqualToString:@"LW&R"]) {
            model.LWR.LWR1_Height = [self priceTurnToY:model.LWR.LWR1 maxValue:MYKLineVC.shareMYKLineVC.plotIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.plotIndex_minValue viewHeight:view.frame.size.height];
            model.LWR.LWR2_Height = [self priceTurnToY:model.LWR.LWR2 maxValue:MYKLineVC.shareMYKLineVC.plotIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.plotIndex_minValue viewHeight:view.frame.size.height];
            model.LWR.Width = [self getWidthWith:i view:view];
        } else if ([indexName isEqualToString:@"MACD"]) {
            model.MACD.DIF_Height = [self priceTurnToY:model.MACD.DIF maxValue:MYKLineVC.shareMYKLineVC.plotIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.plotIndex_minValue viewHeight:view.frame.size.height];
            model.MACD.DEA_Height = [self priceTurnToY:model.MACD.DEA maxValue:MYKLineVC.shareMYKLineVC.plotIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.plotIndex_minValue viewHeight:view.frame.size.height];
            model.MACD.M_Height = [self priceTurnToY:model.MACD.M maxValue:MYKLineVC.shareMYKLineVC.plotIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.plotIndex_minValue viewHeight:view.frame.size.height];
            model.MACD.Width = [self getWidthWith:i view:view];
        } else if ([indexName isEqualToString:@"QHLSR"]) {
            model.QHLSR.QHL5_Height= [self priceTurnToY:model.QHLSR.QHL5 maxValue:MYKLineVC.shareMYKLineVC.plotIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.plotIndex_minValue viewHeight:view.frame.size.height];
            model.QHLSR.QHL10_Height = [self priceTurnToY:model.QHLSR.QHL10 maxValue:MYKLineVC.shareMYKLineVC.plotIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.plotIndex_minValue viewHeight:view.frame.size.height];
            model.QHLSR.Width = [self getWidthWith:i view:view];
        } else if ([indexName isEqualToString:@"RSI"]) {
            model.RSI.RSI1_Height = [self priceTurnToY:model.RSI.RSI1 maxValue:MYKLineVC.shareMYKLineVC.plotIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.plotIndex_minValue viewHeight:view.frame.size.height];
            model.RSI.RSI2_Height = [self priceTurnToY:model.RSI.RSI2 maxValue:MYKLineVC.shareMYKLineVC.plotIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.plotIndex_minValue viewHeight:view.frame.size.height];
            model.RSI.RSI3_Height = [self priceTurnToY:model.RSI.RSI3 maxValue:MYKLineVC.shareMYKLineVC.plotIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.plotIndex_minValue viewHeight:view.frame.size.height];
            model.RSI.Width = [self getWidthWith:i view:view];
        } else if ([indexName isEqualToString:@"W&R"]) {
            model.WR.WR_Height = [self priceTurnToY:model.WR.WR maxValue:MYKLineVC.shareMYKLineVC.plotIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.plotIndex_minValue viewHeight:view.frame.size.height];
            model.WR.Width = [self getWidthWith:i view:view];
        }
    }
};

/// 画现价线
+ (void)drawCurrentPriceLine:(UIView *)view
                   dataArray:(NSMutableArray *)dataArray{
    if (MYKLineVC.shareMYKLineVC.hiddenCurrentPriceLine == NO) {
        if (MYKLineVC.shareMYKLineVC.lastNum == dataArray.count) {
            CAShapeLayer *pathLayer6 = [CAShapeLayer layer];
            pathLayer6.lineCap     = kCALineCapRound;
            pathLayer6.lineJoin    = kCALineJoinBevel;
            pathLayer6.fillColor   = [UIColor clearColor].CGColor;
            pathLayer6.strokeColor = INDEX2_CGCOLOR;
            UIBezierPath *path6 = [UIBezierPath bezierPath];
            [path6 setLineWidth:1.0];
            [path6 setLineCapStyle:kCGLineCapRound];
            [path6 setLineJoinStyle:kCGLineJoinRound];
            MYKLineDataModel *lastModel = dataArray[MYKLineVC.shareMYKLineVC.lastNum - 1];
            //画k线
            [path6 moveToPoint:CGPointMake(0, lastModel.Candle.close)];
            [path6 addLineToPoint:CGPointMake(view.frame.size.width, lastModel.Candle.close)];
            pathLayer6.lineDashPattern = @[@4, @2];//画虚线
            pathLayer6.path = path6.CGPath;
            [view.layer addSublayer:pathLayer6];
            //添加当前价格的label
            UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width + 2, 0, 100 * PHONE_WIDTH, 30 * PHONE_HEIGHT)];
            priceLabel.font = [UIFont systemFontOfSize:20 * PHONE_WIDTH];
//            priceLabel.centerY = lastModel.Candle.close;
            if (lastModel.Candle.close) {
                priceLabel.frame = CGRectMake(priceLabel.frame.origin.x, lastModel.Candle.close - 15 * PHONE_HEIGHT, priceLabel.frame.size.width, priceLabel.frame.size.height);
            }
            
            priceLabel.text = [MYKLineTool getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:[lastModel.ClosePrice doubleValue]];
            [view addSubview:priceLabel];
        }
    }
}

/// 画指标图
+ (void)drawIndexLine:(NSString *)indexName
                 view:(UIView *)view
            dataArray:(NSMutableArray *)dataArray{
    if ([indexName isEqualToString:@"BBI"]) {
        //获得point数组
        NSMutableArray *Ary1 = [NSMutableArray array];
        for (NSInteger i = MYKLineVC.shareMYKLineVC.firstNum; i < MYKLineVC.shareMYKLineVC.lastNum; i++) {
            //获得数据
            MYKLineDataModel *model = dataArray[i];
            CGPoint point1 = CGPointMake(model.BBI.Width, model.BBI.BBI_Height);
            NSValue *Value1 = [NSValue valueWithCGPoint:point1];
            [Ary1 addObject:Value1];
        }
        //绘制指标图
        UIColor *index1Color = INDEX1_COLOR;
        [self drawIndexLineChart:view pointArray:Ary1 lineColor:index1Color];
    } else if ([indexName isEqualToString:@"BOLL"]){
        //获得point数组
        NSMutableArray *Ary1 = [NSMutableArray array];
        NSMutableArray *Ary2 = [NSMutableArray array];
        NSMutableArray *Ary3 = [NSMutableArray array];
        for (NSInteger i = MYKLineVC.shareMYKLineVC.firstNum; i < MYKLineVC.shareMYKLineVC.lastNum; i++) {
            //获得数据
            MYKLineDataModel *model = dataArray[i];
            CGPoint point1 = CGPointMake(model.BOLL.Width, model.BOLL.MID_Height);
            NSValue *Value1 = [NSValue valueWithCGPoint:point1];
            [Ary1 addObject:Value1];
            CGPoint point2 = CGPointMake(model.BOLL.Width, model.BOLL.LOWER_Height);
            NSValue *Value2 = [NSValue valueWithCGPoint:point2];
            [Ary2 addObject:Value2];
            CGPoint point3 = CGPointMake(model.BOLL.Width, model.BOLL.UPPER_Height);
            NSValue *Value3 = [NSValue valueWithCGPoint:point3];
            [Ary3 addObject:Value3];
        }
        //绘制指标图
        UIColor *index1Color = INDEX1_COLOR;
        UIColor *index2Color = INDEX2_COLOR;
        UIColor *index3Color = INDEX3_COLOR;
        [self drawIndexLineChart:view pointArray:Ary1 lineColor:index1Color];
        [self drawIndexLineChart:view pointArray:Ary2 lineColor:index2Color];
        [self drawIndexLineChart:view pointArray:Ary3 lineColor:index3Color];
    } else if ([indexName isEqualToString:@"MA"]){
        //获得point数组
        NSMutableArray *L1Ary = [NSMutableArray array];
        NSMutableArray *L2Ary = [NSMutableArray array];
        NSMutableArray *L3Ary = [NSMutableArray array];
        NSMutableArray *L4Ary = [NSMutableArray array];
        NSMutableArray *L5Ary = [NSMutableArray array];
        for (NSInteger i = MYKLineVC.shareMYKLineVC.firstNum; i < MYKLineVC.shareMYKLineVC.lastNum; i++) {
            //获得数据
            MYKLineDataModel *model = dataArray[i];
            CGPoint WRpoint = CGPointMake(model.MA.Width, model.MA.L1_Height);
            NSValue *WR_Value = [NSValue valueWithCGPoint:WRpoint];
            [L1Ary addObject:WR_Value];
            
            CGPoint MRpoint = CGPointMake(model.MA.Width, model.MA.L2_Height);
            NSValue *MR_Value = [NSValue valueWithCGPoint:MRpoint];
            [L2Ary addObject:MR_Value];
            
            CGPoint SRpoint = CGPointMake(model.MA.Width, model.MA.L3_Height);
            NSValue *SR_Value = [NSValue valueWithCGPoint:SRpoint];
            [L3Ary addObject:SR_Value];
            
            CGPoint WSpoint = CGPointMake(model.MA.Width, model.MA.L4_Height);
            NSValue *WS_Value = [NSValue valueWithCGPoint:WSpoint];
            [L4Ary addObject:WS_Value];
            
            CGPoint MSpoint = CGPointMake(model.MA.Width, model.MA.L5_Height);
            NSValue *MS_Value = [NSValue valueWithCGPoint:MSpoint];
            [L5Ary addObject:MS_Value];
        }
        //绘制指标图
        UIColor *index1Color = INDEX1_COLOR;
        UIColor *index2Color = INDEX2_COLOR;
        UIColor *index3Color = INDEX3_COLOR;
        UIColor *index4Color = INDEX4_COLOR;
        UIColor *index5Color = INDEX5_COLOR;
        [self drawIndexLineChart:view pointArray:L1Ary lineColor:index1Color];
        [self drawIndexLineChart:view pointArray:L2Ary lineColor:index2Color];
        [self drawIndexLineChart:view pointArray:L3Ary lineColor:index3Color];
        [self drawIndexLineChart:view pointArray:L4Ary lineColor:index4Color];
        [self drawIndexLineChart:view pointArray:L5Ary lineColor:index5Color];
    }else if ([indexName isEqualToString:@"MIKE"]){
        //获得point数组
        NSMutableArray *WRPointAry = [NSMutableArray array];
        NSMutableArray *MRPointAry = [NSMutableArray array];
        NSMutableArray *SRPointAry = [NSMutableArray array];
        NSMutableArray *WSPointAry = [NSMutableArray array];
        NSMutableArray *MSPointAry = [NSMutableArray array];
        NSMutableArray *SSPointAry = [NSMutableArray array];
        NSMutableArray *L6Ary = [NSMutableArray array];
        for (NSInteger i = MYKLineVC.shareMYKLineVC.firstNum; i < MYKLineVC.shareMYKLineVC.lastNum; i++) {
            //获得数据
            MYKLineDataModel *model = dataArray[i];
            CGPoint WRpoint = CGPointMake(model.MIKE.Width, model.MIKE.WR_Height);
            NSValue *WR_Value = [NSValue valueWithCGPoint:WRpoint];
            [WRPointAry addObject:WR_Value];
            
            CGPoint MRpoint = CGPointMake(model.MIKE.Width, model.MIKE.MR_Height);
            NSValue *MR_Value = [NSValue valueWithCGPoint:MRpoint];
            [MRPointAry addObject:MR_Value];
            
            CGPoint SRpoint = CGPointMake(model.MIKE.Width, model.MIKE.SR_Height);
            NSValue *SR_Value = [NSValue valueWithCGPoint:SRpoint];
            [SRPointAry addObject:SR_Value];
            
            CGPoint WSpoint = CGPointMake(model.MIKE.Width, model.MIKE.WS_Height);
            NSValue *WS_Value = [NSValue valueWithCGPoint:WSpoint];
            [WSPointAry addObject:WS_Value];
            
            CGPoint MSpoint = CGPointMake(model.MIKE.Width, model.MIKE.MS_Height);
            NSValue *MS_Value = [NSValue valueWithCGPoint:MSpoint];
            [MSPointAry addObject:MS_Value];
            
            CGPoint SSpoint = CGPointMake(model.MIKE.Width, model.MIKE.SS_Height);
            NSValue *SS_Value = [NSValue valueWithCGPoint:SSpoint];
            [SSPointAry addObject:SS_Value];
            
            CGPoint point6 = CGPointMake(model.MIKE.Width, model.MIKE.SS_Height);
            NSValue *Value6= [NSValue valueWithCGPoint:point6];
            [L6Ary addObject:Value6];
        }
        //绘制指标图
        UIColor *index1Color = INDEX1_COLOR;
        UIColor *index2Color = INDEX2_COLOR;
        UIColor *index3Color = INDEX3_COLOR;
        UIColor *index4Color = INDEX4_COLOR;
        UIColor *index5Color = INDEX5_COLOR;
        UIColor *index6Color = INDEX6_COLOR;
        [self drawIndexLineChart:view pointArray:WRPointAry lineColor:index1Color];
        [self drawIndexLineChart:view pointArray:MRPointAry lineColor:index2Color];
        [self drawIndexLineChart:view pointArray:SRPointAry lineColor:index3Color];
        [self drawIndexLineChart:view pointArray:WSPointAry lineColor:index4Color];
        [self drawIndexLineChart:view pointArray:MSPointAry lineColor:index5Color];
        [self drawIndexLineChart:view pointArray:L6Ary lineColor:index6Color];
    }else if ([indexName isEqualToString:@"PBX"]){
        //获得point数组
        NSMutableArray *L1Ary = [NSMutableArray array];
        NSMutableArray *L2Ary = [NSMutableArray array];
        NSMutableArray *L3Ary = [NSMutableArray array];
        NSMutableArray *L4Ary = [NSMutableArray array];
        NSMutableArray *L5Ary = [NSMutableArray array];
        NSMutableArray *L6Ary = [NSMutableArray array];
        for (NSInteger i = MYKLineVC.shareMYKLineVC.firstNum; i < MYKLineVC.shareMYKLineVC.lastNum; i++) {
            //获得数据
            MYKLineDataModel *model = dataArray[i];
            CGPoint point1 = CGPointMake(model.PBX.Width, model.PBX.PBX1_Height);
            NSValue *Value1 = [NSValue valueWithCGPoint:point1];
            [L1Ary addObject:Value1];
            
            CGPoint point2 = CGPointMake(model.PBX.Width, model.PBX.PBX2_Height);
            NSValue *Value2 = [NSValue valueWithCGPoint:point2];
            [L2Ary addObject:Value2];
            
            CGPoint point3 = CGPointMake(model.PBX.Width, model.PBX.PBX3_Height);
            NSValue *Value3 = [NSValue valueWithCGPoint:point3];
            [L3Ary addObject:Value3];
            
            CGPoint point4 = CGPointMake(model.PBX.Width, model.PBX.PBX4_Height);
            NSValue *Value4 = [NSValue valueWithCGPoint:point4];
            [L4Ary addObject:Value4];
            
            CGPoint point5 = CGPointMake(model.PBX.Width, model.PBX.PBX5_Height);
            NSValue *Value5 = [NSValue valueWithCGPoint:point5];
            [L5Ary addObject:Value5];
            
            CGPoint point6 = CGPointMake(model.PBX.Width, model.PBX.PBX6_Height);
            NSValue *Value6= [NSValue valueWithCGPoint:point6];
            [L6Ary addObject:Value6];
        }
        //绘制指标图
        UIColor *index1Color = INDEX1_COLOR;
        UIColor *index2Color = INDEX2_COLOR;
        UIColor *index3Color = INDEX3_COLOR;
        UIColor *index4Color = INDEX4_COLOR;
        UIColor *index5Color = INDEX5_COLOR;
        UIColor *index6Color = INDEX6_COLOR;
        [self drawIndexLineChart:view pointArray:L1Ary lineColor:index1Color];
        [self drawIndexLineChart:view pointArray:L2Ary lineColor:index2Color];
        [self drawIndexLineChart:view pointArray:L3Ary lineColor:index3Color];
        [self drawIndexLineChart:view pointArray:L4Ary lineColor:index4Color];
        [self drawIndexLineChart:view pointArray:L5Ary lineColor:index5Color];
        [self drawIndexLineChart:view pointArray:L6Ary lineColor:index6Color];
    }else if ([indexName isEqualToString:@"ARBR"]){
        //获得point数组
        NSMutableArray *L1Ary = [NSMutableArray array];
        NSMutableArray *L2Ary = [NSMutableArray array];
        for (NSInteger i = MYKLineVC.shareMYKLineVC.firstNum; i < MYKLineVC.shareMYKLineVC.lastNum; i++) {
            //获得数据
            MYKLineDataModel *model = dataArray[i];
            CGPoint point1 = CGPointMake(model.ARBR.Width, model.ARBR.AR_Height);
            NSValue *Value1 = [NSValue valueWithCGPoint:point1];
            [L1Ary addObject:Value1];
            
            CGPoint point2 = CGPointMake(model.ARBR.Width, model.ARBR.BR_Height);
            NSValue *Value2 = [NSValue valueWithCGPoint:point2];
            [L2Ary addObject:Value2];

        }
        //绘制指标图
        UIColor *index1Color = INDEX1_COLOR;
        UIColor *index2Color = INDEX2_COLOR;
        [self drawIndexLineChart:view pointArray:L1Ary lineColor:index1Color];
        [self drawIndexLineChart:view pointArray:L2Ary lineColor:index2Color];
    }else if ([indexName isEqualToString:@"ATR"]){
        //获得point数组
        NSMutableArray *L1Ary = [NSMutableArray array];
        NSMutableArray *L2Ary = [NSMutableArray array];
        for (NSInteger i = MYKLineVC.shareMYKLineVC.firstNum; i < MYKLineVC.shareMYKLineVC.lastNum; i++) {
            //获得数据
            MYKLineDataModel *model = dataArray[i];
            CGPoint point1 = CGPointMake(model.ATR.Width, model.ATR.TR_Height);
            NSValue *Value1 = [NSValue valueWithCGPoint:point1];
            [L1Ary addObject:Value1];
            CGPoint point2 = CGPointMake(model.ATR.Width, model.ATR.ATR_Height);
            NSValue *Value2 = [NSValue valueWithCGPoint:point2];
            [L2Ary addObject:Value2];
        }
        //绘制指标图
        UIColor *index1Color = INDEX1_COLOR;
        UIColor *index2Color = INDEX2_COLOR;
        [self drawIndexLineChart:view pointArray:L1Ary lineColor:index1Color];
        [self drawIndexLineChart:view pointArray:L2Ary lineColor:index2Color];
    }else if ([indexName isEqualToString:@"BIAS"]){
        //获得point数组
        NSMutableArray *L1Ary = [NSMutableArray array];
        NSMutableArray *L2Ary = [NSMutableArray array];
        NSMutableArray *L3Ary = [NSMutableArray array];
        for (NSInteger i = MYKLineVC.shareMYKLineVC.firstNum; i < MYKLineVC.shareMYKLineVC.lastNum; i++) {
            //获得数据
            MYKLineDataModel *model = dataArray[i];
            CGPoint point1 = CGPointMake(model.BIAS.Width, model.BIAS.BIAS1_Height);
            NSValue *Value1 = [NSValue valueWithCGPoint:point1];
            [L1Ary addObject:Value1];
            CGPoint point2 = CGPointMake(model.BIAS.Width, model.BIAS.BIAS2_Height);
            NSValue *Value2 = [NSValue valueWithCGPoint:point2];
            [L2Ary addObject:Value2];
            CGPoint point3 = CGPointMake(model.BIAS.Width, model.BIAS.BIAS3_Height);
            NSValue *Value3 = [NSValue valueWithCGPoint:point3];
            [L3Ary addObject:Value3];
        }
        //绘制指标图
        UIColor *index1Color = INDEX1_COLOR;
        UIColor *index2Color = INDEX2_COLOR;
        UIColor *index3Color = INDEX3_COLOR;
        [self drawIndexLineChart:view pointArray:L1Ary lineColor:index1Color];
        [self drawIndexLineChart:view pointArray:L2Ary lineColor:index2Color];
        [self drawIndexLineChart:view pointArray:L3Ary lineColor:index3Color];
    }else if ([indexName isEqualToString:@"CCI"]){
        //获得point数组
        NSMutableArray *L1Ary = [NSMutableArray array];
        for (NSInteger i = MYKLineVC.shareMYKLineVC.firstNum; i < MYKLineVC.shareMYKLineVC.lastNum; i++) {
            //获得数据
            MYKLineDataModel *model = dataArray[i];
            CGPoint point1 = CGPointMake(model.CCI.Width, model.CCI.CCI_Height);
            NSValue *Value1 = [NSValue valueWithCGPoint:point1];
            [L1Ary addObject:Value1];
        }
        //绘制指标图
        UIColor *index1Color = INDEX1_COLOR;
        [self drawIndexLineChart:view pointArray:L1Ary lineColor:index1Color];
    }else if ([indexName isEqualToString:@"DKBY"]){
        //获得point数组
        NSMutableArray *L1Ary = [NSMutableArray array];
        NSMutableArray *L2Ary = [NSMutableArray array];
        for (NSInteger i = MYKLineVC.shareMYKLineVC.firstNum; i < MYKLineVC.shareMYKLineVC.lastNum; i++) {
            //获得数据
            MYKLineDataModel *model = dataArray[i];
            CGPoint point1 = CGPointMake(model.DKBY.Width, model.DKBY.ENE1_Height);
            NSValue *Value1 = [NSValue valueWithCGPoint:point1];
            [L1Ary addObject:Value1];
            
            CGPoint point2 = CGPointMake(model.DKBY.Width, model.DKBY.ENE2_Height);
            NSValue *Value2 = [NSValue valueWithCGPoint:point2];
            [L2Ary addObject:Value2];
        }
        //绘制指标图
        UIColor *index1Color = INDEX1_COLOR;
        UIColor *index2Color = INDEX2_COLOR;
        [self drawIndexLineChart:view pointArray:L1Ary lineColor:index1Color];
        [self drawIndexLineChart:view pointArray:L2Ary lineColor:index2Color];
        
    }else if ([indexName isEqualToString:@"KD"]){
        //获得point数组
        NSMutableArray *L1Ary = [NSMutableArray array];
        NSMutableArray *L2Ary = [NSMutableArray array];
        for (NSInteger i = MYKLineVC.shareMYKLineVC.firstNum; i < MYKLineVC.shareMYKLineVC.lastNum; i++) {
            //获得数据
            MYKLineDataModel *model = dataArray[i];
            CGPoint point1 = CGPointMake(model.KD.Width, model.KD.K_Height);
            NSValue *Value1 = [NSValue valueWithCGPoint:point1];
            [L1Ary addObject:Value1];
            
            CGPoint point2 = CGPointMake(model.KD.Width, model.KD.D_Height);
            NSValue *Value2 = [NSValue valueWithCGPoint:point2];
            [L2Ary addObject:Value2];
        }
        //绘制指标图
        UIColor *index1Color = INDEX1_COLOR;
        UIColor *index2Color = INDEX2_COLOR;
        [self drawIndexLineChart:view pointArray:L1Ary lineColor:index1Color];
        [self drawIndexLineChart:view pointArray:L2Ary lineColor:index2Color];
        
    }else if ([indexName isEqualToString:@"KDJ"]){
        //获得point数组
        NSMutableArray *L1Ary = [NSMutableArray array];
        NSMutableArray *L2Ary = [NSMutableArray array];
        NSMutableArray *L3Ary = [NSMutableArray array];
        for (NSInteger i = MYKLineVC.shareMYKLineVC.firstNum; i < MYKLineVC.shareMYKLineVC.lastNum; i++) {
            //获得数据
            MYKLineDataModel *model = dataArray[i];
            CGPoint point1 = CGPointMake(model.KDJ.Width, model.KDJ.K_Height);
            NSValue *Value1 = [NSValue valueWithCGPoint:point1];
            [L1Ary addObject:Value1];
            
            CGPoint point2 = CGPointMake(model.KDJ.Width, model.KDJ.D_Height);
            NSValue *Value2 = [NSValue valueWithCGPoint:point2];
            [L2Ary addObject:Value2];
            
            CGPoint point3 = CGPointMake(model.KDJ.Width, model.KDJ.J_Height);
            NSValue *Value3 = [NSValue valueWithCGPoint:point3];
            [L3Ary addObject:Value3];
        }
        //绘制指标图
        UIColor *index1Color = INDEX1_COLOR;
        UIColor *index2Color = INDEX2_COLOR;
        UIColor *index3Color = INDEX3_COLOR;
        [self drawIndexLineChart:view pointArray:L1Ary lineColor:index1Color];
        [self drawIndexLineChart:view pointArray:L2Ary lineColor:index2Color];
        [self drawIndexLineChart:view pointArray:L3Ary lineColor:index3Color];
    }else if ([indexName isEqualToString:@"LW&R"]){
        //获得point数组
        NSMutableArray *L1Ary = [NSMutableArray array];
        NSMutableArray *L2Ary = [NSMutableArray array];
        for (NSInteger i = MYKLineVC.shareMYKLineVC.firstNum; i < MYKLineVC.shareMYKLineVC.lastNum; i++) {
            //获得数据
            MYKLineDataModel *model = dataArray[i];
            CGPoint point1 = CGPointMake(model.LWR.Width, model.LWR.LWR1_Height);
            NSValue *Value1 = [NSValue valueWithCGPoint:point1];
            [L1Ary addObject:Value1];
            
            CGPoint point2 = CGPointMake(model.LWR.Width, model.LWR.LWR2_Height);
            NSValue *Value2 = [NSValue valueWithCGPoint:point2];
            [L2Ary addObject:Value2];
        }
        //绘制指标图
        UIColor *index1Color = INDEX1_COLOR;
        UIColor *index2Color = INDEX2_COLOR;
        [self drawIndexLineChart:view pointArray:L1Ary lineColor:index1Color];
        [self drawIndexLineChart:view pointArray:L2Ary lineColor:index2Color];
    }else if ([indexName isEqualToString:@"MACD"]){
        //获得point数组
        NSMutableArray *L1Ary = [NSMutableArray array];
        NSMutableArray *L2Ary = [NSMutableArray array];
        for (NSInteger i = MYKLineVC.shareMYKLineVC.firstNum; i < MYKLineVC.shareMYKLineVC.lastNum; i++) {
            //获得数据
            MYKLineDataModel *model = dataArray[i];
            CGPoint point1 = CGPointMake(model.MACD.Width, model.MACD.DIF_Height);
            NSValue *Value1 = [NSValue valueWithCGPoint:point1];
            [L1Ary addObject:Value1];
            
            CGPoint point2 = CGPointMake(model.MACD.Width, model.MACD.DEA_Height);
            NSValue *Value2 = [NSValue valueWithCGPoint:point2];
            [L2Ary addObject:Value2];
        }
        //绘制指标图
        UIColor *index1Color = INDEX1_COLOR;
        UIColor *index2Color = INDEX2_COLOR;
        [self drawIndexLineChart:view pointArray:L1Ary lineColor:index1Color];
        [self drawIndexLineChart:view pointArray:L2Ary lineColor:index2Color];
        // 画M
        CGFloat zeroHeight = [self priceTurnToY:0 maxValue:MYKLineVC.shareMYKLineVC.plotIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.plotIndex_minValue viewHeight:view.frame.size.height];
        for (NSInteger i = MYKLineVC.shareMYKLineVC.firstNum ; i < MYKLineVC.shareMYKLineVC.lastNum ; i++) {
            //获得数据
            MYKLineDataModel *model = dataArray[i];
            CAShapeLayer *pathLayer3 = [CAShapeLayer layer];
            pathLayer3.lineCap     = kCALineCapRound;
            pathLayer3.lineJoin    = kCALineJoinBevel;
            pathLayer3.fillColor   = [UIColor clearColor].CGColor;
            UIBezierPath *path3 = [UIBezierPath bezierPath];
            [path3 setLineWidth:1.0];
            [path3 setLineCapStyle:kCGLineCapRound];
            [path3 setLineJoinStyle:kCGLineJoinRound];
            
            [path3 moveToPoint:CGPointMake(model.MACD.Width, zeroHeight)];
            [path3 addLineToPoint:CGPointMake(model.MACD.Width, model.MACD.M_Height)];
            
            UIColor *lineColor;
            if (model.MACD.M > 0) {
                lineColor = MYKLineASK_COLOR;
            } else {
                lineColor = MYKLineBID_COLOR;
            }
            pathLayer3.strokeColor = lineColor.CGColor;
            pathLayer3.path = path3.CGPath;
            [view.layer addSublayer:pathLayer3];
        }
    }else if ([indexName isEqualToString:@"QHLSR"]){
        //获得point数组
        NSMutableArray *L1Ary = [NSMutableArray array];
        NSMutableArray *L2Ary = [NSMutableArray array];
        for (NSInteger i = MYKLineVC.shareMYKLineVC.firstNum; i < MYKLineVC.shareMYKLineVC.lastNum; i++) {
            //获得数据
            MYKLineDataModel *model = dataArray[i];
            CGPoint point1 = CGPointMake(model.QHLSR.Width, model.QHLSR.QHL5_Height);
            NSValue *Value1 = [NSValue valueWithCGPoint:point1];
            [L1Ary addObject:Value1];
            CGPoint point2 = CGPointMake(model.QHLSR.Width, model.QHLSR.QHL10_Height);
            NSValue *Value2 = [NSValue valueWithCGPoint:point2];
            [L2Ary addObject:Value2];
        }
        //绘制指标图
        UIColor *index1Color = INDEX1_COLOR;
        UIColor *index2Color = INDEX2_COLOR;
        [self drawIndexLineChart:view pointArray:L1Ary lineColor:index1Color];
        [self drawIndexLineChart:view pointArray:L2Ary lineColor:index2Color];
    }else if ([indexName isEqualToString:@"RSI"]){
        //获得point数组
        NSMutableArray *L1Ary = [NSMutableArray array];
        NSMutableArray *L2Ary = [NSMutableArray array];
        NSMutableArray *L3Ary = [NSMutableArray array];
        for (NSInteger i = MYKLineVC.shareMYKLineVC.firstNum; i < MYKLineVC.shareMYKLineVC.lastNum; i++) {
            //获得数据
            MYKLineDataModel *model = dataArray[i];
            CGPoint point1 = CGPointMake(model.RSI.Width, model.RSI.RSI1_Height);
            NSValue *Value1 = [NSValue valueWithCGPoint:point1];
            [L1Ary addObject:Value1];
            CGPoint point2 = CGPointMake(model.RSI.Width, model.RSI.RSI2_Height);
            NSValue *Value2 = [NSValue valueWithCGPoint:point2];
            [L2Ary addObject:Value2];
            CGPoint point3 = CGPointMake(model.RSI.Width, model.RSI.RSI3_Height);
            NSValue *Value3 = [NSValue valueWithCGPoint:point3];
            [L3Ary addObject:Value3];
        }
        //绘制指标图
        UIColor *index1Color = INDEX1_COLOR;
        UIColor *index2Color = INDEX2_COLOR;
        UIColor *index3Color = INDEX3_COLOR;
        [self drawIndexLineChart:view pointArray:L1Ary lineColor:index1Color];
        [self drawIndexLineChart:view pointArray:L2Ary lineColor:index2Color];
        [self drawIndexLineChart:view pointArray:L3Ary lineColor:index3Color];
    }else if ([indexName isEqualToString:@"W&R"]){
        //获得point数组
        NSMutableArray *L1Ary = [NSMutableArray array];
        for (NSInteger i = MYKLineVC.shareMYKLineVC.firstNum; i < MYKLineVC.shareMYKLineVC.lastNum; i++) {
            //获得数据
            MYKLineDataModel *model = dataArray[i];
            CGPoint point1 = CGPointMake(model.WR.Width, model.WR.WR_Height);
            NSValue *Value1 = [NSValue valueWithCGPoint:point1];
            [L1Ary addObject:Value1];
        }
        //绘制指标图
        UIColor *index1Color = INDEX1_COLOR;
        [self drawIndexLineChart:view pointArray:L1Ary lineColor:index1Color];
    }
}


/// 绘制指标折线图
+ (void)drawIndexLineChart:(UIView *)view
                pointArray:(NSMutableArray *)pointArray
                 lineColor:(UIColor *)lineColor{
    //创建CAShapeLayer
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.lineCap     = kCALineCapRound;
    pathLayer.lineJoin    = kCALineJoinBevel;
    pathLayer.fillColor   = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = lineColor.CGColor;
    //创建
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path setLineWidth:1.0];
    [path setLineCapStyle:kCGLineCapRound];
    [path setLineJoinStyle:kCGLineJoinRound];
    
    for (NSInteger i = 0; i < pointArray.count; i++) {
        //获得数据
        NSValue *point_Value = pointArray[i];
        CGPoint point = point_Value.CGPointValue;
        if (i == 0) {
            [path moveToPoint:CGPointMake(point.x, point.y)];
        } else {
             [path addLineToPoint:CGPointMake(point.x, point.y)];
        }
    }
    pathLayer.path = path.CGPath;
    [view.layer addSublayer:pathLayer];
}
@end
