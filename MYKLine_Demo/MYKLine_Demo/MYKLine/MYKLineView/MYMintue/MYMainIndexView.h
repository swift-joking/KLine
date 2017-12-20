//
//  MYIndexView.h
//  XinShengInternational
//
//  Created by michelle on 2017/9/20.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYMainIndexView : UIView


/**
 绘制主指标图k线
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


/**
 拖拽主指标绘制k线

 @param point 拖拽手势的point
 */
- (void)panMainIndexWithPoint:(CGPoint)point;


/**
 捏合绘制k线

 @param point 捏合手势的point
 */
- (void)pinchMainIndexWithPoint:(CGPoint)point;
@end
