//
//  MYKLineTool+PlotIndex.m
//  XinShengInternational
//
//  Created by michelle on 2017/9/27.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import "MYKLineTool+PlotIndex.h"

@implementation MYKLineTool (PlotIndex)

/**
 画副指标图
 
 @param view 副指标view
 */
+ (void) dealPlotIndexWithView:(UIView *)view {
    UIView *subView = [self removeAllSubView:view];
    //计算指标
    [self indexAlgorithm];
    //记录plotIndexView最大值和最小值
    [self setPlotIndexMaxValueMinValue:[MYKLineVC shareMYKLineVC].plotIndexName];
    //计算PlotPriceLabel的值
    [self setPlotPriceValueWithView:subView];
    //计算高度
    [self setPlotIndexHeightWithView:subView indexName:[MYKLineVC shareMYKLineVC].plotIndexName];
    // 画指标图
    [self drawIndexLine:[MYKLineVC shareMYKLineVC].plotIndexName view:subView dataArray:MYKLineVC.shareMYKLineVC.KLineDataArray];
}

#pragma mark - 计算副指标参数
/// 计算指标
+ (void)indexAlgorithm {
    NSString *plotIndexName = [MYKLineVC shareMYKLineVC].plotIndexName;
    if ([plotIndexName isEqualToString:@"ARBR"]) {
        [MYKLineTool dealARBR];
    } else if ([plotIndexName isEqualToString:@"ATR"]) {
        [MYKLineTool dealATR];
    } else if ([plotIndexName isEqualToString:@"BIAS"]) {
        [MYKLineTool dealBIAS];
    } else if ([plotIndexName isEqualToString:@"CCI"]) {
        [MYKLineTool dealCCI];
    } else if ([plotIndexName isEqualToString:@"DKBY"]) {
        [MYKLineTool dealDKBY];
    } else if ([plotIndexName isEqualToString:@"KD"]) {
        [MYKLineTool dealKD];
    } else if ([plotIndexName isEqualToString:@"KDJ"]) {
        [MYKLineTool dealKDJ];
    } else if ([plotIndexName isEqualToString:@"LW&R"]) {
        [MYKLineTool dealLWR];
    } else if ([plotIndexName isEqualToString:@"MACD"]) {
        [MYKLineTool dealMACD];
    } else if ([plotIndexName isEqualToString:@"QHLSR"]) {
        [MYKLineTool dealQHLSR];
    } else if ([plotIndexName isEqualToString:@"RSI"]) {
        [MYKLineTool dealRSI];
    } else if ([plotIndexName isEqualToString:@"W&R"]) {
        [MYKLineTool dealWR];
    }
}



/// ARBP
+ (void)dealARBR {
    NSMutableArray *dataArray = MYKLineVC.shareMYKLineVC.KLineDataArray;
    // 获得参数数组
    NSMutableArray *indexArray = [MYKLineVC shareMYKLineVC].plotIndexAry[5];
    NSInteger N = 0;
    NSMutableDictionary *dic0 = indexArray[0][0];
    if ([dic0[@"newValue"] integerValue] != -1) {
        N = [dic0[@"newValue"] integerValue];
    } else {
        N = [dic0[@"value"] integerValue];
    }
    // 计算ARBR指标
    double AR = 0;
    double BR = 0;
    for (int i = 0; i < dataArray.count; i++) {
        MYKLineDataModel *i_model = dataArray[i];
        i_model.ARBR = nil;
        i_model.ARBR = [[MY_ARBR_Model alloc] init];
        double H_O = 0;
        double O_L = 0;
        double H_PC = 0;
        double PC_L = 0; //PC:昨天之收盘价
        
        if (i < N - 1) {
            for (int j = 0; j <= i; j++) {
                MYKLineDataModel *j_model = dataArray[j];
                double H = [j_model.HighPrice doubleValue];  //当天之最高价
                double L = [j_model.LowPrice doubleValue];   //当天之最低价
                double O = [j_model.OpenPrice doubleValue];  //当天之开盘价
                double PC = [j_model.ClosePrice doubleValue];//昨天之收盘价
                if (j == 0) {
                    PC = 0;
                } else {
                    MYKLineDataModel *PC_model = dataArray[j - 1];
                    PC = [PC_model.ClosePrice doubleValue];
                }
                H_O += (H - O);
                O_L += (O - L);
                H_PC += (H - PC);
                PC_L+= (PC - L);
            }
            //计算AR
            AR = H_O * 100 / O_L;
            //计算BR
            BR = H_PC * 100 / PC_L;
            //赋值
            i_model.ARBR.AR = AR;
            i_model.ARBR.BR = BR;
        } else {
            for (int j = i - (int)N + 1; j <= i; j++) {
                MYKLineDataModel *j_model = dataArray[j];
                double H = [j_model.HighPrice doubleValue];  //当天之最高价
                double L = [j_model.LowPrice doubleValue];   //当天之最低价
                double O = [j_model.OpenPrice doubleValue];  //当天之开盘价
                double PC = [j_model.ClosePrice doubleValue];;   //昨天之收盘价
                if (j == 0) {
                    PC = 0;
                } else {
                    MYKLineDataModel *PC_model = dataArray[j - 1];
                    PC = [PC_model.ClosePrice doubleValue];
                }
                H_O += (H - O);
                O_L += (O - L);
                H_PC += (H - PC);
                PC_L+= (PC - L);
            }
            //计算AR
            AR = H_O * 100 / O_L;
            //计算BR
            BR = H_PC * 100 / PC_L;
            //赋值
            i_model.ARBR.AR = AR;
            i_model.ARBR.BR = BR;
        }
    }
}
/// ATR
+ (void)dealATR {
    NSMutableArray *dataArray = MYKLineVC.shareMYKLineVC.KLineDataArray;
    // 获得参数数组
    NSMutableArray *indexArray = [MYKLineVC shareMYKLineVC].plotIndexAry[6];
    NSInteger N = 0;
    NSMutableDictionary *dic0 = indexArray[0][0];
    if ([dic0[@"newValue"] integerValue] != -1) {
        N = [dic0[@"newValue"] integerValue];
    } else {
        N = [dic0[@"value"] integerValue];
    }
    // 计算ATR指标
    for (int i = 0; i < dataArray.count; i++) {
        MYKLineDataModel *i_model = dataArray[i];
        i_model.ATR = nil;
        i_model.ATR = [[MY_ATR_Model alloc] init];
        double HEIGH_LOW = 0;
        double ABS_REF_HIGH = 0;
        double ABS_REF_LOW = 0;
        if (i < N - 1) {
            HEIGH_LOW = [i_model.HighPrice doubleValue] - [i_model.LowPrice doubleValue];
            double REF_CLOSE = 0;
            if (i == 0) {
                REF_CLOSE = [i_model.ClosePrice doubleValue];
            } else {
                MYKLineDataModel *REF_model = dataArray[i - 1];
                REF_CLOSE = [REF_model.ClosePrice doubleValue];
            }
            ABS_REF_HIGH = fabs((REF_CLOSE - [i_model.HighPrice doubleValue]));
            ABS_REF_LOW = fabs((REF_CLOSE - [i_model.LowPrice doubleValue]));
        } else {
            HEIGH_LOW = [i_model.HighPrice doubleValue] - [i_model.LowPrice doubleValue];
            double REF_CLOSE = 0;
            if (i == 0) {
                REF_CLOSE = [i_model.ClosePrice doubleValue];
            } else {
                MYKLineDataModel *REF_model = dataArray[i - 1];
                REF_CLOSE = [REF_model.ClosePrice doubleValue];
            }
            ABS_REF_HIGH = fabs((REF_CLOSE - [i_model.HighPrice doubleValue]));
            ABS_REF_LOW = fabs((REF_CLOSE - [i_model.LowPrice doubleValue]));
        }
        i_model.ATR.TR = HEIGH_LOW > ABS_REF_HIGH ? HEIGH_LOW : ABS_REF_HIGH;
        i_model.ATR.TR = i_model.ATR.TR > ABS_REF_LOW ? i_model.ATR.TR : ABS_REF_LOW;
        //求MA
        double result = 0;
        if (i < N - 1) {
            for (int j = 0; j <= i; j++) {
                MYKLineDataModel *detailModel = dataArray[j];
                result += detailModel.ATR.TR;
            }
            result = result / (i + 1);
        } else {
            for (int j = i - (int)N + 1; j <= i; j++) {
                MYKLineDataModel *detailModel = dataArray[j];
                result += detailModel.ATR.TR;
            }
            result = result / N;
        }
        i_model.ATR.ATR = result;
    }
}
/// BIAS
+ (void)dealBIAS {
    NSMutableArray *dataArray = MYKLineVC.shareMYKLineVC.KLineDataArray;
    // 获得参数数组
    NSMutableArray *indexArray = [MYKLineVC shareMYKLineVC].plotIndexAry[7];
    int L1 = 0;
    int L2 = 0;
    int L3 = 0;
    NSMutableDictionary *dic0 = indexArray[0][0];
    NSMutableDictionary *dic1 = indexArray[1][0];
    NSMutableDictionary *dic2 = indexArray[2][0];
    if ([dic0[@"newValue"] integerValue] != -1) {
        L1 = [dic0[@"newValue"] intValue];
    } else {
        L1 = [dic0[@"value"] intValue];
    }
    if ([dic1[@"newValue"] integerValue] != -1) {
        L2 = [dic1[@"newValue"] intValue];
    } else {
        L2 = [dic1[@"value"] intValue];
    }
    if ([dic2[@"newValue"] integerValue] != -1) {
        L3 = [dic2[@"newValue"] intValue];
    } else {
        L3 = [dic2[@"value"] intValue];
    }
    // 计算BIAS指标
    for (int i = 0; i < dataArray.count; i++) {
        MYKLineDataModel *i_model = dataArray[i];
        i_model.BIAS = nil;
        i_model.BIAS = [[MY_BIAS_Model alloc] init];
        double ave_L1 = [self  getAveragePriceWithDataArray:dataArray currentDay:i aveDay:L1];
        double ave_L2 = [self  getAveragePriceWithDataArray:dataArray currentDay:i aveDay:L2];
        double ave_L3 = [self  getAveragePriceWithDataArray:dataArray currentDay:i aveDay:L3];
        i_model.BIAS.BIAS1 = ([i_model.ClosePrice doubleValue] - ave_L1) * 100 / ave_L1;
        i_model.BIAS.BIAS2 = ([i_model.ClosePrice doubleValue] - ave_L2) * 100 / ave_L2;
        i_model.BIAS.BIAS3 = ([i_model.ClosePrice doubleValue] - ave_L3) * 100 / ave_L3;
    }
}

/// CCI
+ (void)dealCCI {
    NSMutableArray *dataArray = MYKLineVC.shareMYKLineVC.KLineDataArray;
    // 获得参数数组
    NSMutableArray *indexArray = [MYKLineVC shareMYKLineVC].plotIndexAry[8];
    int N = 0;
    NSMutableDictionary *dic0 = indexArray[0][0];
    if ([dic0[@"newValue"] integerValue] != -1) {
        N = [dic0[@"newValue"] intValue];
    } else {
        N = [dic0[@"value"] intValue];
    }
    // 计算CCI指标
    for (int i = 0; i < dataArray.count; i++) {
        MYKLineDataModel *i_model = dataArray[i];
        i_model.CCI = nil;
        i_model.CCI= [[MY_CCI_Model alloc] init];
        double TP = 0;
        double MA = 0;
        double MD = 0;
        double CCI = 0;
        TP = ([i_model.ClosePrice doubleValue] + [i_model.HighPrice doubleValue] + [i_model.LowPrice doubleValue]) / 3;
        MA = [self getAveragePriceWithDataArray:dataArray currentDay:i aveDay:N];
        if (i < N - 1) {
       
            for (int j = 0; j <= i; j++) {
                MYKLineDataModel *detailModel = dataArray[j];
//                double ave_Close = [self getAveragePriceWithDataArray:dataArray currentDay:j aveDay:N];
                MD = MD + fabs(MA - [detailModel.ClosePrice doubleValue]);
            }
            MD = MD / (i + 1);
        } else {
          
            for (int j = i - N + 1; j <= i; j++) {
                MYKLineDataModel *detailModel = dataArray[j];
//                double ave_Close = [self getAveragePriceWithDataArray:dataArray currentDay:j aveDay:N];
                MD = MD + fabs(MA - [detailModel.ClosePrice doubleValue]);
            }
            MD = MD / N;
        }
        CCI = (TP - MA) / MD;
        CCI = CCI / 0.015;
        i_model.CCI.CCI = CCI;
    }
}

/// DKBY
+ (void)dealDKBY {
    NSMutableArray *dataArray = MYKLineVC.shareMYKLineVC.KLineDataArray;
    // 无参数
    // 计算DKBY指标
    for (int i = 0; i < dataArray.count; i++) {
        MYKLineDataModel *i_model = dataArray[i];
        i_model.DKBY = nil;
        i_model.DKBY= [[MY_DKBY_Model alloc] init];
        double HHV = [self HHV_dataArray:dataArray N:21 currentDay:i];
        double LLV = [self LLV_dataArray:dataArray N:21 currentDay:i];
        double var1 = 100 * (HHV - [i_model.ClosePrice doubleValue]) / (HHV - LLV) - 10;
        double var2 = 100 * ([i_model.ClosePrice doubleValue] - LLV) / (HHV - LLV);
        double var3 = 0;
        if (i == 0) {
            i_model.DKBY.SMA = [self SMA_X:var2 N:13 M:8 yes_Y:[i_model.ClosePrice doubleValue]];
        } else {
            MYKLineDataModel *yes_model = dataArray[i - 1];
            i_model.DKBY.SMA = [self SMA_X:var2 N:13 M:8 yes_Y:yes_model.DKBY.SMA];
        }
        
    }
}

/// KD
+ (void)dealKD {
    NSMutableArray *dataArray = MYKLineVC.shareMYKLineVC.KLineDataArray;
    // 获得参数数组
    NSMutableArray *indexArray = [MYKLineVC shareMYKLineVC].plotIndexAry[10];
    int N = 0;
    int M1 = 0;
    int M2 = 0;
    NSMutableDictionary *dic0 = indexArray[0][0];
    NSMutableDictionary *dic1 = indexArray[1][0];
    NSMutableDictionary *dic2 = indexArray[2][0];
    if ([dic0[@"newValue"] integerValue] != -1) {
        N = [dic0[@"newValue"] intValue];
    } else {
        N = [dic0[@"value"] intValue];
    }
    if ([dic1[@"newValue"] integerValue] != -1) {
        M1 = [dic1[@"newValue"] intValue];
    } else {
        M1 = [dic1[@"value"] intValue];
    }
    if ([dic2[@"newValue"] integerValue] != -1) {
        M2 = [dic2[@"newValue"] intValue];
    } else {
        M2 = [dic2[@"value"] intValue];
    }
    
    // 计算KD指标
    for (int i = 0; i < dataArray.count; i++) {
        MYKLineDataModel *i_model = dataArray[i];
        i_model.KD = nil;
        i_model.KD= [[MY_KD_Model alloc] init];
        double RSV = 0;
        double K = 0;
        double D = 0;
        double N_Low = MAXFLOAT; //N日最低价
        double N_High = 0;       //N日最高价
        if (i < N - 1) {
            for (int j = 0; j <= i ; j++) {
                MYKLineDataModel *j_model = dataArray[j];
                N_Low = N_Low < [j_model.LowPrice doubleValue] ? N_Low : [j_model.LowPrice doubleValue];
                N_Low = N_Low < [j_model.HighPrice doubleValue] ? N_Low : [j_model.HighPrice doubleValue];
                N_Low = N_Low < [j_model.OpenPrice doubleValue] ? N_Low : [j_model.OpenPrice doubleValue];
                N_Low = N_Low < [j_model.ClosePrice doubleValue] ? N_Low : [j_model.ClosePrice doubleValue];
                
                N_High = N_High > [j_model.HighPrice doubleValue] ? N_High : [j_model.HighPrice doubleValue];
                N_High = N_High > [j_model.LowPrice doubleValue] ? N_High : [j_model.LowPrice doubleValue];
                N_High = N_High > [j_model.OpenPrice doubleValue] ? N_High : [j_model.OpenPrice doubleValue];
                N_High = N_High > [j_model.ClosePrice doubleValue] ? N_High : [j_model.ClosePrice doubleValue];
            }
        } else {
            for (int j = i - N + 1; j <= i ; j++) {
                MYKLineDataModel *j_model = dataArray[j];
                N_Low = N_Low < [j_model.LowPrice doubleValue] ? N_Low : [j_model.LowPrice doubleValue];
                N_Low = N_Low < [j_model.HighPrice doubleValue] ? N_Low : [j_model.HighPrice doubleValue];
                N_Low = N_Low < [j_model.OpenPrice doubleValue] ? N_Low : [j_model.OpenPrice doubleValue];
                N_Low = N_Low < [j_model.ClosePrice doubleValue] ? N_Low : [j_model.ClosePrice doubleValue];
                
                N_High = N_High > [j_model.HighPrice doubleValue] ? N_High : [j_model.HighPrice doubleValue];
                N_High = N_High > [j_model.LowPrice doubleValue] ? N_High : [j_model.LowPrice doubleValue];
                N_High = N_High > [j_model.OpenPrice doubleValue] ? N_High : [j_model.OpenPrice doubleValue];
                N_High = N_High > [j_model.ClosePrice doubleValue] ? N_High : [j_model.ClosePrice doubleValue];
            }
        }
        RSV = ([i_model.ClosePrice doubleValue] - N_Low) * 100 / (N_High - N_Low);
        i_model.KD.RSV = RSV;
        //计算K

        if (i == 0) {
            K = (M1 - 1) * 50 / M1 + 1 * RSV / M1;
        } else {
            MYKLineDataModel *yes_Model = dataArray[i - 1];
            K = (M1 - 1) * yes_Model.KD.K / M1 +  1 * RSV / M1;
        }
        i_model.KD.K = K;
        //计算D
        if (i == 0) {
            D = (M2 - 1) * 50 / M2 + 1 * i_model.KD.K / M2;
        } else {
            MYKLineDataModel *yes_Model = dataArray[i - 1];
            D = (M2 - 1) * yes_Model.KD.D / M2 +  1 * i_model.KD.K / M2;
        }
        i_model.KD.D = D;
    }
}

/// KDJ
+ (void)dealKDJ{
    NSMutableArray *dataArray = MYKLineVC.shareMYKLineVC.KLineDataArray;
    // 获得参数数组
    NSMutableArray *indexArray = [MYKLineVC shareMYKLineVC].plotIndexAry[11];
    int N = 0;
    int M1 = 0;
    int M2 = 0;
    NSMutableDictionary *dic0 = indexArray[0][0];
    NSMutableDictionary *dic1 = indexArray[1][0];
    NSMutableDictionary *dic2 = indexArray[2][0];
    if ([dic0[@"newValue"] integerValue] != -1) {
        N = [dic0[@"newValue"] intValue];
    } else {
        N = [dic0[@"value"] intValue];
    }
    if ([dic1[@"newValue"] integerValue] != -1) {
        M1 = [dic1[@"newValue"] intValue];
    } else {
        M1 = [dic1[@"value"] intValue];
    }
    if ([dic2[@"newValue"] integerValue] != -1) {
        M2 = [dic2[@"newValue"] intValue];
    } else {
        M2 = [dic2[@"value"] intValue];
    }
    // 计算KDJ指标
    for (int i = 0; i < dataArray.count; i++) {
        MYKLineDataModel *i_model = dataArray[i];
        i_model.KDJ = nil;
        i_model.KDJ= [[MY_KDJ_Model alloc] init];
        double RSV = 0;
        double K = 0;
        double D = 0;
        double N_Low = MAXFLOAT; //N日最低价
        double N_High = 0;       //N日最高价
        if (i < N - 1) {
            for (int j = 0; j <= i ; j++) {
                MYKLineDataModel *j_model = dataArray[j];
                N_Low = N_Low < [j_model.LowPrice doubleValue] ? N_Low : [j_model.LowPrice doubleValue];
                N_Low = N_Low < [j_model.HighPrice doubleValue] ? N_Low : [j_model.HighPrice doubleValue];
                N_Low = N_Low < [j_model.OpenPrice doubleValue] ? N_Low : [j_model.OpenPrice doubleValue];
                N_Low = N_Low < [j_model.ClosePrice doubleValue] ? N_Low : [j_model.ClosePrice doubleValue];
                
                N_High = N_High > [j_model.HighPrice doubleValue] ? N_High : [j_model.HighPrice doubleValue];
                N_High = N_High > [j_model.LowPrice doubleValue] ? N_High : [j_model.LowPrice doubleValue];
                N_High = N_High > [j_model.OpenPrice doubleValue] ? N_High : [j_model.OpenPrice doubleValue];
                N_High = N_High > [j_model.ClosePrice doubleValue] ? N_High : [j_model.ClosePrice doubleValue];
            }
        } else {
            for (int j = i - N + 1; j <= i ; j++) {
                MYKLineDataModel *j_model = dataArray[j];
                N_Low = N_Low < [j_model.LowPrice doubleValue] ? N_Low : [j_model.LowPrice doubleValue];
                N_Low = N_Low < [j_model.HighPrice doubleValue] ? N_Low : [j_model.HighPrice doubleValue];
                N_Low = N_Low < [j_model.OpenPrice doubleValue] ? N_Low : [j_model.OpenPrice doubleValue];
                N_Low = N_Low < [j_model.ClosePrice doubleValue] ? N_Low : [j_model.ClosePrice doubleValue];
                
                N_High = N_High > [j_model.HighPrice doubleValue] ? N_High : [j_model.HighPrice doubleValue];
                N_High = N_High > [j_model.LowPrice doubleValue] ? N_High : [j_model.LowPrice doubleValue];
                N_High = N_High > [j_model.OpenPrice doubleValue] ? N_High : [j_model.OpenPrice doubleValue];
                N_High = N_High > [j_model.ClosePrice doubleValue] ? N_High : [j_model.ClosePrice doubleValue];
            }
        }
        RSV = ([i_model.ClosePrice doubleValue] - N_Low) * 100 / (N_High - N_Low);
        i_model.KDJ.RSV = RSV;
        //计算K
        
        if (i == 0) {
            K = (M1 - 1) * 50 / M1 + 1 * RSV / M1;
        } else {
            MYKLineDataModel *yes_Model = dataArray[i - 1];
            K = (M1 - 1) * yes_Model.KDJ.K / M1 +  1 * RSV / M1;
        }
        i_model.KDJ.K = K;
        //计算D
        if (i == 0) {
            D = (M2 - 1) * 50 / M2 + 1 * i_model.KDJ.K / M2;
        } else {
            MYKLineDataModel *yes_Model = dataArray[i - 1];
            D = (M2 - 1) * yes_Model.KDJ.D / M2 +  1 * i_model.KDJ.K / M2;
        }
        i_model.KDJ.D = D;
        //计算J
        i_model.KDJ.J = i_model.KDJ.K * 3 - 2 * i_model.KDJ.D;
    }
}

/// LW&R
+ (void)dealLWR {
    NSMutableArray *dataArray = MYKLineVC.shareMYKLineVC.KLineDataArray;
    // 获得参数数组
    NSMutableArray *indexArray = [MYKLineVC shareMYKLineVC].plotIndexAry[12];
    int N = 0;
    int M1 = 0;
    int M2 = 0;
    NSMutableDictionary *dic0 = indexArray[0][0];
    NSMutableDictionary *dic1 = indexArray[1][0];
    NSMutableDictionary *dic2 = indexArray[2][0];
    if ([dic0[@"newValue"] integerValue] != -1) {
        N = [dic0[@"newValue"] intValue];
    } else {
        N = [dic0[@"value"] intValue];
    }
    if ([dic1[@"newValue"] integerValue] != -1) {
        M1 = [dic1[@"newValue"] intValue];
    } else {
        M1 = [dic1[@"value"] intValue];
    }
    if ([dic2[@"newValue"] intValue] != -1) {
        M2 = [dic2[@"newValue"] intValue];
    } else {
        M2 = [dic2[@"value"] intValue];
    }
    //公式计算
    for (int i = 0; i < dataArray.count; i++) {
        //获得数据
        MYKLineDataModel *model = dataArray[i];
        //清空重置数据
        model.LWR = nil;
        model.LWR = [[MY_LWR_Model alloc] init];
        //处理数据
        double RSV = [self RSV_dataArray:dataArray N:N currentDay:i closePrice:[model.ClosePrice doubleValue]];
        if (i == 0) {
            model.LWR.LWR1 = [self SMA_X:RSV N:M1 M:1 yes_Y:[model.ClosePrice doubleValue]];
            model.LWR.LWR2 = [self SMA_X:model.LWR.LWR1 N:M2 M:1 yes_Y:[model.ClosePrice doubleValue]];
        } else {
            MYKLineDataModel *yes_model = dataArray[i - 1];
            model.LWR.LWR1 = [self SMA_X:RSV N:M1 M:1 yes_Y:yes_model.LWR.LWR1];
            model.LWR.LWR2 = [self SMA_X:model.LWR.LWR1 N:M2 M:1 yes_Y:yes_model.LWR.LWR2];
        }
    }
}

/// MACD
+ (void)dealMACD {
    NSMutableArray *dataArray = MYKLineVC.shareMYKLineVC.KLineDataArray;
    // 获得参数数组
    NSMutableArray *indexArray = [MYKLineVC shareMYKLineVC].plotIndexAry[13];
    NSInteger LONG = 0;
    NSInteger SHORT = 0;
    NSInteger M = 0;
    NSMutableDictionary *dic0 = indexArray[0][0];
    NSMutableDictionary *dic1 = indexArray[1][0];
    NSMutableDictionary *dic2 = indexArray[2][0];
    if ([dic0[@"newValue"] integerValue] != -1) {
        LONG = [dic0[@"newValue"] integerValue];
    } else {
        LONG = [dic0[@"value"] integerValue];
    }
    if ([dic1[@"newValue"] integerValue] != -1) {
        SHORT = [dic1[@"newValue"] integerValue];
    } else {
        SHORT = [dic1[@"value"] integerValue];
    }
    if ([dic2[@"newValue"] integerValue] != -1) {
        M = [dic2[@"newValue"] integerValue];
    } else {
        M = [dic2[@"value"] integerValue];
    }
    //公式计算
    for (int i = 0; i < dataArray.count; i++) {
        //获得数据
        MYKLineDataModel *model = dataArray[i];
        //清空重置数据
        model.MACD = nil;
        model.MACD = [[MY_MACD_Model alloc] init];
        //处理数据
        if (i == 0) {
            // 计算EMA
            model.MACD.EMA_LONG = [model.ClosePrice doubleValue];
            model.MACD.EMA_SHORT = [model.ClosePrice doubleValue];
            model.MACD.DEA = 0;
            // 计算DIF
            model.MACD.DIF = model.MACD.EMA_SHORT - model.MACD.EMA_LONG;
            // 计算M
            model.MACD.M = model.MACD.DIF - model.MACD.DEA;
        } else {
            MYKLineDataModel *firstModel = dataArray[i - 1];
            // 计算长日EMA
            model.MACD.EMA_LONG = (2 * [model.ClosePrice doubleValue] + (LONG - 1) * firstModel.MACD.EMA_LONG)/(LONG + 1);
            // 计算短日EMA
            model.MACD.EMA_SHORT = (2 * [model.ClosePrice doubleValue] + (SHORT - 1) * firstModel.MACD.EMA_SHORT)/(SHORT + 1);
            // 计算DIF
            model.MACD.DIF = model.MACD.EMA_SHORT - model.MACD.EMA_LONG;
            // 计算DEA
            model.MACD.DEA = firstModel.MACD.DEA * (M - 1)/(M + 1) + model.MACD.DIF * 2 / (M + 1);
            // 计算M
            model.MACD.M = 2 * (model.MACD.DIF - model.MACD.DEA);
        }
    }
}

/// QHLSR
+ (void)dealQHLSR {
    NSMutableArray *dataArray = MYKLineVC.shareMYKLineVC.KLineDataArray;
    // 无参数数组
    // 计算指标
    

}

/// RSI
+ (void)dealRSI {
    NSMutableArray *dataArray = MYKLineVC.shareMYKLineVC.KLineDataArray;
    // 获得参数数组
    NSMutableArray *indexArray = [MYKLineVC shareMYKLineVC].plotIndexAry[15];
    int N1 = 0;
    int N2 = 0;
    int N3 = 0;
    NSMutableDictionary *dic1 = indexArray[0][0];
    NSMutableDictionary *dic2 = indexArray[1][0];
    NSMutableDictionary *dic3 = indexArray[2][0];
    if ([dic1[@"newValue"] integerValue] != -1) {
        N1 = [dic1[@"newValue"] intValue];
    } else {
        N1 = [dic1[@"value"] intValue];
    }
    if ([dic2[@"newValue"] integerValue] != -1) {
        N2 = [dic2[@"newValue"] intValue];
    } else {
        N2 = [dic2[@"value"] intValue];
    }
    if ([dic3[@"newValue"] integerValue] != -1) {
        N3 = [dic3[@"newValue"] intValue];
    } else {
        N3 = [dic3[@"value"] intValue];
    }
    //公式计算
//    算法：
//    SMA(C,N,M) = (M*C+(N-M)*Y')/N
//    LC := REF(CLOSE,1);
//    RSI$1:SMA(MAX(CLOSE-LC,0),N1,1)/SMA(ABS(CLOSE-LC),N1,1)*100;
    for (int i = 0; i < dataArray.count; i++) {
        //获得数据
        MYKLineDataModel *i_model = dataArray[i];
        MYKLineDataModel *yes_model;
        if (i == 0) {
            yes_model = dataArray[i];
            yes_model.RSI.SMA1_A = [yes_model.ClosePrice doubleValue];
            yes_model.RSI.SMA1_B = [yes_model.ClosePrice doubleValue];
            yes_model.RSI.SMA2_A = [yes_model.ClosePrice doubleValue];
            yes_model.RSI.SMA2_B = [yes_model.ClosePrice doubleValue];
            yes_model.RSI.SMA3_A = [yes_model.ClosePrice doubleValue];
            yes_model.RSI.SMA3_B = [yes_model.ClosePrice doubleValue];
        } else {
            yes_model = dataArray[i - 1];
        }
        //清空重置数据
        i_model.RSI = nil;
        i_model.RSI = [[MY_RSI_Model alloc] init];
        
        double max = MAX(([i_model.ClosePrice doubleValue] - [yes_model.ClosePrice doubleValue]), 0);
        double abs = fabs([i_model.ClosePrice doubleValue] - [yes_model.ClosePrice doubleValue]);
        i_model.RSI.SMA1_A = (1 * max + (N1 - 1) * yes_model.RSI.SMA1_A) / N1;
        i_model.RSI.SMA1_B = (1 * abs + (N1 - 1) * yes_model.RSI.SMA1_B) / N1;
        i_model.RSI.RSI1 = i_model.RSI.SMA1_A * 100 / i_model.RSI.SMA1_B;
        
        i_model.RSI.SMA2_A = (1 * max + (N2 - 1) * yes_model.RSI.SMA2_A) / N2;
        i_model.RSI.SMA2_B = (1 * abs + (N2 - 1) * yes_model.RSI.SMA2_B) / N2;
        i_model.RSI.RSI2 = i_model.RSI.SMA2_A * 100 / i_model.RSI.SMA2_B;
        
        i_model.RSI.SMA3_A = (1 * max + (N3 - 1) * yes_model.RSI.SMA3_A) / N3;
        i_model.RSI.SMA3_B = (1 * abs + (N3 - 1) * yes_model.RSI.SMA3_B) / N3;
        i_model.RSI.RSI3 = i_model.RSI.SMA3_A * 100 / i_model.RSI.SMA3_B;
    }
}

/// W&R
+ (void)dealWR {
    NSMutableArray *dataArray = MYKLineVC.shareMYKLineVC.KLineDataArray;
    // 获得参数数组
    NSMutableArray *indexArray = [MYKLineVC shareMYKLineVC].plotIndexAry[16];
    int N = 0;
    NSMutableDictionary *dic0 = indexArray[0][0];
    if ([dic0[@"newValue"] integerValue] != -1) {
        N = [dic0[@"newValue"] intValue];
    } else {
        N = [dic0[@"value"] intValue];
    }
    //公式计算
    for (int i = 0; i < dataArray.count; i++) {
        //获得数据
        MYKLineDataModel *i_model = dataArray[i];
        //清空重置数据
        i_model.WR = nil;
        i_model.WR = [[MY_WR_Model alloc] init];
        double N_Low = MAXFLOAT;
        double N_High = 0;
        if (i < N - 1) {
            for (int j = 0; j <= i; j++) {
                MYKLineDataModel *j_model = dataArray[j];
                N_Low = N_Low < [j_model.OpenPrice doubleValue] ? N_Low : [j_model.OpenPrice doubleValue];
                N_Low = N_Low < [j_model.ClosePrice doubleValue] ? N_Low : [j_model.ClosePrice   doubleValue];
                N_Low = N_Low < [j_model.HighPrice doubleValue] ? N_Low : [j_model.HighPrice doubleValue];
                N_Low = N_Low < [j_model.LowPrice doubleValue] ? N_Low : [j_model.LowPrice doubleValue];
                
                N_High = N_High > [j_model.OpenPrice doubleValue] ? N_High : [j_model.OpenPrice doubleValue];
                N_High = N_High > [j_model.ClosePrice doubleValue] ? N_High : [j_model.ClosePrice   doubleValue];
                N_High = N_High > [j_model.HighPrice doubleValue] ? N_High : [j_model.HighPrice doubleValue];
                N_High = N_High > [j_model.LowPrice doubleValue] ? N_High : [j_model.LowPrice doubleValue];
            }
        } else {
            for (int j = i - N + 1; j <= i; j++) {
                MYKLineDataModel *j_model = dataArray[j];
                N_Low = N_Low < [j_model.OpenPrice doubleValue] ? N_Low : [j_model.OpenPrice doubleValue];
                N_Low = N_Low < [j_model.ClosePrice doubleValue] ? N_Low : [j_model.ClosePrice   doubleValue];
                N_Low = N_Low < [j_model.HighPrice doubleValue] ? N_Low : [j_model.HighPrice doubleValue];
                N_Low = N_Low < [j_model.LowPrice doubleValue] ? N_Low : [j_model.LowPrice doubleValue];
                
                N_High = N_High > [j_model.OpenPrice doubleValue] ? N_High : [j_model.OpenPrice doubleValue];
                N_High = N_High > [j_model.ClosePrice doubleValue] ? N_High : [j_model.ClosePrice   doubleValue];
                N_High = N_High > [j_model.HighPrice doubleValue] ? N_High : [j_model.HighPrice doubleValue];
                N_High = N_High > [j_model.LowPrice doubleValue] ? N_High : [j_model.LowPrice doubleValue];
            }
        }
        i_model.WR.WR = (N_High - [i_model.ClosePrice doubleValue]) * 100 / (N_High - N_Low);
    }
}
@end
