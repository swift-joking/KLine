//
//  TimeSharingView.m
//  XinShengInternational
//
//  Created by michelle on 2017/9/6.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import "TimeSharingView.h"
#import "MYKLineDataModel.h"

@interface TimeSharingView ()
@property (nonatomic, retain) CAShapeLayer *cursorHorLayer;    //十字光标水平Layer
@property (nonatomic, retain) UIBezierPath *cursorHorPath;     //十字光标水平path
@property (nonatomic, retain) CAShapeLayer *cursorVerLayer;    //十字光标垂直Layer
@property (nonatomic, retain) UIBezierPath *cursorVerPath;     //十字光标垂直path
@property (nonatomic, retain) UILabel *cursorLabel;            //十字光标价格label
@property (nonatomic, retain) UILabel *cursorTimeLabel;        //十字光标时间label
@end

@implementation TimeSharingView


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
        _cursorLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 100 * PHONE_WIDTH, 0, 100 * PHONE_WIDTH, 30 * PHONE_HEIGHT)];
        _cursorLabel.font = [UIFont systemFontOfSize:20 * PHONE_WIDTH];
        _cursorLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_cursorLabel];
    }
    return _cursorLabel;
}

- (UILabel *)cursorTimeLabel {
    if (!_cursorTimeLabel) {
        _cursorTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height, 300 * PHONE_WIDTH, 30 * PHONE_HEIGHT)];
        
        
        _cursorTimeLabel.text = @"Time";
        _cursorTimeLabel.textAlignment = NSTextAlignmentCenter;
        _cursorTimeLabel.font = [UIFont systemFontOfSize:20 * PHONE_WIDTH];
        [self addSubview:_cursorTimeLabel];
    }
    return _cursorTimeLabel;
}


#pragma mark ================== 加载视图 =================
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
    [MYKLineTool drawTimeSharingBackgroundLineWithView:self];
}


/**
 绘制分时图
 */
- (void)drawKLineData
{
    [MYKLineTool drawTimeSharingKLineWithView:self];
}


/**
 画十字光标
 
 @param point 十字光标的point
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
    NSMutableArray *dataArray = MYKLineVC.shareMYKLineVC.KLineDataArray;
    
    MYKLineDataModel *model = dataArray[MYKLineVC.shareMYKLineVC.CursorIndex];
    NSArray *ary = [model.PriceTime componentsSeparatedByString:@"T"];
    self.cursorTimeLabel.text = ary[1];
    //画横线
    if (point.y < self.frame.size.height && point.y > 0) {//如果point的y小于view的height，才允许显示横线
        [self cursorHorLayer];
        [self cursorHorPath];
        [self cursorLabel];
        
        [self.cursorHorPath moveToPoint:CGPointMake(0, point.y)];
        [self.cursorHorPath addLineToPoint:CGPointMake(self.frame.size.width, point.y)];
        self.cursorLabel.centerY = point.y;
        CGFloat cursorLabelText = [MYKLineTool YTurnToPrice:point.y maxValue:MYKLineVC.shareMYKLineVC.timeSharing_maxValue minValue:MYKLineVC.shareMYKLineVC.timeSharing_minValue viewHeight:self.frame.size.height];
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
@end
