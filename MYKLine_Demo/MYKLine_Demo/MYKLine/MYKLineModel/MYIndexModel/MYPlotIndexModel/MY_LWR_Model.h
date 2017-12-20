//
//  MY_LWR_Model.h
//  XinShengInternational
//
//  Created by michelle on 2017/9/27.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 威廉指标(LWR)是摆动指标中变化最快的指标之一，它的使用方法可以参照KD线指标的方法使用，但最好是使用它在顶部背离或低部背离所表达的技术含义，将威廉指标(LWR)背离所表达的技术含义与均线指标相结合、相验证进行使用，效果会更好一些。

 */
@interface MY_LWR_Model : NSObject

@property (nonatomic, assign) double LWR1;
@property (nonatomic, assign) double LWR2;

@property (nonatomic, assign) double LWR1_Height;
@property (nonatomic, assign) double LWR2_Height;

@property (nonatomic, assign) double Width;
@end
