//
//  MYPlotIndexView.m
//  XinShengInternational
//
//  Created by michelle on 2017/9/20.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import "MYPlotIndexView.h"

@interface MYPlotIndexView()
@property (nonatomic, retain) CAShapeLayer *cursorHorLayer;   //十字光标的水平Layer
@property (nonatomic, retain) UIBezierPath *cursorHorPath;    //十字光标的水平path
@property (nonatomic, retain) CAShapeLayer *cursorVerLayer;   //十字光标的垂直layer
@property (nonatomic, retain) UIBezierPath *cursorVerPath;    //十字光标的垂直path
@property (nonatomic, retain) UILabel *cursorLabel;           //十字光标的价格label

@end

@implementation MYPlotIndexView

#pragma mark ================== 懒加载 =================
- (CAShapeLayer *)cursorHorLayer {
    if (!_cursorHorLayer) {
        _cursorHorLayer = [CAShapeLayer layer];
        _cursorHorLayer.lineCap     = kCALineCapRound;
        _cursorHorLayer.lineJoin    = kCALineJoinBevel;
        _cursorHorLayer.fillColor   = [[UIColor whiteColor] CGColor];
        _cursorHorLayer.strokeColor = [UIColor cyanColor].CGColor;//设置线
    }
    return _cursorHorLayer;
}

- (UIBezierPath *)cursorHorPath {
    if (!_cursorHorPath) {
        _cursorHorPath = [UIBezierPath bezierPath];
        _cursorHorPath.lineWidth = BACKLINE_WIDTH;
        [_cursorHorPath setLineCapStyle:kCGLineCapRound];
        [_cursorHorPath setLineJoinStyle:kCGLineJoinRound];
    }
    return _cursorHorPath;
}

- (CAShapeLayer *)cursorVerLayer {
    if (!_cursorVerLayer) {
        _cursorVerLayer = [CAShapeLayer layer];
        _cursorVerLayer.lineCap     = kCALineCapRound;
        _cursorVerLayer.lineJoin    = kCALineJoinBevel;
        _cursorVerLayer.fillColor   = [[UIColor whiteColor] CGColor];
        _cursorVerLayer.strokeColor = [UIColor cyanColor].CGColor;//设置线的颜色
    }
    return _cursorVerLayer;
}

- (UIBezierPath *)cursorVerPath {
    if (!_cursorVerPath) {
        _cursorVerPath = [UIBezierPath bezierPath];
        _cursorVerPath.lineWidth = BACKLINE_WIDTH;
        [_cursorVerPath setLineCapStyle:kCGLineCapRound];
        [_cursorVerPath setLineJoinStyle:kCGLineJoinRound];
    }
    return _cursorVerPath;
}

- (UILabel *)cursorLabel {
    if (!_cursorLabel) {
        _cursorLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width + 2, 0, 100 * PHONE_WIDTH, 30 * PHONE_HEIGHT)];
        _cursorLabel.font = [UIFont systemFontOfSize:20 * PHONE_WIDTH];
        [self addSubview:_cursorLabel];
    }
    return _cursorLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = BACKLINE_CGCOLOR;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    //画背景线和priceLabel
    [MYKLineTool drawPlotIndexBackgroundLineWithView:self];
}


#pragma mark ================== 绘制k线 =================


/**
 绘制主指标图
 */
- (void)drawKLineData {
    // 处理数据
    [MYKLineTool dealPlotIndexWithView:self];
}

#pragma mark ================== 十字光标 =================
/**
 绘制十字光标
 
 @param point 十字光标选中的point
 */
- (void)addCursorWithPoint:(CGPoint)point {
    //移除光标
    [self removeCursor];
    //画竖线
    [self cursorVerLayer];
    [self cursorVerPath];
    [self.cursorVerPath moveToPoint:CGPointMake(point.x, 0)];
    [self.cursorVerPath addLineToPoint:CGPointMake(point.x, self.frame.size.height)];
    //画横线
    if (point.y > 0 && point.y < self.frame.size.height) {//如果point大于0，才允许显示横线
        [self cursorHorLayer];
        [self cursorHorPath];
        [self.cursorHorPath moveToPoint:CGPointMake(0, point.y)];
        [self.cursorHorPath addLineToPoint:CGPointMake(self.frame.size.width, point.y)];
        [self cursorLabel];
        self.cursorLabel.centerY = point.y;
        CGFloat cursorLabelText = [MYKLineTool YTurnToPrice:point.y maxValue:MYKLineVC.shareMYKLineVC.plotIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.plotIndex_minValue viewHeight:self.frame.size.height];
        self.cursorLabel.text = [MYKLineTool getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:cursorLabelText];
    }
    //添加光标
    self.cursorHorLayer.path = self.cursorHorPath.CGPath;
    self.cursorVerLayer.path = self.cursorVerPath.CGPath;
    [self.layer addSublayer:self.cursorVerLayer];
    [self.layer addSublayer:self.cursorHorLayer];
}


/**
 删除十字光标
 */
- (void)removeCursor {
    //移除光标
    if (_cursorHorPath) {
        _cursorHorPath = nil;
    }
    if (_cursorVerPath) {
        _cursorVerPath = nil;
    }
    if (_cursorHorLayer) {
        [_cursorHorLayer removeFromSuperlayer];
        _cursorHorLayer = nil;
    }
    if (_cursorVerLayer) {
        [_cursorVerLayer removeFromSuperlayer];
        _cursorVerLayer = nil;
    }
    if (_cursorLabel) {
        [_cursorLabel removeFromSuperview];
        _cursorLabel = nil;
    }
}
@end
