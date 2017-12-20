//
//  MYKLineTool+Algorithm.h
//  XinShengInternational
//
//  Created by michelle on 2017/10/24.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import "MYKLineTool.h"

@interface MYKLineTool (Algorithm)


// HHV
+ (double)HHV_dataArray:(NSMutableArray *)dataArray
                      N:(int)N
             currentDay:(int)currentDay;

// LLV
+ (double)LLV_dataArray:(NSMutableArray *)dataArray
                      N:(int)N
             currentDay:(int)currentDay;

// RSV
+ (double)RSV_dataArray:(NSMutableArray *)dataArray
                      N:(int)N
             currentDay:(int)currentDay
             closePrice:(double)closePrice;

// SMA
+ (double)SMA_X:(double)X
              N:(double)N
              M:(double)M
          yes_Y:(double)yes_Y;

// MA
+ (double)MA_dataArray:(NSMutableArray *)dataArray
                     N:(int)N
            currentDay:(int)currentDay;

// EMA
+ (double)EMA_dataArray:(NSMutableArray *)dataArray
             currentDay:(int)currentDay
                      N:(int)N
                yes_EMA:(double)yes_EMA;
@end
