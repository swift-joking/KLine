//
//  MYIndexView.m
//  XinShengInternational
//
//  Created by michelle on 2017/9/20.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import "MYMainIndexView.h"

@interface MYMainIndexView()
@property (nonatomic, retain) CAShapeLayer *cursorHorLayer;  //十字光标的水平Layer
@property (nonatomic, retain) UIBezierPath *cursorHorPath;   //十字光标的水平path
@property (nonatomic, retain) CAShapeLayer *cursorVerLayer;  //十字光标的垂直layer
@property (nonatomic, retain) UIBezierPath *cursorVerPath;   //十字光标的垂直path
@property (nonatomic, retain) UILabel *cursorLabel;          //十字光标价格label
@property (nonatomic, retain) UILabel *cursorTimeLabel;      //十字光标时间label
@property (nonatomic, retain) UILabel *firstTimeLabel;       //第一个k线时间label
@property (nonatomic, retain) UILabel *lastTimeLabel;        //最后一个k线时间label
@end

@implementation MYMainIndexView

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

- (UILabel *)cursorTimeLabel {
    if (!_cursorTimeLabel) {
        if (MYKLineVC.shareMYKLineVC.hiddenPlotIndex) {
            _cursorTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height, 300 * PHONE_WIDTH, 30 * PHONE_HEIGHT)];
        } else {
            _cursorTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height + 350 * PHONE_HEIGHT, 300 * PHONE_WIDTH, 30 * PHONE_HEIGHT)];
        }
        _cursorTimeLabel.text = @"Time";
        _cursorTimeLabel.textAlignment = NSTextAlignmentCenter;
        _cursorTimeLabel.font = [UIFont systemFontOfSize:20 * PHONE_WIDTH];
        [self addSubview:_cursorTimeLabel];
    }
    return _cursorTimeLabel;
}

- (UILabel *)firstTimeLabel {
    if (!_firstTimeLabel) {
        if (MYKLineVC.shareMYKLineVC.hiddenPlotIndex) {
            _firstTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height, 100 * PHONE_WIDTH, 30 * PHONE_HEIGHT)];
        } else {
            _firstTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height + 350 * PHONE_HEIGHT, 100 * PHONE_WIDTH, 30 * PHONE_HEIGHT)];
        }
        _firstTimeLabel.text = @"LastTime";
        _cursorTimeLabel.textAlignment = NSTextAlignmentRight;
        _firstTimeLabel.font = [UIFont systemFontOfSize:20 * PHONE_WIDTH];
    }
    return _firstTimeLabel;
}

- (UILabel *)lastTimeLabel {
    if (!_lastTimeLabel) {
        if (MYKLineVC.shareMYKLineVC.hiddenPlotIndex) {
            _lastTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 100 * PHONE_WIDTH, self.frame.size.height, 100 * PHONE_WIDTH, 30 * PHONE_HEIGHT)];
        } else {
            _lastTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 100 * PHONE_WIDTH, self.frame.size.height + 350 * PHONE_HEIGHT, 100 * PHONE_WIDTH, 30 * PHONE_HEIGHT)];
        }
        _lastTimeLabel.text = @"FirstTime";
        _lastTimeLabel.font = [UIFont systemFontOfSize:20 * PHONE_WIDTH];
    }
    return _lastTimeLabel;
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
    [MYKLineTool drawMainIndexBackgroundLineWithView:self];
}

#pragma mark - 接收刷新数据

/**
 绘制主指标图
 */
- (void)drawKLineData {
    [MYKLineTool dealMainIndexWithView:self];
    [self addTime:MYKLineVC.shareMYKLineVC.KLineDataArray];
}


/**
 添加时间label

 @param KLineDataArray k线数组
 */
- (void)addTime:(NSMutableArray *)KLineDataArray{
    MYKLineDataModel *firstModel = KLineDataArray[MYKLineVC.shareMYKLineVC.firstNum];
    MYKLineDataModel *lastModel = KLineDataArray[MYKLineVC.shareMYKLineVC.lastNum - 1];
    self.firstTimeLabel.text = [firstModel.PriceTime componentsSeparatedByString:@"T"][1];
    self.lastTimeLabel.text = [lastModel.PriceTime componentsSeparatedByString:@"T"][1];
    [self addSubview:self.firstTimeLabel];
    [self addSubview:self.lastTimeLabel];
}

#pragma mark ================== 手势 =================

/**
 画十字光标

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
    [self cursorTimeLabel];
    self.cursorTimeLabel.centerX = point.x;
    self.cursorTimeLabel.text = [MYKLineTool XTurnToPriceTime:point.x viewWidth:self.frame.size.width KLineDataArray:MYKLineVC.shareMYKLineVC.KLineDataArray];
    //画横线
    if (point.y < self.frame.size.height && point.y > 0) {//如果point的y小于view的height，才允许显示横线
        [self cursorHorLayer];
        [self cursorHorPath];
        [self cursorLabel];
        
        [self.cursorHorPath moveToPoint:CGPointMake(0, point.y)];
        [self.cursorHorPath addLineToPoint:CGPointMake(self.frame.size.width, point.y)];
        self.cursorLabel.centerY = point.y;
        CGFloat cursorLabelText = [MYKLineTool YTurnToPrice:point.y maxValue:MYKLineVC.shareMYKLineVC.mainIndex_maxValue minValue:MYKLineVC.shareMYKLineVC.mainIndex_minValue viewHeight:self.frame.size.height];
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
    if (_cursorTimeLabel) {
        [_cursorTimeLabel removeFromSuperview];
        _cursorTimeLabel = nil;
    }
}


/**
 拖拽

 @param point 拖拽手势point
 */
- (void)panMainIndexWithPoint:(CGPoint)point {
    //删除光标
    [self removeCursor];
}


/**
 捏合手势

 @param point 捏合手势point
 */
- (void)pinchMainIndexWithPoint:(CGPoint)point {
    //删除光标
    [self removeCursor];
    
}

@end
