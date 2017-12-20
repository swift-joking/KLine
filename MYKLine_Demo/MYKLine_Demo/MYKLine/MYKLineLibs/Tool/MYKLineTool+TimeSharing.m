//
//  MYKLineTool+TimeSharing.m
//  XinShengInternational
//
//  Created by michelle on 2017/10/25.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import "MYKLineTool+TimeSharing.h"

@implementation MYKLineTool (TimeSharing)

/**
 画分时图背景线
 
 @param view 分时图背景view
 */
+ (void)drawTimeSharingBackgroundLineWithView:(UIView *)view{
    double height = view.frame.size.height;
    double width = view.frame.size.width;
    
    for (int i = 1; i < 6; i++) {
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        pathLayer.lineCap     = kCALineCapRound;
        pathLayer.lineJoin    = kCALineJoinBevel;
        pathLayer.fillColor   = [[UIColor blueColor] CGColor];
        [view.layer addSublayer:pathLayer];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineWidth = BACKLINE_WIDTH;
        [path setLineCapStyle:kCGLineCapRound];
        [path setLineJoinStyle:kCGLineJoinRound];
        [path moveToPoint:CGPointMake(0, height / 6 * i)];
        [path addLineToPoint:CGPointMake(width, height / 6 * i)];
        pathLayer.path = path.CGPath;
        pathLayer.strokeColor = BACKLINE_CGCOLOR;//设置线的颜色
    }
    //画纵线
    for (int i = 1; i < 4; i++) {
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        pathLayer.lineCap     = kCALineCapRound;
        pathLayer.lineJoin    = kCALineJoinBevel;
        pathLayer.fillColor   = [[UIColor blueColor] CGColor];
        [view.layer addSublayer:pathLayer];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineWidth = BACKLINE_WIDTH;
        [path setLineCapStyle:kCGLineCapRound];
        [path setLineJoinStyle:kCGLineJoinRound];
        [path moveToPoint:CGPointMake(width / 4 * i, 0)];
        [path addLineToPoint:CGPointMake(width / 4 * i, height)];
        pathLayer.path = path.CGPath;
        pathLayer.strokeColor = BACKLINE_CGCOLOR;//设置线的颜色
    }
}


/**
 画分时图k线
 
 @param view 分时图背景view
 */
+ (void)drawTimeSharingKLineWithView:(UIView *)view {
    //移除并创建子View
    UIView *subView = [self removeAllSubView:view];
    //计算MA
    [self dealTimeSharingMA];
    //计算最大和最小值
    [self dealTimeSharingMaxMinValue];
    //计算高度
    [self setTimeSharingHeightWithView:subView];
    //画closePrice图
    [self drawTimeSharingClosePriceWithView:subView];
    //画均价线
    [self drawTimeSharingMAWithView:subView];
    //创建PriceLabel
    [self createTimeSharingPriceLabelWithView:subView];
    //创建devLabel
    [self createTimeSharingDevLabelWithView:subView];
    //创建TimeLabel
    [self createTimeSharingTimeLabelWithView:subView];
}

// 计算MA
+ (void)dealTimeSharingMA {
    NSMutableArray *dataArray = MYKLineVC.shareMYKLineVC.KLineDataArray;
    for (int i = 0; i < dataArray.count; i++) {
        MYKLineDataModel *model = dataArray[i];
        model.timeSharing = nil;
        model.timeSharing = [[MY_Time_Model alloc] init];
        if (i == 0) {
            model.timeSharing.MA = [model.ClosePrice doubleValue];
        } else {
            double sum = 0;
            for (int j = 0; j <= i; j++) {
                MYKLineDataModel *j_model = dataArray[j];
                sum += [j_model.ClosePrice doubleValue];
            }
            sum = sum / (i + 1);
            model.timeSharing.MA = sum;
        }
        model.timeSharing.ClosePrice = [model.ClosePrice doubleValue];
    }
}

+ (void)dealTimeSharingMaxMinValue {
    NSMutableArray *dataArray = MYKLineVC.shareMYKLineVC.KLineDataArray;
    MYKLineDataModel *firstModel = dataArray.firstObject;
    double startValue = [firstModel.ClosePrice doubleValue];
    double maxValue = 0;
    double minValue = MAXFLOAT;
    for (MYKLineDataModel *model in dataArray) {
        maxValue = maxValue > model.timeSharing.ClosePrice ? maxValue : model.timeSharing.ClosePrice;
        maxValue = maxValue > model.timeSharing.MA ? maxValue : model.timeSharing.MA;
        minValue = minValue < model.timeSharing.ClosePrice ? minValue : model.timeSharing.ClosePrice;
        minValue = minValue < model.timeSharing.MA ? minValue : model.timeSharing.MA;
    }
    BOOL max_dev =  fabs(startValue - maxValue) > fabs(startValue - minValue) ? YES : NO;
    if (max_dev) {
        minValue = [firstModel.ClosePrice doubleValue] - fabs(startValue - maxValue);
    } else {
        maxValue = [firstModel.ClosePrice doubleValue] + fabs(startValue - minValue);
    }
    MYKLineVC.shareMYKLineVC.timeSharing_maxValue = maxValue;
    MYKLineVC.shareMYKLineVC.timeSharing_minValue = minValue;
}

+ (void)createTimeSharingPriceLabelWithView:(UIView *)subView {
    for (int i = 0; i < 7; i++) {
        UILabel *priceLabel = [[UILabel alloc ] initWithFrame:CGRectMake(0, 0, 50, 30)];
        priceLabel.font = [UIFont systemFontOfSize:20 * PHONE_WIDTH];
        if (i != 0) {
            priceLabel.frame = CGRectMake(0, subView.frame.size.height * i / 6 - priceLabel.frame.size.height, priceLabel.frame.size.width, priceLabel.frame.size.height);
        }
        double price = MYKLineVC.shareMYKLineVC.timeSharing_maxValue - (MYKLineVC.shareMYKLineVC.timeSharing_maxValue - MYKLineVC.shareMYKLineVC.timeSharing_minValue) * i / 6;
        priceLabel.text = [self getNumberWithDigits:MYKLineVC.shareMYKLineVC.digits Number:price];
        [subView addSubview:priceLabel];
    }
}

+ (void)createTimeSharingDevLabelWithView:(UIView *)subView {
    for (int i = 0; i < 7; i++) {
        UILabel *priceLabel = [[UILabel alloc ] initWithFrame:CGRectMake(subView.frame.size.width - 50, 0, 50, 30)];
        priceLabel.font = [UIFont systemFontOfSize:20 * PHONE_WIDTH];
        priceLabel.textAlignment = NSTextAlignmentRight;
        if (i != 0) {
            priceLabel.frame = CGRectMake(priceLabel.frame.origin.x, subView.frame.size.height * i / 6 - priceLabel.frame.size.height, priceLabel.frame.size.width, priceLabel.frame.size.height);
        }
        double dev = (MYKLineVC.shareMYKLineVC.timeSharing_maxValue - MYKLineVC.shareMYKLineVC.timeSharing_minValue) * (1 / 2 - i / 6);
        priceLabel.text = [NSString stringWithFormat:@"%.2f%%",dev];
        [subView addSubview:priceLabel];
    }
}

+ (void)createTimeSharingTimeLabelWithView:(UIView *)subView {
    for (int i = 0; i < 5; i++) {
        UILabel *timeLabel = [[UILabel alloc ] initWithFrame:CGRectMake(0, subView.frame.size.height, 50, 30)];
        timeLabel.font = [UIFont systemFontOfSize:20 * PHONE_WIDTH];
        if (i != 0) {
            if (i == 4) {
                timeLabel.frame = CGRectMake(subView.frame.size.width - timeLabel.frame.size.width, timeLabel.frame.origin.y , timeLabel.frame.size.width, timeLabel.frame.size.height);
                timeLabel.textAlignment = NSTextAlignmentRight;
            } else {
                
                timeLabel.frame = CGRectMake(subView.frame.size.width * i / 4 - 25, subView.frame.size.height, 50, 30);
                
                
                timeLabel.textAlignment = NSTextAlignmentCenter;
            }
        }
        timeLabel.text = @"--:--";
        [subView addSubview:timeLabel];
    }
}

+ (void)setTimeSharingHeightWithView:(UIView *)subView {
    NSMutableArray *dataArray = MYKLineVC.shareMYKLineVC.KLineDataArray;
    for (int i = 0; i < dataArray.count; i++) {
        MYKLineDataModel *model = dataArray[i];
        model.timeSharing.ClosePrice_Height = [self priceTurnToY:[model.ClosePrice doubleValue] maxValue:MYKLineVC.shareMYKLineVC.timeSharing_maxValue minValue:MYKLineVC.shareMYKLineVC.timeSharing_minValue viewHeight:subView.frame.size.height];
        model.timeSharing.Width = i * (subView.frame.size.width - 2) / 12 / 24 + 1;
        model.timeSharing.MA_Height = [self priceTurnToY:model.timeSharing.MA maxValue:MYKLineVC.shareMYKLineVC.timeSharing_maxValue minValue:MYKLineVC.shareMYKLineVC.timeSharing_minValue viewHeight:subView.frame.size.height];
    }
}


+ (void)drawTimeSharingClosePriceWithView:(UIView *)subView {
    NSMutableArray *dataArray = MYKLineVC.shareMYKLineVC.KLineDataArray;
    NSMutableArray *closePointAry = [NSMutableArray array];
    for (int i = 0; i < dataArray.count; i++) {
        MYKLineDataModel *model = dataArray[i];
        double closePrice_Height = model.timeSharing.ClosePrice_Height;
        double closePrice_Width = model.timeSharing.Width;
        if (i == 0) {
            CGPoint point1 = CGPointMake(closePrice_Width, subView.frame.size.height);
            NSValue *point1Value = [NSValue valueWithCGPoint:point1];
            [closePointAry addObject:point1Value];
            
            CGPoint point2 = CGPointMake(closePrice_Width, closePrice_Height);
            NSValue *point2Value = [NSValue valueWithCGPoint:point2];
            [closePointAry addObject:point2Value];
            
        } else if (i == dataArray.count - 1){
            CGPoint point1 = CGPointMake(closePrice_Width, closePrice_Height);
            NSValue *point1Value = [NSValue valueWithCGPoint:point1];
            [closePointAry addObject:point1Value];
            
            CGPoint point2 = CGPointMake(closePrice_Width, subView.frame.size.height);
            NSValue *point2Value = [NSValue valueWithCGPoint:point2];
            [closePointAry addObject:point2Value];
        } else {
            CGPoint point1 = CGPointMake(closePrice_Width, closePrice_Height);
            NSValue *point1Value = [NSValue valueWithCGPoint:point1];
            [closePointAry addObject:point1Value];
        }
    }
    //绘制指标图
    UIColor *index1Color = TIMESHARING_COLOR;
    UIColor *fillColor = TIMEFILL_COLOR;
    [self drawIndexLineChart:subView pointArray:closePointAry lineColor:index1Color fillColor:fillColor];
}

+ (void)drawIndexLineChart:(UIView *)view
                pointArray:(NSMutableArray *)pointArray
                 lineColor:(UIColor *)lineColor
                 fillColor:(UIColor *)fillColor{
    //创建CAShapeLayer
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.lineCap     = kCALineCapRound;
    pathLayer.lineJoin    = kCALineJoinBevel;
    pathLayer.fillColor   = fillColor.CGColor;
    pathLayer.strokeColor = lineColor.CGColor;
    //创建
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path setLineWidth:1.0];
    [path setLineCapStyle:kCGLineCapRound];
    [path setLineJoinStyle:kCGLineJoinRound];
    
    for (NSInteger i = 0; i < pointArray.count; i++) {
        //获得数据
        NSValue *point_Value = pointArray[i];
        CGPoint point = point_Value.CGPointValue;
        if (i == 0) {
            [path moveToPoint:CGPointMake(point.x, point.y)];
        } else {
            [path addLineToPoint:CGPointMake(point.x, point.y)];
        }
    }
    pathLayer.path = path.CGPath;
    [view.layer addSublayer:pathLayer];
}

+ (void)drawTimeSharingMAWithView:(UIView *)subView {
    NSMutableArray *dataArray = MYKLineVC.shareMYKLineVC.KLineDataArray;
    NSMutableArray *maPointAry = [NSMutableArray array];
    for (int i = 0; i < dataArray.count; i++) {
        MYKLineDataModel *model = dataArray[i];
        double ma_Height = model.timeSharing.MA_Height;
        double ma_Width =  model.timeSharing.Width;
        CGPoint point1 = CGPointMake(ma_Width, ma_Height);
        NSValue *point1Value = [NSValue valueWithCGPoint:point1];
        [maPointAry addObject:point1Value];
    }
    
    //绘制指标图
    UIColor *index2Color = INDEX2_COLOR;
    [self drawIndexLineChart:subView pointArray:maPointAry lineColor:index2Color];
}
@end
