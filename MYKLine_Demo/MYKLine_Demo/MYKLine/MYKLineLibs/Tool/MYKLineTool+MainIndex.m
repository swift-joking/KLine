//
//  MYKLineTool+MainIndex.m
//  XinShengInternational
//
//  Created by michelle on 2017/9/27.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import "MYKLineTool+MainIndex.h"

@implementation MYKLineTool (MainIndex)


/**
 画主指标图
 
 @param view 主指标view
 */
+ (void) dealMainIndexWithView:(UIView *)view{

    UIView *subView = [self removeAllSubView:view];
    //计算FirstNum和LastNum
    [MYKLineTool getFirstNumeLastNum:MYKLineVC.shareMYKLineVC.KLineDataArray];
    //计算指标
    [self mainIndexAlgorithm];
    //记录mainIndexView最大值和最小值
    [self setMainIndexMaxValueMinValue:[MYKLineVC shareMYKLineVC].mainIndexName];
    //计算PriceLabel的值
    [self setMainPriceValueWithView:subView];
    //计算高度
    [self setMainIndexHeightWithView:subView indexName:[MYKLineVC shareMYKLineVC].mainIndexName];
    // 画指标图
    [self drawIndexLine:[MYKLineVC shareMYKLineVC].mainIndexName view:subView dataArray:MYKLineVC.shareMYKLineVC.KLineDataArray];
    // 画主指标图数据（蜡烛图）
    [MYKLineTool drawMainIndexWithSubView:subView];
    // 画现价线
    [self drawCurrentPriceLine:subView dataArray:MYKLineVC.shareMYKLineVC.KLineDataArray];
    
}

#pragma mark - 计算主指标参数
/// 计算指标
+ (void)mainIndexAlgorithm {
    NSString *mainIndexName = [MYKLineVC shareMYKLineVC].mainIndexName;
    if ([mainIndexName isEqualToString:@"BBI"]) {
        [MYKLineTool dealBBI];
    } else if ([mainIndexName isEqualToString:@"BOLL"]) {
        [MYKLineTool dealBOLL];
    } else if ([mainIndexName isEqualToString:@"MA"]) {
        [MYKLineTool dealMA];
    } else if ([mainIndexName isEqualToString:@"MIKE"]) {
        [MYKLineTool dealMIKE];
    } else if ([mainIndexName isEqualToString:@"PBX"]) {
        [MYKLineTool dealPBX];
    }
}

/// BBI
+ (void)dealBBI{
    NSMutableArray *dataArray = MYKLineVC.shareMYKLineVC.KLineDataArray;
    // 获得参数数组
    NSMutableArray *indexArray = [MYKLineVC shareMYKLineVC].plotIndexAry[0];
    NSNumber *N1 = 0;
    NSNumber *N2 = 0;
    NSNumber *N3 = 0;
    NSNumber *N4 = 0;
    NSMutableDictionary *dic0 = indexArray[0][0];
    NSMutableDictionary *dic1 = indexArray[1][0];
    NSMutableDictionary *dic2 = indexArray[2][0];
    NSMutableDictionary *dic3 = indexArray[3][0];
    if ([dic0[@"newValue"] integerValue] != -1) {
        N1 = dic0[@"newValue"];
    } else {
        N1 = dic0[@"value"];
    }
    if ([dic1[@"newValue"] integerValue] != -1) {
        N2 = dic1[@"newValue"];
    } else {
        N2 = dic1[@"value"];
    }
    if ([dic2[@"newValue"] integerValue] != -1) {
        N3 = dic2[@"newValue"];
    } else {
        N3 = dic2[@"value"];
    }
    if ([dic3[@"newValue"] integerValue] != -1) {
        N4 = dic3[@"newValue"];
    } else {
        N4 = dic3[@"value"];
    }
    //计算BBI
    for (int i = 0; i < dataArray.count; i++) {
        //获得数据
        MYKLineDataModel *model = dataArray[i];
        //清空数据
        model.BBI = nil;
        model.BBI = [[MY_BBI_Model alloc] init];
        // 处理N1日收盘价之和 / N1
        double N1_value = [self getAveragePriceWithDataArray:dataArray currentDay:i aveDay:[N1 intValue]];
        // 处理N2日收盘价之和 / N2
        double N2_value = [self getAveragePriceWithDataArray:dataArray currentDay:i aveDay:[N2 intValue]];
        // 处理N3日收盘价之和 / N3
        double N3_value = [self getAveragePriceWithDataArray:dataArray currentDay:i aveDay:[N3 intValue]];
        // 处理N4日收盘价之和 / N4
        double N4_value = [self getAveragePriceWithDataArray:dataArray currentDay:i aveDay:[N4 intValue]];
        // 处理BBI数据
        model.BBI.BBI = (N1_value + N2_value + N3_value + N4_value) / 4;
    }
}

/// BOLL
+ (void)dealBOLL{
    NSMutableArray *dataArray = MYKLineVC.shareMYKLineVC.KLineDataArray;
    // 获得参数数组
    NSMutableArray *indexArray = [MYKLineVC shareMYKLineVC].plotIndexAry[1];
    NSNumber *N = 0;
    NSNumber *P = 0;
    NSMutableDictionary *dic0 = indexArray[0][0];
    NSMutableDictionary *dic1 = indexArray[1][0];
    if ([dic0[@"newValue"] integerValue] != -1) {
        N = dic0[@"newValue"];
    } else {
        N = dic0[@"value"];
    }
    if ([dic1[@"newValue"] integerValue] != -1) {
        P = dic1[@"newValue"];
    } else {
        P = dic1[@"value"];
    }
    //计算BOLL
    for (int i = 0; i < dataArray.count; i++) {
        //获得数据
        MYKLineDataModel *model = dataArray[i];
        //清空数据
        model.BOLL = nil;
        model.BOLL = [[MY_BOLL_Model alloc] init];
        // 计算MA
        double MA = [self getAveragePriceWithDataArray:dataArray currentDay:i aveDay:[N intValue]];
        // 计算MD
        double MD = 0;
        double sum = 0;
        int j = i - [N intValue] + 1;
        if (j < 0) {
            j = 0;
        }
        for (j ; j <= i; j++) {
            MYKLineDataModel *j_model = dataArray[j];
            sum +=  pow([j_model.ClosePrice doubleValue] - MA, 2);
        }
        MD = sqrt(sum / [N doubleValue]);
        // 计算MB
        double MB = [self getAveragePriceWithDataArray:dataArray currentDay:i aveDay:([N intValue] - 1)];
        // 计算UP
        double UP = MB + [P intValue] * MD;
        // 计算DN
        double DN = MB - [P intValue] * MD;
        //BOLL model 赋值
        model.BOLL.MID = MB;
        model.BOLL.UPPER = UP;
        model.BOLL.LOWER = DN;
    }
}

/// MA
+ (void)dealMA{
    NSMutableArray *dataArray = MYKLineVC.shareMYKLineVC.KLineDataArray;
    // 获得参数数组
    NSMutableArray *indexArray = [MYKLineVC shareMYKLineVC].plotIndexAry[2];
    NSNumber *L1 = 0;
    NSNumber *L2 = 0;
    NSNumber *L3 = 0;
    NSNumber *L4 = 0;
    NSNumber *L5 = 0;
    NSMutableDictionary *dic0 = indexArray[0][0];
    NSMutableDictionary *dic1 = indexArray[1][0];
    NSMutableDictionary *dic2 = indexArray[2][0];
    NSMutableDictionary *dic3 = indexArray[3][0];
    NSMutableDictionary *dic4 = indexArray[4][0];
    if ([dic0[@"newValue"] integerValue] != -1) {
        L1 = dic0[@"newValue"];
    } else {
        L1 = dic0[@"value"];
    }
    if ([dic1[@"newValue"] integerValue] != -1) {
        L2 = dic1[@"newValue"];
    } else {
        L2 = dic1[@"value"];
    }
    if ([dic2[@"newValue"] integerValue] != -1) {
        L3 = dic2[@"newValue"];
    } else {
        L3 = dic2[@"value"];
    }
    if ([dic3[@"newValue"] integerValue] != -1) {
        L4 = dic3[@"newValue"];
    } else {
        L4 = dic3[@"value"];
    }
    if ([dic4[@"newValue"] integerValue] != -1) {
        L5 = dic4[@"newValue"];
    } else {
        L5 = dic4[@"value"];
    }
    
    // 处理L1数据
    for (NSInteger i = MYKLineVC.shareMYKLineVC.firstNum ; i < MYKLineVC.shareMYKLineVC.lastNum ; i++) {
        //获得数据
        MYKLineDataModel *model = dataArray[i];
        //清空数据
        model.MA = nil;
        model.MA = [[MY_MA_Model alloc] init];
        // 处理L1数据
        NSInteger j = 0;
        for (j = i - [L1 integerValue] + 1; j <= i; j++) {
            MYKLineDataModel *last_model;
            if (j < dataArray.count) {
                last_model = dataArray[j];
            }
            model.MA.L1 += [last_model.ClosePrice doubleValue];
        }
        model.MA.L1 = model.MA.L1 / [L1 integerValue];
        // 处理L2数据
        for (j = i - [L2 integerValue] + 1; j <= i; j++) {
//            MYKLineDataModel *last_model = dataArray[j];
            MYKLineDataModel *last_model;
            if (j < dataArray.count) {
                last_model = dataArray[j];
            }
            model.MA.L2 += [last_model.ClosePrice doubleValue];
        }
        model.MA.L2 = model.MA.L2 / [L2 integerValue];
        // 处理L3数据
        for (j = i - [L3 integerValue] + 1 ; j <= i; j++) {
//            MYKLineDataModel *last_model = dataArray[j];
            MYKLineDataModel *last_model;
            if (j < dataArray.count) {
                last_model = dataArray[j];
            }
            model.MA.L3 += [last_model.ClosePrice doubleValue];
        }
        model.MA.L3 = model.MA.L3 / [L3 integerValue];
        // 处理L4数据
        for (j = i - [L4 integerValue] + 1 ; j <= i; j++) {
//            MYKLineDataModel *last_model = dataArray[j];
            MYKLineDataModel *last_model;
            if (j < dataArray.count) {
                last_model = dataArray[j];
            }
            model.MA.L4 += [last_model.ClosePrice doubleValue];
        }
        model.MA.L4 = model.MA.L4 / [L4 integerValue];
        // 处理L5数据
        for (j = i - [L5 integerValue] + 1 ; j <= i; j++) {
//            MYKLineDataModel *last_model = dataArray[j];
            MYKLineDataModel *last_model;
            if (j < dataArray.count) {
                last_model = dataArray[j];
            }
            model.MA.L5 += [last_model.ClosePrice doubleValue];
        }
        model.MA.L5 = model.MA.L5 / [L5 integerValue];
    }
}


/// MIKE
+ (void)dealMIKE{
    NSMutableArray *dataArray = MYKLineVC.shareMYKLineVC.KLineDataArray;
    // 获得参数数组
    NSMutableArray *indexArray = [MYKLineVC shareMYKLineVC].plotIndexAry[3];
    NSNumber *N = 0;
    NSMutableDictionary *dic0 = indexArray[0][0];
    if ([dic0[@"newValue"] integerValue] != -1) {
        N = dic0[@"newValue"];
    } else {
        N = dic0[@"value"];
    }
    //计算MIKE
    for (int i = 0; i < dataArray.count; i++) {
        // 获得model
        MYKLineDataModel *model = dataArray[i];
        model.MIKE = nil;
        model.MIKE = [[MY_MIKE_Model alloc] init];
        // 计算TYP
        double TYP = ([model.ClosePrice doubleValue] + [model.HighPrice doubleValue] + [model.LowPrice doubleValue]) / 3;
        // 计算HH  N日内的最高值
        // 计算LL  N日内的最低值
        double HH = 0;
        double LL = MAXFLOAT;
        int j = i - [N intValue] + 1;
        if (j < 0) {
            j = 0;
        }
        for (j ; j <= i; j++) {
            MYKLineDataModel *j_model = dataArray[j];
            HH = HH > [j_model.HighPrice doubleValue] ? HH : [j_model.HighPrice doubleValue];
            LL = LL < [j_model.LowPrice doubleValue] ? LL : [j_model.LowPrice doubleValue];
        }
        // 初级压力线 WEKR
        double WEKR = TYP + (TYP - LL);
        // 中级压力线 MIDR
        double MIDR = TYP + (HH - LL);
        // 强力压力线 STOR
        double STOR = 2 * HH - LL;
        // 初级支撑线 WEKS
        double WEKS = TYP - (HH - TYP);
        // 中级支撑线 MIDS
        double MIDS = TYP - (HH - LL);
        // 强力支撑线 STOS
        double STOS = 2 * LL - HH;
        // model赋值
        model.MIKE.WR = WEKR;
        model.MIKE.MR = MIDR;
        model.MIKE.SR = STOR;
        model.MIKE.WS = WEKS;
        model.MIKE.MS = MIDS;
        model.MIKE.SS = STOS;
    }
}


/// PBX
+ (void)dealPBX{
    NSMutableArray *dataArray = MYKLineVC.shareMYKLineVC.KLineDataArray;
    //计算PBX
    for (int i = 0; i < dataArray.count; i++) {
        // 获得model
        MYKLineDataModel *model = dataArray[i];
        model.PBX = nil;
        model.PBX = [[MY_PBX_Model alloc] init];
        double ema1 = 0;
        double ema2 = 0;
        double ema3 = 0;
        double ema4 = 0;
        double ema5 = 0;
        double ema6 = 0;
        if (i != 0) {
            MYKLineDataModel *yesterModel = dataArray[i - 1];
            ema1 = yesterModel.PBX.EMA1;
            ema2 = yesterModel.PBX.EMA2;
            ema3 = yesterModel.PBX.EMA3;
            ema4 = yesterModel.PBX.EMA4;
            ema5 = yesterModel.PBX.EMA5;
            ema6 = yesterModel.PBX.EMA6;
        }
        model.PBX.EMA1 = [self getEXPMAWithDataArray:dataArray currentDay:i aveDay:1 yesterEMA:ema1];
        model.PBX.EMA2 = [self getEXPMAWithDataArray:dataArray currentDay:i aveDay:2 yesterEMA:ema2];
        model.PBX.EMA3 = [self getEXPMAWithDataArray:dataArray currentDay:i aveDay:3 yesterEMA:ema3];
        model.PBX.EMA4 = [self getEXPMAWithDataArray:dataArray currentDay:i aveDay:4 yesterEMA:ema4];
        model.PBX.EMA5 = [self getEXPMAWithDataArray:dataArray currentDay:i aveDay:5 yesterEMA:ema5];
        model.PBX.EMA6 = [self getEXPMAWithDataArray:dataArray currentDay:i aveDay:6 yesterEMA:ema6];
        
        double PBX1 = (model.PBX.EMA1 + [self getAveragePriceWithDataArray:dataArray currentDay:i aveDay:2] + [self getAveragePriceWithDataArray:dataArray currentDay:i aveDay:4]) / 3;
        double PBX2 =  (model.PBX.EMA2 + [self getAveragePriceWithDataArray:dataArray currentDay:i aveDay:4] + [self getAveragePriceWithDataArray:dataArray currentDay:i aveDay:8]) / 3;
        double PBX3 =  (model.PBX.EMA3 + [self getAveragePriceWithDataArray:dataArray currentDay:i aveDay:6] + [self getAveragePriceWithDataArray:dataArray currentDay:i aveDay:12]) / 3;
        double PBX4 =  (model.PBX.EMA4 + [self getAveragePriceWithDataArray:dataArray currentDay:i aveDay:8] + [self getAveragePriceWithDataArray:dataArray currentDay:i aveDay:16]) / 3;
        double PBX5 =  (model.PBX.EMA5 + [self getAveragePriceWithDataArray:dataArray currentDay:i aveDay:10] + [self getAveragePriceWithDataArray:dataArray currentDay:i aveDay:20]) / 3;
        double PBX6 =  (model.PBX.EMA6 + [self getAveragePriceWithDataArray:dataArray currentDay:i aveDay:12] + [self getAveragePriceWithDataArray:dataArray currentDay:i aveDay:24]) / 3;
        
        model.PBX.PBX1 = PBX1;
        model.PBX.PBX2 = PBX2;
        model.PBX.PBX3 = PBX3;
        model.PBX.PBX4 = PBX4;
        model.PBX.PBX5 = PBX5;
        model.PBX.PBX6 = PBX6;
    }
}

#pragma mark - 画主指标蜡烛图
/// 画主指标蜡烛图
+ (void)drawMainIndexWithSubView:(UIView *)subView {
    NSMutableArray *dataArray = MYKLineVC.shareMYKLineVC.KLineDataArray;
    switch ([MYKLineVC shareMYKLineVC].candleType) {
        case 0:  //蜡烛图
        {
            for (NSInteger i = MYKLineVC.shareMYKLineVC.firstNum; i < MYKLineVC.shareMYKLineVC.lastNum; i++) {
                //获得数据
                MYKLineDataModel *model = dataArray[i];
                MY_Candle_Model *candleModel = model.Candle;
                [MYKLineTool drawCandelViewWith:candleModel subView:subView];
            }
        }
            break;
        case 1:  //棒形图
        {
            for (NSInteger i = MYKLineVC.shareMYKLineVC.firstNum; i < MYKLineVC.shareMYKLineVC.lastNum; i++) {
                //获得数据
                MYKLineDataModel *model = dataArray[i];
                MY_Candle_Model *candleModel = model.Candle;
                [MYKLineTool drawClavateViewWith:candleModel subView:subView];
            }
            
        }
            break;
        case 2:  //线形图
        {
            [MYKLineTool drawLinearViewWithSubView:subView];
        }
            break;
            
        default:
            break;
    }
}

/// 画蜡烛图
+ (void)drawCandelViewWith:(MY_Candle_Model *)candelModel
                      subView:(UIView *)subView {
    //画高线
    CAShapeLayer *pathLayer1 = [CAShapeLayer layer];
    pathLayer1.lineCap     = kCALineCapRound;
    pathLayer1.lineJoin    = kCALineJoinBevel;
    pathLayer1.fillColor   = [UIColor clearColor].CGColor;
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 setLineWidth:1.0];
    [path1 setLineCapStyle:kCGLineCapRound];
    [path1 setLineJoinStyle:kCGLineJoinRound];
    [path1 moveToPoint:CGPointMake(candelModel.width, candelModel.height)];
    [path1 addLineToPoint:CGPointMake(candelModel.width, candelModel.open < candelModel.close ? candelModel.open : candelModel.close)];
    //画低线
    CAShapeLayer *pathLayer2 = [CAShapeLayer layer];
    pathLayer2.lineCap     = kCALineCapRound;
    pathLayer2.lineJoin    = kCALineJoinBevel;
    pathLayer2.fillColor   = [UIColor clearColor].CGColor;
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 setLineWidth:1.0];
    [path2 setLineCapStyle:kCGLineCapRound];
    [path2 setLineJoinStyle:kCGLineJoinRound];
    [path2 moveToPoint:CGPointMake(candelModel.width, candelModel.low)];
    [path2 addLineToPoint:CGPointMake(candelModel.width, candelModel.open > candelModel.close ? candelModel.open : candelModel.close)];
    //画蜡烛
    CAShapeLayer *pathLayer3 = [CAShapeLayer layer];
    pathLayer3.lineCap     = kCALineCapRound;
    pathLayer3.lineJoin    = kCALineJoinBevel;
//    pathLayer3.fillColor   = [UIColor clearColor].CGColor;
    UIBezierPath *path3 = [UIBezierPath bezierPath];
    [path3 setLineWidth:1.0];
    [path3 setLineCapStyle:kCGLineCapRound];
    [path3 setLineJoinStyle:kCGLineJoinRound];
    double widths = 0.7 * (subView.frame.size.width - 5) / [MYKLineVC shareMYKLineVC].candleNum ;
    [path3 moveToPoint:CGPointMake(candelModel.width - widths / 2, candelModel.open < candelModel.close ? candelModel.open : candelModel.close)];
    [path3 addLineToPoint:CGPointMake(candelModel.width + widths / 2, candelModel.open < candelModel.close ? candelModel.open : candelModel.close)];
    [path3 addLineToPoint:CGPointMake(candelModel.width + widths / 2, candelModel.open > candelModel.close ? candelModel.open : candelModel.close)];
    [path3 addLineToPoint:CGPointMake(candelModel.width - widths / 2, candelModel.open > candelModel.close ? candelModel.open : candelModel.close)];
    [path3 addLineToPoint:CGPointMake(candelModel.width - widths / 2, candelModel.open < candelModel.close ? candelModel.open : candelModel.close)];
    //设置颜色
    UIColor *color;
    if (candelModel.open > candelModel.close) {
        color = MYKLineASK_COLOR;
    } else if (candelModel.open < candelModel.close) {
        color = MYKLineBID_COLOR;
    } else {
        color = INDEXGRAY_COLOR;
    }
    pathLayer1.strokeColor = color.CGColor;
    pathLayer2.strokeColor = color.CGColor;
    pathLayer3.strokeColor = color.CGColor;
    //设置空心
    if ([MYKLineVC shareMYKLineVC].candleIsEmpty == YES) {
        if (candelModel.open > candelModel.close) {  //如果是阳线
            pathLayer3.fillColor   = [UIColor whiteColor].CGColor;
        } else {          //如果是阴线
            pathLayer3.fillColor   = color.CGColor;
        }
    } else {
        pathLayer3.fillColor   = color.CGColor;
    }
    //添加view
    pathLayer1.path = path1.CGPath;
    pathLayer2.path = path2.CGPath;
    pathLayer3.path = path3.CGPath;
    [subView.layer addSublayer:pathLayer1];
    [subView.layer addSublayer:pathLayer2];
    [subView.layer addSublayer:pathLayer3];
    
}

// 画棒形图
+ (void)drawClavateViewWith:(MY_Candle_Model *)candelModel
                      subView:(UIView *)subView {
    double widths = 0.7 * (subView.frame.size.width - 5) / [MYKLineVC shareMYKLineVC].candleNum ;
    //画竖线
    CAShapeLayer *pathLayer1 = [CAShapeLayer layer];
    pathLayer1.lineCap     = kCALineCapRound;
    pathLayer1.lineJoin    = kCALineJoinBevel;
    pathLayer1.fillColor   = [UIColor clearColor].CGColor;
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 setLineWidth:1.0];
    [path1 setLineCapStyle:kCGLineCapRound];
    [path1 setLineJoinStyle:kCGLineJoinRound];
    [path1 moveToPoint:CGPointMake(candelModel.width, candelModel.height)];
    [path1 addLineToPoint:CGPointMake(candelModel.width, candelModel.low)];
    //画开盘价
    CAShapeLayer *pathLayer2 = [CAShapeLayer layer];
    pathLayer2.lineCap     = kCALineCapRound;
    pathLayer2.lineJoin    = kCALineJoinBevel;
    pathLayer2.fillColor   = [UIColor clearColor].CGColor;
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 setLineWidth:1.0];
    [path2 setLineCapStyle:kCGLineCapRound];
    [path2 setLineJoinStyle:kCGLineJoinRound];
    [path2 moveToPoint:CGPointMake(candelModel.width - widths / 2, candelModel.open)];
    [path2 addLineToPoint:CGPointMake(candelModel.width, candelModel.open)];
    //画收盘价
    CAShapeLayer *pathLayer3 = [CAShapeLayer layer];
    pathLayer3.lineCap     = kCALineCapRound;
    pathLayer3.lineJoin    = kCALineJoinBevel;
    pathLayer3.fillColor   = [UIColor clearColor].CGColor;
    UIBezierPath *path3 = [UIBezierPath bezierPath];
    [path3 setLineWidth:1.0];
    [path3 setLineCapStyle:kCGLineCapRound];
    [path3 setLineJoinStyle:kCGLineJoinRound];
    [path3 moveToPoint:CGPointMake(candelModel.width + widths / 2, candelModel.close)];
    [path3 addLineToPoint:CGPointMake(candelModel.width, candelModel.close)];
    //设置颜色
    UIColor *color;
    if (candelModel.open > candelModel.close) {
        color = MYKLineASK_COLOR;
    } else if (candelModel.open < candelModel.close) {
        color = MYKLineBID_COLOR;
    } else {
        color = INDEXGRAY_COLOR;
    }
    pathLayer1.strokeColor = color.CGColor;
    pathLayer2.strokeColor = color.CGColor;
    pathLayer3.strokeColor = color.CGColor;
    //添加view
    pathLayer1.path = path1.CGPath;
    pathLayer2.path = path2.CGPath;
    pathLayer3.path = path3.CGPath;
    [subView.layer addSublayer:pathLayer1];
    [subView.layer addSublayer:pathLayer2];
    [subView.layer addSublayer:pathLayer3];
}

// 画线形图

+ (void)drawLinearViewWithSubView:(UIView *)subView {
    NSMutableArray *dataArray = MYKLineVC.shareMYKLineVC.KLineDataArray;
    //画收盘价
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.lineCap     = kCALineCapRound;
    pathLayer.lineJoin    = kCALineJoinBevel;
    pathLayer.fillColor   = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = INDEXGRSY_CGCOLOR;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path setLineWidth:1.0];
    [path setLineCapStyle:kCGLineCapRound];
    [path setLineJoinStyle:kCGLineJoinRound];
    for (NSInteger i = MYKLineVC.shareMYKLineVC.firstNum; i < MYKLineVC.shareMYKLineVC.lastNum; i++) {
        MYKLineDataModel *model = dataArray[i];
        if (i == MYKLineVC.shareMYKLineVC.firstNum) {
            [path moveToPoint:CGPointMake(model.Candle.width, model.Candle.close)];
        } else {
            [path addLineToPoint:CGPointMake(model.Candle.width, model.Candle.close)];
        }
    }
    //添加view
    pathLayer.path = path.CGPath;
    [subView.layer addSublayer:pathLayer];
}


@end
