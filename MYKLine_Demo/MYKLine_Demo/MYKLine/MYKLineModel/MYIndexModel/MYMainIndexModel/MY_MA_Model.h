//
//  MY_MA_Model.h
//  XinShengInternational
//
//  Created by michelle on 2017/9/27.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
 移动平均线，Moving Average，简称MA，原本的意思是移动平均，由于我们将其制作成线形，所以一般称之为移动平均线，简称均线。它是将某一段时间的收盘价之和除以该周期。 比如日线MA5指5天内的收盘价除以5 。
 */
@interface MY_MA_Model : NSObject
@property (nonatomic, assign) double L1;
@property (nonatomic, assign) double L2;
@property (nonatomic, assign) double L3;
@property (nonatomic, assign) double L4;
@property (nonatomic, assign) double L5;
@property (nonatomic, assign) double L1_Height;
@property (nonatomic, assign) double L2_Height;
@property (nonatomic, assign) double L3_Height;
@property (nonatomic, assign) double L4_Height;
@property (nonatomic, assign) double L5_Height;
@property (nonatomic, assign) double Width;
@end
