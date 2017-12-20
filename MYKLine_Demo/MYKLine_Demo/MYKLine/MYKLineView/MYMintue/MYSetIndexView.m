//
//  MYSetIndexView.m
//  XinShengInternational
//
//  Created by michelle on 2017/9/25.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import "MYSetIndexView.h"

@implementation MYSetIndexView

/**
 根据当前k线谁显示指标参数详情
 
 @param index 指标名称
 */
- (void)detailLabel:(NSString *)index {
    NSString *resultStr = [NSString string];
    NSInteger num = 0;
    for (int i = 0; i < MYKLineVC.shareMYKLineVC.mainIndexAry.count; i++) {
        if ([index isEqualToString:MYKLineVC.shareMYKLineVC.mainIndexAry[i]]) {
            num = i;
            break;
        }
    }
    //获得指标参数字典
    NSArray *ary = MYKLineVC.shareMYKLineVC.plotIndexAry[num];
    NSDictionary *dic = [NSDictionary dictionary];
    if (ary.count) {
        for (int i = 0; i < ary.count; i++ ) {
            NSArray *array = ary[i];
            dic = array[0];
            if (i == 0) {
                resultStr = [NSMutableString stringWithFormat:@"(%ld",[dic[@"value"] integerValue]];
            } else {
                resultStr = [resultStr stringByAppendingString:[NSString stringWithFormat:@",%ld",[dic[@"value"] integerValue]]];
            }
        }
        resultStr = [resultStr stringByAppendingString:@")"];
    }
    //获得指标model参数
    MYKLineDataModel *myklineModel;
    if (MYKLineVC.shareMYKLineVC.isCursor) {
        myklineModel = MYKLineVC.shareMYKLineVC.KLineDataArray[MYKLineVC.shareMYKLineVC.CursorIndex];
    } else {
        myklineModel = MYKLineVC.shareMYKLineVC.KLineDataArray.lastObject;
    }
    
    if ([index isEqualToString:@"BBI"]) {
        resultStr = [resultStr stringByAppendingString:[NSString stringWithFormat:@"BBI:%@",[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.BBI.BBI]]];
    } else if ([index isEqualToString:@"BOLL"]) {
        resultStr = [resultStr stringByAppendingString:[NSString stringWithFormat:@"MID:%@ UPPER:%@ LOWER:%@",[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.BOLL.MID],[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.BOLL.UPPER],[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.BOLL.LOWER]]];
    } else if ([index isEqualToString:@"MA"]) {
        resultStr = [resultStr stringByAppendingString:[NSString stringWithFormat:@"MA1:%@ MA2:%@ MA3:%@ MA4:%@ MA5:%@",[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.MA.L1],[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.MA.L2],[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.MA.L3],[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.MA.L4],[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.MA.L5]]];
    } else if ([index isEqualToString:@"MIKE"]) {
        resultStr = [resultStr stringByAppendingString:[NSString stringWithFormat:@"WR:%@ MR:%@ WS:%@ MS:%@ SS:%@",[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.MIKE.WR],[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.MIKE.MR],[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.MIKE.WS],[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.MIKE.MS],[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.MIKE.SS]]];
    } else if ([index isEqualToString:@"PBX"]) {
        resultStr = [resultStr stringByAppendingString:[NSString stringWithFormat:@"PBX1:%@ PBX2:%@ PBX3:%@ PBX4:%@ PBX5:%@ PBX6:%@",[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.PBX.PBX1],[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.PBX.PBX2],[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.PBX.PBX3],[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.PBX.PBX4],[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.PBX.PBX5],[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.PBX.PBX6]]];
    } else if ([index isEqualToString:@"ARBR"]) {
        resultStr = [resultStr stringByAppendingString:[NSString stringWithFormat:@"AR:%@ BR:%@",[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.ARBR.AR],[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.ARBR.BR]]];
    } else if ([index isEqualToString:@"ATR"]) {
        resultStr = [resultStr stringByAppendingString:[NSString stringWithFormat:@"TR:%@ ATR:%@",[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.ATR.TR],[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.ATR.ATR]]];
    } else if ([index isEqualToString:@"BIAS"]) {
        resultStr = [resultStr stringByAppendingString:[NSString stringWithFormat:@"BIAS1:%@ BIAS2:%@ BIAS3:%@",[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.BIAS.BIAS1],[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.BIAS.BIAS2],[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.BIAS.BIAS3]]];
    } else if ([index isEqualToString:@"CCI"]) {
        resultStr = [resultStr stringByAppendingString:[NSString stringWithFormat:@"CCI:%@",[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.CCI.CCI]]];
    } else if ([index isEqualToString:@"DKBY"]) {
//        resultStr = [resultStr stringByAppendingString:[NSString stringWithFormat:@"BIAS1:%@ BIAS2:%@ BIAS3:%@",[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.BIAS.BIAS1],[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.BIAS.BIAS2],[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.BIAS.BIAS3]]];
    } else if ([index isEqualToString:@"KD"]) {
        resultStr = [resultStr stringByAppendingString:[NSString stringWithFormat:@"K:%@ D:%@",[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.KD.K],[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.KD.D]]];
    } else if ([index isEqualToString:@"KDJ"]) {
        resultStr = [resultStr stringByAppendingString:[NSString stringWithFormat:@"K:%@ D:%@ J:%@",[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.KDJ.K],[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.KDJ.D],[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.KDJ.J]]];
    } else if ([index isEqualToString:@"LW&R"]) {
        resultStr = [resultStr stringByAppendingString:[NSString stringWithFormat:@"LWR1:%@ LWR2:%@",[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.LWR.LWR1],[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.LWR.LWR2]]];
    } else if ([index isEqualToString:@"MACD"]) {
        resultStr = [resultStr stringByAppendingString:[NSString stringWithFormat:@"DIFF:%@ DEA:%@ MACD:%@",[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.MACD.DIF],[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.MACD.DEA],[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.MACD.M]]];
    } else if ([index isEqualToString:@"QHLSR"]) {
//        resultStr = [resultStr stringByAppendingString:[NSString stringWithFormat:@"DIFF:%@ DEA:%@ MACD:%@",[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.MACD.DIF],[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.MACD.DEA],[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.MACD.M]]];
    } else if ([index isEqualToString:@"RSI"]) {
        resultStr = [resultStr stringByAppendingString:[NSString stringWithFormat:@"RSI1:%@ RSI2:%@ RSI3:%@",[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.RSI.RSI1],[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.RSI.RSI2],[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.RSI.RSI3]]];
    } else if ([index isEqualToString:@"W&R"]) {
        resultStr = [resultStr stringByAppendingString:[NSString stringWithFormat:@"W&R:%@",[self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:myklineModel.WR.WR]]];
    }
    
    self.detailLabel.text = resultStr;
}


/**
 选择切换指标
 */
- (IBAction)setIndexAction:(id)sender {
    self.setIndexAction(self.IndexButton.titleLabel.text);
}


/**
 设置指标详情
 */
- (IBAction)setDetailAction:(id)sender {
    self.setDetailAction(self.IndexButton.titleLabel.text);
}

@end
