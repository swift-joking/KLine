//
//  TimeSharingView.h
//  XinShengInternational
//
//  Created by michelle on 2017/9/6.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYKLineDataModel;
@interface TimeSharingView : UIView


/**
 绘制分时图
 */
- (void)drawKLineData;


/**
 画十字光标

 @param point 十字光标的point
 */
- (void)addCursorWithPoint:(CGPoint)point;


/**
 删除十字光标
 */
- (void)removeCursor;
@end
