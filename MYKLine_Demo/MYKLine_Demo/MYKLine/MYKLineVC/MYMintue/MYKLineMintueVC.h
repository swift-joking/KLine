//
//  MYKLineMintueVC.h
//  XinShengInternational
//
//  Created by michelle on 2017/9/20.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYKLineMintueVC : UIViewController


//------------------ Block ------------------

/**
 隐藏或显示副指标图
 */
@property (nonatomic, copy) void (^hiddenPlotIndexAction)(BOOL hidden);


/**
 改变MYKLineVC的SegmentControl
 */
@property (nonatomic, copy)void(^changeSegCSelect)(NSInteger selectIndex);


/**
 刷新MYKLineVC的PriceLabel
 */
@property (nonatomic, copy) void (^updatePriceLabel)(void);

//------------------ 绘制更新k线分钟图 ------------------
/**
 绘制k线分钟图
 */
- (void)dealWithData;


/**
 更新k线分钟图
 */
- (void)updateKLineData;

@end
