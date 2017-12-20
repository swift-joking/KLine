//
//  MYKLineVC.m
//  XinShengInternational
//
//  Created by michelle on 2017/9/5.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import "MYKLineVC.h"
#import "TimeSharingVC.h"
#import "TimeSharingView.h"
#import "MYKLineDataModel.h"
#import "MYKLineMintueVC.h"
#import "FFDropDownMenuView.h"
#import "MYSelectMintueTypeView.h"

@interface MYKLineVC ()
//------------------ storyboard创建的 ------------------
@property (weak, nonatomic) IBOutlet UIView *KLineView;                 //加载图表的底部view
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;                //时间
@property (weak, nonatomic) IBOutlet UILabel *bidPriceLabel;            //bid
@property (weak, nonatomic) IBOutlet UILabel *lowPriceLabel;            //最低价
@property (weak, nonatomic) IBOutlet UILabel *highPriceLabel;           //最高价
@property (weak, nonatomic) IBOutlet UILabel *openPriceLabel;           //开盘价
@property (weak, nonatomic) IBOutlet UILabel *closePriceLabel;          //收盘价
@property (weak, nonatomic) IBOutlet UISegmentedControl *MYKLineSegC;   //选择图表的segmentControl

//------------------ 分时图和分钟图 ------------------
@property (nonatomic, retain) TimeSharingVC *timeSharingVC;             //分时图
@property (nonatomic, retain) MYKLineMintueVC *myKLineMintueVC;
@property (nonatomic, retain) MYSelectMintueTypeView *selectTypeView;   //选择图表类型

//------------------ 下拉菜单 ------------------
@property (nonatomic, strong) FFDropDownMenuView *itemDropDownMenu;     //选择图表类型，现价线，空心阳线

@end

@implementation MYKLineVC

#pragma mark ================== 单例 =================
/**
 单例创建k线VC
 
 @return k线VC
 */
+ (MYKLineVC *)shareMYKLineVC {
    static MYKLineVC *myKLineVC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myKLineVC = [[UIStoryboard storyboardWithName:@"MYKLine" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MYKLine_VC"];
        
    });
    return myKLineVC;
}

#pragma mark ================== 懒加载 =================

/**
 所有指标图数组

 @return 5种主指标和12种副指标的string，后期优化可用plist文件代替
 */
- (NSMutableArray *)mainIndexAry {
    if (!_mainIndexAry) {
        _mainIndexAry = [@[@"BBI",@"BOLL",@"MA",@"MIKE",@"PBX",@"ARBR",@"ATR",@"BIAS",@"CCI",@"DKBY",@"KD",@"KDJ",@"LW&R",@"MACD",@"QHLSR",@"RSI",@"W&R"] mutableCopy];
    }
    return _mainIndexAry;
}


/**
 所有指标参数

 @return 5种主指标和12种副指标的指标参数
     Name:指标参数名称
     value:默认指标参数值
     minValue:指标参数最小范围
     maxValue:指标参数最大范围
     newValue:指标参数修改后数值，初始为-1，表示没有修改该指标参数数值
     设置 value 和 newValue是为了标记默认初始参数值和修改参数值，实现恢复默认参数值的功能
     后期优化可以用plist文件代替
 */
- (NSMutableArray *)plotIndexAry {
    if (!_plotIndexAry) {
        _plotIndexAry = [@[
                           @[  //0
                               @[[@{@"Name" : @"N1",@"value" : @(3),@"minValue" : @(1),@"maxValue" : @(100),@"newValue" : @(-1)} mutableCopy]],
                               @[[@{@"Name" : @"N2",@"value" : @(6),@"minValue" : @(1),@"maxValue" : @(100),@"newValue" : @(-1)} mutableCopy]],
                               @[[@{@"Name" : @"N3",@"value" : @(12),@"minValue" : @(1),@"maxValue" : @(100),@"newValue" : @(-1)} mutableCopy]],
                               @[[@{@"Name" : @"N4",@"value" : @(24),@"minValue" : @(1),@"maxValue" : @(100),@"newValue" : @(-1)} mutableCopy]]
                               ],
                           @[  //1
                               @[[@{@"Name" : @"N",@"value" : @(26),@"minValue" : @(5),@"maxValue" : @(300),@"newValue" : @(-1)} mutableCopy]],
                               @[[@{@"Name" : @"P",@"value" : @(2),@"minValue" : @(1),@"maxValue" : @(10),@"newValue" : @(-1)} mutableCopy]]
                               ],
                           @[  //2
                               @[[@{@"Name" : @"L1",@"value" : @(5),@"minValue" : @(1),@"maxValue" : @(300),@"newValue" : @(-1)} mutableCopy]],
                               @[[@{@"Name" : @"L2",@"value" : @(10),@"minValue" : @(1),@"maxValue" : @(300),@"newValue" : @(-1)} mutableCopy]],
                               @[[@{@"Name" : @"L3",@"value" : @(20),@"minValue" : @(1),@"maxValue" : @(300),@"newValue" : @(-1)} mutableCopy]],
                               @[[@{@"Name" : @"L4",@"value" : @(30),@"minValue" : @(1),@"maxValue" : @(300),@"newValue" : @(-1)} mutableCopy]],
                               @[[@{@"Name" : @"L5",@"value" : @(60),@"minValue" : @(1),@"maxValue" : @(300),@"newValue" : @(-1)} mutableCopy]]
                               ],
                           @[  //3
                               @[[@{@"Name" : @"N",@"value" : @(12),@"minValue" : @(1),@"maxValue" : @(200),@"newValue" : @(-1)} mutableCopy]]
                               ],
                           @[  //4
                               
                               ],
                           @[  //5
                               @[[@{@"Name" : @"N",@"value" : @(26),@"minValue" : @(2),@"maxValue" : @(300),@"newValue" : @(-1)} mutableCopy]]
                               ],
                           @[  //6
                               @[[@{@"Name" : @"N",@"value" : @(14),@"minValue" : @(1),@"maxValue" : @(300),@"newValue" : @(-1)} mutableCopy]]
                               ],
                           @[  //7
                               @[[@{@"Name" : @"L1",@"value" : @(6),@"minValue" : @(1),@"maxValue" : @(300),@"newValue" : @(-1)} mutableCopy]],
                               @[[@{@"Name" : @"L2",@"value" : @(12),@"minValue" : @(1),@"maxValue" : @(300),@"newValue" : @(-1)} mutableCopy]],
                               @[[@{@"Name" : @"L3",@"value" : @(24),@"minValue" : @(1),@"maxValue" : @(300),@"newValue" : @(-1)} mutableCopy]]
                               ],
                           @[  //8
                               @[[@{@"Name" : @"N",@"value" : @(14),@"minValue" : @(2),@"maxValue" : @(100),@"newValue" : @(-1)} mutableCopy]]
                               ],
                           @[  //9
                               
                               ],
                           @[  //10
                               @[[@{@"Name" : @"N",@"value" : @(9),@"minValue" : @(1),@"maxValue" : @(100),@"newValue" : @(-1)} mutableCopy]],
                               @[[@{@"Name" : @"M1",@"value" : @(3),@"minValue" : @(2),@"maxValue" : @(40),@"newValue" : @(-1)} mutableCopy]],
                               @[[@{@"Name" : @"M1",@"value" : @(3),@"minValue" : @(2),@"maxValue" : @(40),@"newValue" : @(-1)} mutableCopy]]
                               ],
                           @[  //11
                               @[[@{@"Name" : @"N",@"value" : @(9),@"minValue" : @(1),@"maxValue" : @(100),@"newValue" : @(-1)} mutableCopy]],
                               @[[@{@"Name" : @"M1",@"value" : @(3),@"minValue" : @(2),@"maxValue" : @(40),@"newValue" : @(-1)} mutableCopy]],
                               @[[@{@"Name" : @"M1",@"value" : @(3),@"minValue" : @(2),@"maxValue" : @(40),@"newValue" : @(-1)} mutableCopy]]
                               ],
                           @[  //12
                               @[[@{@"Name" : @"N",@"value" : @(9),@"minValue" : @(1),@"maxValue" : @(100),@"newValue" : @(-1)} mutableCopy]],
                               @[[@{@"Name" : @"M1",@"value" : @(3),@"minValue" : @(2),@"maxValue" : @(40),@"newValue" : @(-1)} mutableCopy]],
                               @[[@{@"Name" : @"M1",@"value" : @(3),@"minValue" : @(2),@"maxValue" : @(40),@"newValue" : @(-1)} mutableCopy]]
                               ],
                           @[  //13
                               @[[@{@"Name" : @"LONG",@"value" : @(26),@"minValue" : @(20),@"maxValue" : @(100),@"newValue" : @(-1)} mutableCopy]],
                               @[[@{@"Name" : @"SHORT",@"value" : @(12),@"minValue" : @(5),@"maxValue" : @(40),@"newValue" : @(-1)} mutableCopy]],
                               @[[@{@"Name" : @"M",@"value" : @(9),@"minValue" : @(2),@"maxValue" : @(60),@"newValue" : @(-1)} mutableCopy]]
                               ],
                           @[  //14
                               
                               ],
                           @[  //15
                               @[[@{@"Name" : @"N1",@"value" : @(6),@"minValue" : @(2),@"maxValue" : @(200),@"newValue" : @(-1)} mutableCopy]],
                               @[[@{@"Name" : @"N2",@"value" : @(12),@"minValue" : @(2),@"maxValue" : @(200),@"newValue" : @(-1)} mutableCopy]],
                               @[[@{@"Name" : @"N3",@"value" : @(24),@"minValue" : @(2),@"maxValue" : @(200),@"newValue" : @(-1)} mutableCopy]]
                               ],
                           @[  //16
                               @[[@{@"Name" : @"N",@"value" : @(14),@"minValue" : @(2),@"maxValue" : @(100),@"newValue" : @(-1)} mutableCopy]]
                               ]
                           
                           ] mutableCopy];
    }
    return _plotIndexAry;
}


/**
 k线数组

 @return k线数组
 */
- (NSMutableArray *)KLineDataArray {
    if (!_KLineDataArray) {
        _KLineDataArray = [NSMutableArray array];
    }
    return _KLineDataArray;
}


// 分时图
/**
 分时图

 @return 分时图
 */
- (TimeSharingVC *)timeSharingVC {
    if (self.MYKLineSegC.selectedSegmentIndex == 0) {
        if (!_timeSharingVC) {
            //创建vc
            self.timeSharingVC = [[UIStoryboard storyboardWithName:@"MYKLine" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"TimeSharing_VC"];
            self.timeSharingVC.view.frame = CGRectMake(0, 0, self.KLineView.frame.size.width, self.KLineView.frame.size.height);
            [self addChildViewController:self.timeSharingVC];
            [self.KLineView addSubview:self.timeSharingVC.view];
            [self.KLineView bringSubviewToFront:self.timeSharingVC.view];
            weakify(self);
            //更新priceLabel
            self.timeSharingVC.updatePriceLabel = ^{
                [weakSelf updatePriceLabel];
            };
        }
    } else {
        if (_timeSharingVC) {
            [_timeSharingVC removeFromParentViewController];
            [_timeSharingVC.view removeFromSuperview];
            _timeSharingVC = nil;
        }
    }
    return _timeSharingVC;
}


/**
 分钟图

 @return 分钟图
 */
- (MYKLineMintueVC *)myKLineMintueVC {
    if (self.MYKLineSegC.selectedSegmentIndex != 0) {
        // 创建vc
        if (!_myKLineMintueVC) {
            weakify(self);
            //创建vc
            _myKLineMintueVC = [[UIStoryboard storyboardWithName:@"MYKLine" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MYKLineMintue_VC"];
            //判断是否隐藏副指标图
            _myKLineMintueVC.hiddenPlotIndexAction = ^(BOOL hidden) {
                weakSelf.hiddenPlotIndex = hidden;
            };
            //添加vc
            [self addChildViewController:self.myKLineMintueVC];
            [self.KLineView addSubview:self.myKLineMintueVC.view];
            self.myKLineMintueVC.view.frame = CGRectMake(0, 0, self.KLineView.frame.size.width, self.KLineView.frame.size.height);
            self.myKLineMintueVC.changeSegCSelect = ^(NSInteger selectIndex) {
                weakSelf.selectIndex = selectIndex;
                if (selectIndex < 6) {
                    
                    weakSelf.MYKLineSegC.selectedSegmentIndex = selectIndex;
                    [weakSelf KLineSegCAction:weakSelf.MYKLineSegC];
                } else {
                    weakSelf.MYKLineSegC.selectedSegmentIndex = 6;
                }
            };
            self.myKLineMintueVC.updatePriceLabel = ^{
                [weakSelf updatePriceLabel];
            };
        }
    } else {
        if (_myKLineMintueVC) {
            [_myKLineMintueVC removeFromParentViewController];
            [_myKLineMintueVC.view removeFromSuperview];
            _myKLineMintueVC = nil;
        }
    }
    return _myKLineMintueVC;
}



/**
 切换k线指标的view

 @return 切换k线指标的view
 */
- (MYSelectMintueTypeView *)selectTypeView {
    if (!_selectTypeView) {
        weakify(self);
        NSArray *MYKLineViewArr = [[NSBundle mainBundle] loadNibNamed:@"MYKLine" owner:nil options:nil];
        _selectTypeView = MYKLineViewArr[1];
        _selectTypeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [_selectTypeView setSelectSegC];
        [UIApplication.sharedApplication.keyWindow addSubview:_selectTypeView];
        _selectTypeView.closeAction = ^{
            [weakSelf.selectTypeView removeFromSuperview];
            weakSelf.selectTypeView = nil;
        };
        _selectTypeView.changeMintueAction = ^{
            [weakSelf.myKLineMintueVC dealWithData];
        };
    }
    return _selectTypeView;
}


#pragma mark ================== ViewDidLoad =================
- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建下拉菜单
    [self setupItemDropDownMenu];
    
    //默认主指标图为MA
    self.mainIndexName = @"MA";
    
    //默认副指标图为MACD
    self.plotIndexName = @"MACD";
    
    //默认为空心阳线
    self.candleIsEmpty = YES;
    
    //默认不隐藏现价线
    self.hiddenCurrentPriceLine = NO;
    
    //默认显示副指标
    self.hiddenPlotIndex = NO;
    
    //默认为蜡烛图
    self.candleType = 0;
    
    //默认展示50组数据
    self.candleNum = 50;
    
    //默认显示分时图
    self.selectIndex = 0;
    
    //默认多请求300组数据
    self.lastDataCount = 300 + self.candleNum;
    
    //默认不显示十字光标
    self.isCursor = NO;
    
    //默认不支持横屏
    self.isSupportCrossScreen = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark ================== 创建下拉菜单 =================
/** 初始化下拉菜单 */
- (void)setupItemDropDownMenu {
    NSArray *modelsArray = [self getItemMenuModelsArray];
    
    self.itemDropDownMenu = [FFDropDownMenuView ff_DefaultStyleDropDownMenuWithMenuModelsArray:modelsArray
                                                                                 menuWidth:FFDefaultFloat
                                                                            eachItemHeight:FFDefaultFloat
                                                                           menuRightMargin:FFDefaultFloat
                                                                       triangleRightMargin:FFDefaultFloat];
    self.itemDropDownMenu.titleColor = [UIColor whiteColor];
    self.itemDropDownMenu.menuItemBackgroundColor = [UIColor grayColor];
    self.itemDropDownMenu.ifShouldScroll = NO;
    [self.itemDropDownMenu setup];
}

/** 获取菜单模型数组 */
- (NSArray *)getItemMenuModelsArray {
    weakify(self);
    FFDropDownMenuModel *model1 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"合约属性"
                                                                                menuItemIconName:@"MY_Detail.png"
                                                                                       menuBlock:^{
                                                                                                                                                                                      NSLog(@"合约属性");
                                                                                           //跳转到添加自选页面
                                                                                                                         }];
    
    FFDropDownMenuModel *model2 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"图表类型" menuItemIconName:@"MY_Line.png" menuBlock:^{
        //显示蜡烛图 柱状图 线形图 的切换view
        [weakSelf selectTypeView];
    }];
    
    FFDropDownMenuModel *model3 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"现价线" menuItemIconName:@"MY_Select.png" menuBlock:^{
        //设置是否隐藏现价线
        self.hiddenCurrentPriceLine = !self.hiddenCurrentPriceLine;
        //重新绘制k线
        [weakSelf.myKLineMintueVC dealWithData];
    }];
    
    FFDropDownMenuModel *model4 = [FFDropDownMenuModel ff_DropDownMenuModelWithMenuItemTitle:@"空心阳线" menuItemIconName:@"MY_Select.png" menuBlock:^{
        //设置是否是空心阳线
        weakSelf.candleIsEmpty = !self.candleIsEmpty;
        //重新绘制k线
        [weakSelf.myKLineMintueVC dealWithData];
    }];
    
    NSArray *menuModelArr = [NSArray array];
    if (self.MYKLineSegC.selectedSegmentIndex == 0) {
        menuModelArr = @[model1];
    } else {
        menuModelArr = @[model1, model2, model3, model4];
    }
    return menuModelArr;
}

#pragma mark ================== StoryBoard Action =================
- (IBAction)KLineSegCAction:(UISegmentedControl *)sender {
    if (self.selectIndex != sender.selectedSegmentIndex) {
        if (sender.selectedSegmentIndex != 6) {
            [self timeSharingVC];
            [self myKLineMintueVC];
            //创建下拉菜单
            [self setupItemDropDownMenu];
            //请求数据
            self.isCursor = NO;
            self.selectIndex = self.MYKLineSegC.selectedSegmentIndex;
            //执行代理请求数据
            [self.delegate MYKlineRequestDateWithType:self.MYKLineSegC.selectedSegmentIndex];
        }
    }
    
}

// 添加我的自选item
- (IBAction)addMySelfAction:(UIBarButtonItem *)sender {
    
}

// 添加合约属性item
- (IBAction)showListAction:(UIBarButtonItem *)sender {
    [self.itemDropDownMenu showMenu];
}

#pragma mark ================== 数据处理 =================
/**
 请求k线
 */
- (void)requestKLineDateWithType{
    [self.delegate MYKlineRequestDateWithType:self.selectIndex];
}


/**
 第一次请求k线数据成功时，处理第一批成组k线数据
 
 @param KLineDateArray webscocket或者http请求回来的k线数据数组
 */
- (void)dealWithDate:(NSMutableArray *)KLineDateArray {
    //单例VC种的数组保存
    self.KLineDataArray = [NSMutableArray arrayWithArray:KLineDateArray];
    //根据SegmentControl来画对应的图
    switch (self.MYKLineSegC.selectedSegmentIndex) {
        case 0:
        {
            //绘制分时图
            [self.timeSharingVC dealWithData];
        }
            break;
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        {
            //绘制k线分钟图
            [self.myKLineMintueVC dealWithData];
        }
            break;
        default:
            break;
    }
    
    //更新priceLabel
    [self updatePriceLabel];
}

/**
 接收刷新的k线数据时，刷新k线当前画图操作
 
 @param updateDateModel 更新k线时新的k线数据
 */
- (void)updateKLineDate:(MYKLineDataModel *)updateDateModel {
        //整理数据 该处为判断当前新进来的数据是替换k线总数据中的最后一个数据还是添加为一个新的，该处判断不适用于本demo，本demo默认全部添加为新数据，正式使用该版本需重新优化该处代码
        if (self.KLineDataArray.count <= 1) {       //如果没有数据或只有一个数据，来新数据时直接添加数组
            [self.KLineDataArray addObject:updateDateModel];
            self.lastNum = self.lastNum + 1;
            self.firstNum = self.firstNum + 1;
            self.lastDataCount = self.lastDataCount + 1;
        } else {                                    //如果数组中数据多于1个，判断
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            NSDate *newDate = [dateFormatter dateFromString:updateDateModel.PriceTime];
            
            MYKLineDataModel *lastModel = self.KLineDataArray[self.KLineDataArray.count - 2];
            NSDate *lastDate = [dateFormatter dateFromString:lastModel.PriceTime];
            NSDateComponents *cmps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitWeekOfMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:lastDate toDate:newDate options:0];
//            NSLog(@"year = %ld month = %ld day = %ld hour = %ld minute = %ld",cmps.year,cmps.month,cmps.day,cmps.hour,cmps.minute);
            if (cmps.day == 0 && cmps.hour == 0 && cmps.minute < 1) {  //如果和上上一个数据时间相差时间小于指定时间，则替换上一个数据
                MYKLineDataModel *lastModel = self.KLineDataArray.lastObject;
                lastModel.ClosePrice = updateDateModel.ClosePrice;
                double highPrice = [lastModel.ClosePrice doubleValue] > [lastModel.HighPrice doubleValue] ? [lastModel.ClosePrice doubleValue] : [lastModel.HighPrice doubleValue];
                double lowPrice = [lastModel.ClosePrice doubleValue] < [lastModel.HighPrice doubleValue] ? [lastModel.ClosePrice doubleValue] : [lastModel.HighPrice doubleValue];
                lastModel.HighPrice = [NSNumber numberWithDouble:highPrice];
                lastModel.LowPrice = [NSNumber numberWithDouble:lowPrice];
                lastModel.PriceTime = updateDateModel.PriceTime;
            } else {                                                   //如果和上上一个数据时间相差时间大于指定时间，则添加数据
                [self.KLineDataArray addObject:updateDateModel];
                self.lastNum = self.lastNum + 1;
                self.firstNum = self.firstNum + 1;
                self.lastDataCount = self.lastDataCount + 1;
            }
        }
        
        //刷新label
        [self updatePriceLabel];
    
        //刷新vc
        switch (self.MYKLineSegC.selectedSegmentIndex) {
            case 0:
            {
                //重新绘制分时图
                [self.timeSharingVC dealWithData];
            }
                break;
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            {
                //重新绘制k线分钟图
                [self.myKLineMintueVC updateKLineData];
            }
                break;
            default:
                break;
        }
}

/**
 更新high low open close bid
 */
- (void)updatePriceLabel {
    MYKLineDataModel *model;
    
    MYKLineDataModel *lastModel = self.KLineDataArray.lastObject;
    if (self.isCursor) {
        model = self.KLineDataArray[self.CursorIndex];
        
    } else {
        model = self.KLineDataArray.lastObject;
    }
    self.bidPriceLabel.text = [self getNumberWithDigits:self.digits Number:[lastModel.ClosePrice doubleValue]];
    self.openPriceLabel.text = [self getNumberWithDigits:self.digits Number:[model.OpenPrice doubleValue]];
    self.closePriceLabel.text = [self getNumberWithDigits:self.digits Number:[model.ClosePrice doubleValue]];
    self.highPriceLabel.text = [self getNumberWithDigits:self.digits Number:[model.HighPrice doubleValue]];
    self.lowPriceLabel.text = [self getNumberWithDigits:self.digits Number:[model.LowPrice doubleValue]];
    self.timeLabel.text = [model.PriceTime componentsSeparatedByString:@"T"][1];
}




@end
