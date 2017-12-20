//
//  TimeSharingVC.m
//  XinShengInternational
//
//  Created by michelle on 2017/9/6.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import "TimeSharingVC.h"
#import "TimeSharingView.h"
#import "MYKLineDataModel.h"

@interface TimeSharingVC () 

@property (nonatomic, retain) TimeSharingView *timeSharingView;  //分时图View
@property (nonatomic, assign) CGPoint point;                     //十字光标选中的point
@end

@implementation TimeSharingVC

#pragma mark ================== 懒加载 =================

/**
 分时图View

 @return 分时图View
 */
- (TimeSharingView *)timeSharingView {
    if (!_timeSharingView) {
        _timeSharingView = [[TimeSharingView alloc] initWithFrame:CGRectMake(20 * self.view.frame.size.width / 750, 10 * self.view.frame.size.height / 1334,  710 * self.view.frame.size.width / 750 , 910 * self.view.frame.size.height / 1334)];
        
        [self.view addSubview:_timeSharingView];
    }
    return _timeSharingView;
}

#pragma mark ================== viewDidLoad =================
- (void)viewDidLoad {
    [super viewDidLoad];
    [self timeSharingView];
    [self addLongPress];
}

/**
 绘制分时图
 */
- (void)dealWithData{
    [self.timeSharingView drawKLineData];
    // 刷新十字光标
    if (MYKLineVC.shareMYKLineVC.isCursor) {
        // 主指标图调用十字光标
        [self.timeSharingView addCursorWithPoint:self.point];
    }
};

#pragma mark ================== 十字光标 =================
/**
 长按手势
 */
- (void)addLongPress {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPress.minimumPressDuration = 0.3;
    [self.view addGestureRecognizer:longPress];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longGes {
    self.point = [longGes locationInView:self.timeSharingView];
    if (self.point.x >= 0 && self.point.y >= 0) {
        MYKLineVC.shareMYKLineVC.isCursor = YES;
        NSMutableArray *dataArray = MYKLineVC.shareMYKLineVC.KLineDataArray;
        MYKLineDataModel *lastModel = dataArray.lastObject;
        if (self.point.x > lastModel.timeSharing.Width) {
            self.point = CGPointMake(lastModel.timeSharing.Width, lastModel.timeSharing.ClosePrice_Height);
        } else {
            int num = 12 * 24 * self.point.x / (self.timeSharingView.frame.size.width - 2);
            MYKLineVC.shareMYKLineVC.CursorIndex = num;
            MYKLineDataModel *num_Model = dataArray[num];
            self.point = CGPointMake(num_Model.timeSharing.Width, num_Model.timeSharing.ClosePrice_Height);
            self.updatePriceLabel();
        }
        [self.timeSharingView addCursorWithPoint:self.point];
    }
}


/**
 点击

 @param tapGes 点击
 */
- (void)tapAction:(UITapGestureRecognizer *)tapGes {
    CGPoint point = [tapGes locationInView:self.timeSharingView];
    if (point.x >= 0 && point.y >= 0) {
        if (MYKLineVC.shareMYKLineVC.isCursor) {
            MYKLineVC.shareMYKLineVC.isCursor = NO;
            [self.timeSharingView removeCursor];
            self.updatePriceLabel();
        }
    }
}


@end
