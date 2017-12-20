//
//  MYPlotIndexView.h
//  XinShengInternational
//
//  Created by michelle on 2017/9/20.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYPlotIndexView : UIView

/**
 绘制副指标图k线
 */
- (void)drawKLineData;


/**
 绘制十字光标

 @param point 十字光标选中的point
 */
- (void)addCursorWithPoint:(CGPoint)point;


/**
 点击删除十字光标
 */
- (void)removeCursor;
@end
