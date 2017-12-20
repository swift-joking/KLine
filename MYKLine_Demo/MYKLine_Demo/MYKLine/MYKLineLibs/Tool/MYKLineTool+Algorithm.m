//
//  MYKLineTool+Algorithm.m
//  XinShengInternational
//
//  Created by michelle on 2017/10/24.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import "MYKLineTool+Algorithm.h"

@implementation MYKLineTool (Algorithm)
// HHV
+ (double)HHV_dataArray:(NSMutableArray *)dataArray
                      N:(int)N
             currentDay:(int)currentDay{
    double result = 0;
    if (currentDay < N - 1) {
        for (int i = 0; i <= currentDay ; i++) {
            MYKLineDataModel *model = dataArray[i];
            result = result > [model.HighPrice doubleValue] ? result : [model.HighPrice doubleValue];
        }
    } else {
        for (int i = currentDay - N + 1; i <= currentDay ; i++) {
            MYKLineDataModel *model = dataArray[i];
            result = result > [model.HighPrice doubleValue] ? result : [model.HighPrice doubleValue];
        }
    }
    return result;
};

// LLV
+ (double)LLV_dataArray:(NSMutableArray *)dataArray
                      N:(int)N
             currentDay:(int)currentDay{
    double result = MAXFLOAT;
    if (currentDay < N - 1) {
        for (int i = 0; i <= currentDay ; i++) {
            MYKLineDataModel *model = dataArray[i];
            result = result < [model.LowPrice doubleValue] ? result : [model.LowPrice doubleValue];
        }
    } else {
        for (int i = currentDay - N + 1; i <= currentDay ; i++) {
            MYKLineDataModel *model = dataArray[i];
            result = result < [model.LowPrice doubleValue] ? result : [model.LowPrice doubleValue];
        }
    }
    return result;
};

// RSV
+ (double)RSV_dataArray:(NSMutableArray *)dataArray
                      N:(int)N
             currentDay:(int)currentDay
             closePrice:(double)closePrice{
    double HHV = [self HHV_dataArray:dataArray N:N currentDay:currentDay];
    double LLV = [self LLV_dataArray:dataArray N:N currentDay:currentDay];
    double RSV = 100 * (HHV - closePrice) / (HHV - LLV) - LLV;
    return RSV;
};

// SMA
+ (double)SMA_X:(double)X
              N:(double)N
              M:(double)M
          yes_Y:(double)yes_Y{
    double result = 0;
    if (N <= M) {
        return 0;
    }
    result = ((M * X) + (N - M) * yes_Y) / N;
    return result;
}

// MA
+ (double)MA_dataArray:(NSMutableArray *)dataArray
                     N:(int)N
            currentDay:(int)currentDay{
    double result = 0;
    if (currentDay < N - 1) {
        for (int j = 0; j <= currentDay; j++) {
            MYKLineDataModel *detailModel = dataArray[j];
            result += [detailModel.ClosePrice doubleValue];
        }
        result = result / (currentDay + 1);
    } else {
        for (int j = currentDay - N + 1; j <= currentDay; j++) {
            MYKLineDataModel *detailModel = dataArray[j];
            result += [detailModel.ClosePrice doubleValue];
        }
        result = result / N;
    }
    return result;
}

// EMA
+ (double)EMA_dataArray:(NSMutableArray *)dataArray
             currentDay:(int)currentDay
                      N:(int)N
                yes_EMA:(double)yes_EMA{
    
    double result = 0;
    MYKLineDataModel *model = dataArray[currentDay];
    if (currentDay == 0) {
        result = [model.ClosePrice doubleValue];
    } else {
        if (currentDay < N - 1) {
            result = 2 * [model.ClosePrice doubleValue] / (currentDay + 1 + 1) + (currentDay + 1 - 1) * yes_EMA / (currentDay + 1 + 1);
        } else {
            result = 2 * [model.ClosePrice doubleValue] / (N + 1) + (N - 1) * yes_EMA / (N + 1);
        }
    }
    return result;
}

@end
