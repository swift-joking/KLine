//
//  MYLandscapeVC.m
//  XinShengInternational
//
//  Created by michelle on 2017/10/18.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import "MYLandscapeVC.h"
#import "MYMainIndexView.h"
#import "MYPlotIndexView.h"
#import "MYSetIndexView.h"
#import "MYSetIndexVC.h"
#import "MYSelectIndexVC.h"

@interface MYLandscapeVC ()
@property (nonatomic, retain) MYMainIndexView *myMainIndexView;
@property (nonatomic, retain) MYPlotIndexView *myPlotIndexView;
@property (nonatomic, retain) MYSetIndexView *mySetMainIndew;
@property (nonatomic, retain) MYSetIndexView *mySetPlotIndew;
@property (nonatomic, assign) CGPoint beganPoint;
@property (nonatomic, assign) CGPoint movePoint;
@property (nonatomic, retain) MYSelectIndexVC *mySelectIndexVC;
@property (nonatomic, assign) CGPoint mainPoint;
@property (nonatomic, assign) CGPoint plotPoint;
@property (nonatomic, assign) CGPoint windowPoint;
@property (nonatomic, retain) UIButton *landscapeButton;
@end

@implementation MYLandscapeVC
- (UIButton *)landscapeButton {
    if (!_landscapeButton) {
        _landscapeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _landscapeButton.frame = CGRectMake(0, 0, 110 * SCREEN_HEIGHT / 750, 50 * SCREEN_HEIGHT / 750);
        [_landscapeButton setTitle:@"返回竖屏" forState:UIControlStateNormal];
        [_landscapeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_landscapeButton buttonWithFontSize:22 * SCREEN_HEIGHT / 750 ];
        [_landscapeButton setBackgroundColor:[UIColor grayColor]];
        [_landscapeButton addTarget:self action:@selector(lansdcapeAction)];
        [self.view addSubview:_landscapeButton];
    }
    return _landscapeButton;
}

/// 懒加载主指标View
- (MYMainIndexView *)myMainIndexView {
    if (!_myMainIndexView) {
        //创建头部
        if (!_mySetMainIndew) {
            NSArray *MYKLineViewArr = [[NSBundle mainBundle] loadNibNamed:@"MYKLine" owner:nil options:nil];
            _mySetMainIndew = MYKLineViewArr[0];
            [_mySetMainIndew.IndexButton setTitle:[MYKLineVC shareMYKLineVC].mainIndexName forState:UIControlStateNormal];
            [_mySetMainIndew detailLabel:[MYKLineVC shareMYKLineVC].mainIndexName];
            
            
            //            _mySetMainIndew.detailLabel.text = [NSString stringWithFormat:@""];
            _mySetMainIndew.frame = CGRectMake(10, 10 + self.topView.frame.size.height, 1220 * SCREEN_WIDTH / 1334, 50 * SCREEN_HEIGHT / 750);
            [self.view addSubview:_mySetMainIndew];
        }
        //创建主指标图
        if (MYKLineVC.shareMYKLineVC.hiddenPlotIndex) {
            _myMainIndexView = [[MYMainIndexView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_mySetMainIndew.frame), CGRectGetWidth(_mySetMainIndew.frame), 460 * SCREEN_HEIGHT / 750)];
            [self.view addSubview:_myMainIndexView];
            //创建横屏button
            self.landscapeButton.bottom = self.myMainIndexView.bottom;
            [self.view bringSubviewToFront:self.landscapeButton];
        } else {
            _myMainIndexView = [[MYMainIndexView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_mySetMainIndew.frame), CGRectGetWidth(_mySetMainIndew.frame), 240 * SCREEN_HEIGHT / 750)];
            [self.view addSubview:_myMainIndexView];
        }
        
        //block
        weakify(self);
        _mySetMainIndew.setIndexAction = ^(NSString *index) {
            [weakSelf mySelectIndexVC];
            
        };
        _mySetMainIndew.setDetailAction = ^(NSString *index) {
            MYSetIndexVC *mySetIndexVC = [[UIStoryboard storyboardWithName:@"MYKLine" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MYSetIndex_VC"];
            [mySetIndexVC setIndex:MYKLineVC.shareMYKLineVC.mainIndexName];
            [weakSelf.navigationController pushViewController:mySetIndexVC animated:YES];
        };
    }
    return _myMainIndexView;
}

/// 懒加载副指标View
- (MYPlotIndexView *)myPlotIndexView {
    if (!_myPlotIndexView) {
        
        if (!MYKLineVC.shareMYKLineVC.hiddenPlotIndex) {
            //创建头部
            if (!_mySetPlotIndew) {
                NSArray *MYKLineViewArr = [[NSBundle mainBundle] loadNibNamed:@"MYKLine" owner:nil options:nil];
                _mySetPlotIndew = MYKLineViewArr[0];
                [_mySetPlotIndew.IndexButton setTitle:[MYKLineVC shareMYKLineVC].plotIndexName forState:UIControlStateNormal];
                _mySetPlotIndew.frame = CGRectMake(10, CGRectGetMaxY(_myMainIndexView.frame), 1220 * SCREEN_WIDTH / 1334, 50 * SCREEN_HEIGHT / 750);
                [self.view addSubview:_mySetPlotIndew];
            }
            
            //创建主指标图
            _myPlotIndexView = [[MYPlotIndexView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_mySetPlotIndew.frame), CGRectGetWidth(_mySetPlotIndew.frame), 150 * SCREEN_HEIGHT / 750)];
            [self.view addSubview:_myPlotIndexView];
            //创建横屏button
            self.landscapeButton.bottom = _myPlotIndexView.bottom;
            [self.view bringSubviewToFront:self.landscapeButton];
            
            //block
            weakify(self);
            _mySetPlotIndew.setIndexAction = ^(NSString *index) {
                [weakSelf mySelectIndexVC];
                
            };
            _mySetPlotIndew.setDetailAction = ^(NSString *index) {
                //                [self mySetIndexVC];
                MYSetIndexVC *mySetIndexVC = [[UIStoryboard storyboardWithName:@"MYKLine" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MYSetIndex_VC"];
                //                mySetIndexVC.indexName = MYKLineVC.shareMYKLineVC.plotIndexName;
                [mySetIndexVC setIndex:MYKLineVC.shareMYKLineVC.plotIndexName];
                [weakSelf.navigationController pushViewController:mySetIndexVC animated:YES];
            };
        }
    }
    return _myPlotIndexView;
}

/// 懒加载选择指标图VC
- (MYSelectIndexVC *)mySelectIndexVC {
    if (!_mySelectIndexVC) {
        _mySelectIndexVC = [[UIStoryboard storyboardWithName:@"MYKLine" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MYSelectIndex_VC"];
        [UIApplication.sharedApplication.keyWindow addSubview:_mySelectIndexVC.view];
        // 关闭选择指标VC
        weakify(self);
        _mySelectIndexVC.closeAction = ^{
            [weakSelf.mySelectIndexVC.view removeFromSuperview];
            weakSelf.mySelectIndexVC = nil;
        };
        // 重新绘制k线
        _mySelectIndexVC.updataKLine = ^{
            //移除所有subview
            [weakSelf.myMainIndexView removeFromSuperview];
            weakSelf.myMainIndexView = nil;
            [weakSelf.mySetMainIndew removeFromSuperview];
            weakSelf.mySetMainIndew = nil;
            [weakSelf.myPlotIndexView removeFromSuperview];
            weakSelf.myPlotIndexView = nil;
            [weakSelf.mySetPlotIndew removeFromSuperview];
            weakSelf.mySetPlotIndew = nil;
            
            // 刷新主指标图数据
            [weakSelf myMainIndexView];
            
            
            [weakSelf.myMainIndexView drawKLineData];
            
            // 刷新副指标图数据
            if (![MYKLineVC shareMYKLineVC].hiddenPlotIndex) {
                [weakSelf myPlotIndexView];
                [weakSelf.myPlotIndexView drawKLineData];
            }
        };
        
    }
    return _mySelectIndexVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self dealWithData];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
}

/// 创建view
- (void)createUI {
    self.segC.selectedSegmentIndex = self.selectIndex;
    [self myMainIndexView];
    [self myPlotIndexView];
    //添加拖拽手势
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.view addGestureRecognizer:panGes];
    //添加捏合手势
    UIPinchGestureRecognizer *pinGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(pinchAction:)];
    [self.view addGestureRecognizer:pinGes];
    //添加长按手势
    UILongPressGestureRecognizer *mainLongPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    mainLongPressGes.minimumPressDuration = 0.3;
    [self.view addGestureRecognizer:mainLongPressGes];
    
    //添加点击手势
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tapGes];
}
#pragma mark - 手势
/// 长按手势Action
- (void)longPressAction:(UILongPressGestureRecognizer *)longGes{
    MYKLineVC.shareMYKLineVC.isCursor = YES;
    self.windowPoint = [longGes locationInView:self.view];
    
    self.mainPoint = [self.myMainIndexView convertPoint:self.windowPoint fromView:self.view];
    
    //    self.mainPoint = [longGes locationInView:self.myMainIndexView];
    NSInteger num;
    if (self.mainPoint.x > self.myMainIndexView.frame.size.width - 10) {
        num = [MYKLineVC shareMYKLineVC].candleNum - 1;
    } else if (self.mainPoint.x < 5) {
        num = 0;
    } else {
        num = (self.mainPoint.x - 5) * MYKLineVC.shareMYKLineVC.candleNum / (self.myMainIndexView.frame.size.width - 10);
    }
    self.mainPoint = CGPointMake((self.myMainIndexView.frame.size.width - 10) / [MYKLineVC shareMYKLineVC].candleNum * num + (self.myMainIndexView.frame.size.width - 10) / [MYKLineVC shareMYKLineVC].candleNum / 2 + 5, self.mainPoint.y);
    /// 主指标图调用十字光标
    [self.myMainIndexView addCursorWithPoint:self.mainPoint];
    
    /// 副指标图调用十字光标
    if (![MYKLineVC shareMYKLineVC].hiddenPlotIndex) {
        self.plotPoint =  [self.myPlotIndexView convertPoint:self.windowPoint fromView:self.view];
        self.plotPoint = CGPointMake((self.myMainIndexView.frame.size.width - 10) / [MYKLineVC shareMYKLineVC].candleNum * num + (self.myMainIndexView.frame.size.width - 10) / [MYKLineVC shareMYKLineVC].candleNum / 2 + 5, self.plotPoint.y);
        [self.myPlotIndexView addCursorWithPoint:self.plotPoint];
    }
    NSLog(@"windowPoint.x = %f,windowPoint.y = %f",self.windowPoint.x,self.windowPoint.y);
}

/// 点击手势Action
- (void)tapAction{
    if (MYKLineVC.shareMYKLineVC.isCursor) {
        MYKLineVC.shareMYKLineVC.isCursor = NO;
        [self.myMainIndexView removeCursor];
        if (![MYKLineVC shareMYKLineVC].hiddenPlotIndex) {
            [self.myPlotIndexView removeCursor];
        }
    }
}

/// 拖拽手势Action
- (void)panAction:(UIPanGestureRecognizer *)panGes {
    CGPoint panPoint = [panGes locationInView:self.view];
    //删除光标
    [self.myMainIndexView removeCursor];
    if (![MYKLineVC shareMYKLineVC].hiddenPlotIndex) {
        [self.myPlotIndexView removeCursor];
    }
    
    
    if (self.movePoint.x == -1000) {
        if (panPoint.x - self.beganPoint.x < 0) {   //右图出
            if (MYKLineVC.shareMYKLineVC.lastDataCount < MYKLineVC.shareMYKLineVC.KLineDataArray.count) {
                int num = (self.beganPoint.x - panPoint.x) * 5 / (self.myMainIndexView.frame.size.width - 10);
                if (MYKLineVC.shareMYKLineVC.lastDataCount + num <= MYKLineVC.shareMYKLineVC.KLineDataArray.count) {
                    MYKLineVC.shareMYKLineVC.lastDataCount += num;
                    [self.myMainIndexView drawKLineData];
                    [self.myPlotIndexView drawKLineData];
                } else {
                    MYKLineVC.shareMYKLineVC.lastDataCount = MYKLineVC.shareMYKLineVC.KLineDataArray.count;
                    [self.myMainIndexView drawKLineData];
                    [self.myPlotIndexView drawKLineData];
                }
            }
        }
        if (panPoint.x - self.beganPoint.x > 0) {                                    //左图出
            if (MYKLineVC.shareMYKLineVC.lastDataCount >= MYKLineVC.shareMYKLineVC.candleNum && MYKLineVC.shareMYKLineVC.lastDataCount <= MYKLineVC.shareMYKLineVC.KLineDataArray.count) {
                int num = (panPoint.x - self.beganPoint.x) * 5 / (self.myMainIndexView.frame.size.width - 10);
                MYKLineVC.shareMYKLineVC.lastDataCount -= num;
                [self.myMainIndexView drawKLineData];
                [self.myPlotIndexView drawKLineData];
            }
        }
        self.movePoint = [panGes locationInView:self.view];
    } else {
        if ((self.movePoint.x - panPoint.x < 0 && self.beganPoint.x - self.movePoint.x < 0) ||
            (self.movePoint.x - panPoint.x > 0 && self.beganPoint.x - self.movePoint.x > 0)) {   //方向不变
            if (panPoint.x - self.beganPoint.x < 0) {   //右图出
                if (MYKLineVC.shareMYKLineVC.lastDataCount < MYKLineVC.shareMYKLineVC.KLineDataArray.count) {
                    int num = (self.beganPoint.x - panPoint.x) * 5 / (self.myMainIndexView.frame.size.width - 10);
                    if (MYKLineVC.shareMYKLineVC.lastDataCount + num <= MYKLineVC.shareMYKLineVC.KLineDataArray.count) {
                        MYKLineVC.shareMYKLineVC.lastDataCount += num;
                        [self.myMainIndexView drawKLineData];
                        [self.myPlotIndexView drawKLineData];
                    } else {
                        MYKLineVC.shareMYKLineVC.lastDataCount = MYKLineVC.shareMYKLineVC.KLineDataArray.count;
                        [self.myMainIndexView drawKLineData];
                        [self.myPlotIndexView drawKLineData];
                    }
                }
            }
            if (panPoint.x - self.beganPoint.x > 0) {   //左图出
                if (MYKLineVC.shareMYKLineVC.lastDataCount >= MYKLineVC.shareMYKLineVC.candleNum && MYKLineVC.shareMYKLineVC.lastDataCount <= MYKLineVC.shareMYKLineVC.KLineDataArray.count) {
                    int num = (panPoint.x - self.beganPoint.x) * 5 / (self.myMainIndexView.frame.size.width - 10);
                    MYKLineVC.shareMYKLineVC.lastDataCount -= num;
                    [self.myMainIndexView drawKLineData];
                    [self.myPlotIndexView drawKLineData];
                }
            }
            self.movePoint = [panGes locationInView:self.view];
        } else { //方向改变
            if (self.beganPoint.x > self.movePoint.x && panPoint.x > self.movePoint.x) {  //手指先向左滑 又向右滑
                self.beganPoint = CGPointMake(self.movePoint.x, self.movePoint.y);
                self.movePoint = CGPointMake(panPoint.x, panPoint.y);
                
            }
            if (self.beganPoint.x < self.movePoint.x && panPoint.x < self.movePoint.x) {  //手指先向右滑 又向左滑
                self.beganPoint = CGPointMake(self.movePoint.x, self.movePoint.y);
                self.movePoint = CGPointMake(panPoint.x, panPoint.y);
            }
            
            if (self.movePoint.x - self.beganPoint.x < 0) {   //右图出
                if (MYKLineVC.shareMYKLineVC.lastDataCount < MYKLineVC.shareMYKLineVC.KLineDataArray.count) {
                    int num = (self.beganPoint.x - self.movePoint.x) * 5 / (self.myMainIndexView.frame.size.width - 10);
                    if (MYKLineVC.shareMYKLineVC.lastDataCount + num <= MYKLineVC.shareMYKLineVC.KLineDataArray.count) {
                        MYKLineVC.shareMYKLineVC.lastDataCount += num;
                        [self.myMainIndexView drawKLineData];
                        [self.myPlotIndexView drawKLineData];
                    } else {
                        MYKLineVC.shareMYKLineVC.lastDataCount = MYKLineVC.shareMYKLineVC.KLineDataArray.count;
                        [self.myMainIndexView drawKLineData];
                        [self.myPlotIndexView drawKLineData];
                    }
                }
            }
            if (self.movePoint.x - self.beganPoint.x > 0) {   //左图出
                if (MYKLineVC.shareMYKLineVC.lastDataCount >= MYKLineVC.shareMYKLineVC.candleNum && MYKLineVC.shareMYKLineVC.lastDataCount <= MYKLineVC.shareMYKLineVC.KLineDataArray.count) {
                    int num = (self.movePoint.x - self.beganPoint.x) * 5 / (self.myMainIndexView.frame.size.width - 10);
                    MYKLineVC.shareMYKLineVC.lastDataCount -= num;
                    [self.myMainIndexView drawKLineData];
                    [self.myPlotIndexView drawKLineData];
                }
            }
            
        }
    }
}

/// 捏合手势Action
- (void)pinchAction:(UIPinchGestureRecognizer *)recognizer{
    if (recognizer.state==UIGestureRecognizerStateBegan || recognizer.state==UIGestureRecognizerStateChanged)
        
    {
        if (recognizer.scale > 1) {
            if (MYKLineVC.shareMYKLineVC.candleNum > 15) {
                int num = recognizer.scale / 0.2;
                
                if (MYKLineVC.shareMYKLineVC.candleNum - num >= 15) {
                    MYKLineVC.shareMYKLineVC.candleNum = MYKLineVC.shareMYKLineVC.candleNum - num;
                    [self.myMainIndexView drawKLineData];
                    [self.myPlotIndexView drawKLineData];
                }
            }
        }
        
        if (recognizer.scale < 1) {
            if (MYKLineVC.shareMYKLineVC.candleNum < 50) {
                int num = recognizer.scale / 0.2;
                if (MYKLineVC.shareMYKLineVC.candleNum - num <= 50) {
                    MYKLineVC.shareMYKLineVC.candleNum = MYKLineVC.shareMYKLineVC.candleNum + num;
                    [self.myMainIndexView drawKLineData];
                    [self.myPlotIndexView drawKLineData];
                }
            }
        }
        NSLog(@"velocity = %f,scale = %f",recognizer.velocity,recognizer.scale);
    }
}

#pragma mark - 绘制k线
//接收数据开始处理
- (void)dealWithData {
    //移除所有subview
    [self.myMainIndexView removeFromSuperview];
    self.myMainIndexView = nil;
    [self.mySetMainIndew removeFromSuperview];
    self.mySetMainIndew = nil;
    [self.myPlotIndexView removeFromSuperview];
    self.myPlotIndexView = nil;
    [self.mySetPlotIndew removeFromSuperview];
    self.mySetPlotIndew = nil;
    
    // 刷新主指标图数据
    [self.myMainIndexView drawKLineData];
    
    // 刷新副指标图数据
    if (![MYKLineVC shareMYKLineVC].hiddenPlotIndex) {
        [self.myPlotIndexView drawKLineData];
    }
    // 刷新十字光标
    if (MYKLineVC.shareMYKLineVC.isCursor) {
        // 主指标图调用十字光标
        [self.myMainIndexView addCursorWithPoint:self.mainPoint];
        // 副指标图调用十字光标
        if (![MYKLineVC shareMYKLineVC].hiddenPlotIndex) {
            [self.myPlotIndexView addCursorWithPoint:self.plotPoint];
        }
    }
    //刷新指标参数
    [self.mySetMainIndew detailLabel:[MYKLineVC shareMYKLineVC].mainIndexName];
    [self.mySetPlotIndew detailLabel:[MYKLineVC shareMYKLineVC].plotIndexName];
};

////更新数据
//- (void)updateKLineData {
//    // 刷新主指标图数据
//    [self.myMainIndexView removeFromSuperview];
//    self.myMainIndexView = nil;
//    [self.myMainIndexView drawKLineData:MYKLineVC.shareMYKLineVC.KLineDataArray];
//    // 刷新副指标图数据
//    if (![MYKLineVC shareMYKLineVC].hiddenPlotIndex) {
//        [self.myPlotIndexView removeFromSuperview];
//        self.myPlotIndexView = nil;
//        [self.myPlotIndexView drawKLineData:MYKLineVC.shareMYKLineVC.KLineDataArray];
//    }
//    // 刷新十字光标
//    if (MYKLineVC.shareMYKLineVC.isCursor) {
//        // 主指标图调用十字光标
//        [self.myMainIndexView addCursorWithPoint:self.mainPoint];
//        // 副指标图调用十字光标
//        if (![MYKLineVC shareMYKLineVC].hiddenPlotIndex) {
//            [self.myPlotIndexView addCursorWithPoint:self.plotPoint];
//        }
//    }
//    //刷新指标参数
//    [self.mySetMainIndew detailLabel:[MYKLineVC shareMYKLineVC].mainIndexName];
//    [self.mySetPlotIndew detailLabel:[MYKLineVC shareMYKLineVC].plotIndexName];
//};

#pragma mark - 返回竖屏
//- (IBAction)backAction:(id)sender {
//    MYKLineVC.shareMYKLineVC.isSupportCrossScreen = NO;
//    [self forceOrientationPortraitWith:self];    //竖屏
//    self.backAction();
//    [self.navigationController popViewControllerAnimated:YES];
//}


- (void)lansdcapeAction {
    MYKLineVC.shareMYKLineVC.isSupportCrossScreen = NO;
    [self forceOrientationPortraitWith:self];    //竖屏
    self.backAction();
    [self.navigationController popViewControllerAnimated:YES];
}


// 竖屏
- (void)forceOrientationPortraitWith:(UIViewController *)VC{
    
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:VC.view.window];
    
    //强制翻转屏幕
    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
}

#pragma mark - segmentControl
- (IBAction)segCAction:(UISegmentedControl *)sender {
    if (self.selectIndex != sender.selectedSegmentIndex) {
        self.selectIndex = sender.selectedSegmentIndex;
        self.changeSegCSelect(sender.selectedSegmentIndex);
    }
}

#pragma mark - Touch Delegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    self.beganPoint = [touch locationInView:self.view];
    self.movePoint = CGPointMake(-1000, self.beganPoint.y);
}
@end
