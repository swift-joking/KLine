//
//  MYKLineMintueVC.m
//  XinShengInternational
//
//  Created by michelle on 2017/9/20.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import "MYKLineMintueVC.h"
#import "MYMainIndexView.h"
#import "MYPlotIndexView.h"
#import "MYSetIndexView.h"
#import "MYSetIndexVC.h"
#import "MYSelectIndexVC.h"
#import "MYLandscapeVC.h"

@interface MYKLineMintueVC ()

@property (nonatomic, retain) MYMainIndexView *myMainIndexView;   //分钟图主指标图
@property (nonatomic, retain) MYPlotIndexView *myPlotIndexView;   //分钟图副指标图
@property (nonatomic, retain) MYSetIndexView *mySetMainIndew;     //主指标参数设置View
@property (nonatomic, retain) MYSetIndexView *mySetPlotIndew;     //副指标参数设置View
@property (nonatomic, assign) CGPoint beganPoint;                 //拖动手势标记
@property (nonatomic, assign) CGPoint movePoint;                  //拖动手势标记
@property (nonatomic, retain) MYSelectIndexVC *mySelectIndexVC;   //设置所有指标参数VC
@property (nonatomic, assign) CGPoint mainPoint;                  //拖动k线手势标记
@property (nonatomic, assign) CGPoint plotPoint;                  //拖动k线手势标记
@property (nonatomic, assign) CGPoint windowPoint;                //拖动k线手势标记
@property (nonatomic, retain) UIButton *crossScreenButton;        //横屏button
@property (nonatomic, retain) MYLandscapeVC *myLandscapeVC;       //横屏VC
@end

@implementation MYKLineMintueVC


#pragma mark ================== 懒加载 =================

/**
 横屏VC

 @return 横屏VC
 */
- (MYLandscapeVC *)myLandscapeVC {
    if (!_myLandscapeVC) {
        _myLandscapeVC = [[UIStoryboard storyboardWithName:@"MYKLine" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MYLandscape_VC"];
        _myLandscapeVC.selectIndex = MYKLineVC.shareMYKLineVC.selectIndex;
        weakify(self);
        //改变选择
        _myLandscapeVC.changeSegCSelect = ^(NSInteger selectIndex) {
            weakSelf.changeSegCSelect(selectIndex);
        };
        
        //返回
        _myLandscapeVC.backAction = ^{
            [weakSelf dealWithData];
            weakSelf.myLandscapeVC = nil;
        };
    }
    return _myLandscapeVC;
}


/**
 横屏button

 @return 横屏button
 */
- (UIButton *)crossScreenButton {
    if (!_crossScreenButton) {
        _crossScreenButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _crossScreenButton.frame = CGRectMake(0, 0, 55 * PHONE_WIDTH, 50 * PHONE_WIDTH);
        [_crossScreenButton setTitle:@"横屏" forState:UIControlStateNormal];
        [_crossScreenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_crossScreenButton buttonWithFontSize:22 * PHONE_WIDTH ];
        [_crossScreenButton setBackgroundColor:[UIColor grayColor]];
        [_crossScreenButton addTarget:self action:@selector(crossScreenAction)];
        [self.view addSubview:_crossScreenButton];
    }
    return _crossScreenButton;
}


/**
 懒加载主指标View

 @return 懒加载主指标View
 */
- (MYMainIndexView *)myMainIndexView {
    if (!_myMainIndexView) {
        //创建头部
        if (!_mySetMainIndew) {
            NSArray *MYKLineViewArr = [[NSBundle mainBundle] loadNibNamed:@"MYKLine" owner:nil options:nil];
            _mySetMainIndew = MYKLineViewArr[0];
            [_mySetMainIndew.IndexButton setTitle:[MYKLineVC shareMYKLineVC].mainIndexName forState:UIControlStateNormal];
            [_mySetMainIndew detailLabel:[MYKLineVC shareMYKLineVC].mainIndexName];
            _mySetMainIndew.frame = CGRectMake(10, 10, 640 * PHONE_WIDTH, 55 * PHONE_HEIGHT);
            [self.view addSubview:_mySetMainIndew];
        }
        
        //创建主指标图
        if (MYKLineVC.shareMYKLineVC.hiddenPlotIndex) {
            _myMainIndexView = [[MYMainIndexView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_mySetMainIndew.frame), CGRectGetWidth(_mySetMainIndew.frame), 825 * PHONE_HEIGHT)];
            [self.view addSubview:_myMainIndexView];
            //创建横屏button
            self.crossScreenButton.bottom = self.myMainIndexView.bottom;
            [self.view bringSubviewToFront:self.crossScreenButton];
        } else {
            _myMainIndexView = [[MYMainIndexView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_mySetMainIndew.frame), CGRectGetWidth(_mySetMainIndew.frame), 470 * PHONE_HEIGHT)];
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
            mySetIndexVC.setIndex = ^(NSString *indexName) {
                if ([indexName isEqualToString:MYKLineVC.shareMYKLineVC.mainIndexName]) {
                    [weakSelf dealWithData];
                }
            };
            [weakSelf.navigationController pushViewController:mySetIndexVC animated:YES];
        };
    }
    return _myMainIndexView;
}


/**
 懒加载副指标View

 @return 懒加载副指标View
 */
- (MYPlotIndexView *)myPlotIndexView {
    if (!_myPlotIndexView) {
        
        if (!MYKLineVC.shareMYKLineVC.hiddenPlotIndex) {
            //创建头部
            if (!_mySetPlotIndew) {
                NSArray *MYKLineViewArr = [[NSBundle mainBundle] loadNibNamed:@"MYKLine" owner:nil options:nil];
                _mySetPlotIndew = MYKLineViewArr[0];
                [_mySetPlotIndew.IndexButton setTitle:[MYKLineVC shareMYKLineVC].plotIndexName forState:UIControlStateNormal];
                _mySetPlotIndew.frame = CGRectMake(10, CGRectGetMaxY(_myMainIndexView.frame), 640 * PHONE_WIDTH, 55 * PHONE_HEIGHT);
                [self.view addSubview:_mySetPlotIndew];
                
            }
            
            //创建主指标图
            _myPlotIndexView = [[MYPlotIndexView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_mySetPlotIndew.frame), CGRectGetWidth(_mySetPlotIndew.frame), 300 * PHONE_HEIGHT)];
            [self.view addSubview:_myPlotIndexView];
            //创建横屏button
            self.crossScreenButton.bottom = _myPlotIndexView.bottom;
            [self.view bringSubviewToFront:self.crossScreenButton];

            //block
            weakify(self);
            _mySetPlotIndew.setIndexAction = ^(NSString *index) {
                [weakSelf mySelectIndexVC];
                
            };
            _mySetPlotIndew.setDetailAction = ^(NSString *index) {
                MYSetIndexVC *mySetIndexVC = [[UIStoryboard storyboardWithName:@"MYKLine" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MYSetIndex_VC"];
                [mySetIndexVC setIndex:MYKLineVC.shareMYKLineVC.plotIndexName];
                mySetIndexVC.setIndex = ^(NSString *indexName) {
                    if ([indexName isEqualToString:MYKLineVC.shareMYKLineVC.plotIndexName]) {
                        [weakSelf dealWithData];
                    }
                };
                [weakSelf.navigationController pushViewController:mySetIndexVC animated:YES];
            };
        }
    }
    return _myPlotIndexView;
}


/**
 懒加载选择指标图VC

 @return 懒加载选择指标图VC
 */
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
            [weakSelf dealWithData];
        };
        
    }
    return _mySelectIndexVC;
}


#pragma mark ================== viewDidLoad =================
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
}


/**
 创建view
 */
- (void)createUI {
    //创建主指标图
    [self myMainIndexView];
    //创建副指标图
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


#pragma mark ================== 手势 =================

/**
 长按手势Action

 @param longGes 长按手势
 */
- (void)longPressAction:(UILongPressGestureRecognizer *)longGes{
    MYKLineVC.shareMYKLineVC.isCursor = YES;
    self.windowPoint = [longGes locationInView:self.view];
    
    self.mainPoint = [self.myMainIndexView convertPoint:self.windowPoint fromView:self.view];
    
    NSInteger num;
    if (self.mainPoint.x > self.myMainIndexView.frame.size.width - 10) {
        num = [MYKLineVC shareMYKLineVC].candleNum - 1;
    } else if (self.mainPoint.x < 5) {
        num = 0;
    } else {
        num = (self.mainPoint.x - 5) * MYKLineVC.shareMYKLineVC.candleNum / (self.myMainIndexView.frame.size.width - 10);
    }
    self.mainPoint = CGPointMake((self.myMainIndexView.frame.size.width - 10) / [MYKLineVC shareMYKLineVC].candleNum * num + (self.myMainIndexView.frame.size.width - 10) / [MYKLineVC shareMYKLineVC].candleNum / 2 + 5, self.mainPoint.y);
    // 主指标图调用十字光标
    [self.myMainIndexView addCursorWithPoint:self.mainPoint];
    
    // 副指标图调用十字光标
    if (![MYKLineVC shareMYKLineVC].hiddenPlotIndex) {
        self.plotPoint =  [self.myPlotIndexView convertPoint:self.windowPoint fromView:self.view];
        self.plotPoint = CGPointMake((self.myMainIndexView.frame.size.width - 10) / [MYKLineVC shareMYKLineVC].candleNum * num + (self.myMainIndexView.frame.size.width - 10) / [MYKLineVC shareMYKLineVC].candleNum / 2 + 5, self.plotPoint.y);
        [self.myPlotIndexView addCursorWithPoint:self.plotPoint];
    }
    
    // 刷新指标图上的十字光标
    MYKLineVC.shareMYKLineVC.CursorIndex = MYKLineVC.shareMYKLineVC.firstNum + num;
    self.updatePriceLabel();
    // 刷新设置指标上的内容
    [self.mySetMainIndew detailLabel:[MYKLineVC shareMYKLineVC].mainIndexName];
    if (!MYKLineVC.shareMYKLineVC.hiddenPlotIndex) {
        [self.mySetPlotIndew detailLabel:[MYKLineVC shareMYKLineVC].mainIndexName];
    }
    
//    NSLog(@"windowPoint.x = %f,windowPoint.y = %f",self.windowPoint.x,self.windowPoint.y);
}


/**
 点击手势Action
 */
- (void)tapAction{
    if (MYKLineVC.shareMYKLineVC.isCursor) {
        MYKLineVC.shareMYKLineVC.isCursor = NO;
        [self.myMainIndexView removeCursor];
        if (![MYKLineVC shareMYKLineVC].hiddenPlotIndex) {
            [self.myPlotIndexView removeCursor];
        }
        //刷新指标图上的十字光标
        self.updatePriceLabel();
        //刷新设置指标上的内容
        [self.mySetMainIndew detailLabel:[MYKLineVC shareMYKLineVC].mainIndexName];
        if (!MYKLineVC.shareMYKLineVC.hiddenPlotIndex) {
            [self.mySetPlotIndew detailLabel:[MYKLineVC shareMYKLineVC].mainIndexName];
        }
    }
}


/**
 拖拽手势Action

 @param panGes 拖拽手势
 */
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
                MYKLineVC.shareMYKLineVC.CursorIndex = num;
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


/**
 捏合手势Action

 @param recognizer 捏合手势
 */
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
//        NSLog(@"velocity = %f,scale = %f",recognizer.velocity,recognizer.scale);
    }
}


#pragma mark ================== 绘制更新k线分钟图 =================
/**
 绘制k线分钟图
 */
- (void)dealWithData {
    if (_myLandscapeVC) {
        [self.myLandscapeVC dealWithData];
    } else {
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
    }
    
    
};


/**
 更新k线分钟图
 */
- (void)updateKLineData {
    if (_myLandscapeVC) {
        [self.myLandscapeVC dealWithData];
    } else {
        // 刷新主指标图数据
        [self.myMainIndexView removeFromSuperview];
        self.myMainIndexView = nil;
        [self.myMainIndexView drawKLineData];
        // 刷新副指标图数据
        if (![MYKLineVC shareMYKLineVC].hiddenPlotIndex) {
            [self.myPlotIndexView removeFromSuperview];
            self.myPlotIndexView = nil;
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
    }
};


#pragma mark ================== 横屏 =================
- (void)crossScreenAction {
    MYKLineVC.shareMYKLineVC.isSupportCrossScreen = YES;
    [self forceOrientationLandscapeWith:self];   //横屏
    [self myLandscapeVC];
    [self.navigationController pushViewController:self.myLandscapeVC animated:YES];
}

// 横屏 home键在右边
-(void)forceOrientationLandscapeWith:(UIViewController *)VC{
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:VC.view.window];
    
    //强制翻转屏幕，Home键在右边。
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
}


#pragma mark ================== Touch Delegate =================
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    self.beganPoint = [touch locationInView:self.view];
    self.movePoint = CGPointMake(-1000, self.beganPoint.y);
}

@end
