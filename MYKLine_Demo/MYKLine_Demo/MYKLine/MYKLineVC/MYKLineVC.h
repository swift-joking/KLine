//
//  MYKLineVC.h
//  XinShengInternational
//
//  Created by michelle on 2017/9/5.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYKLineDataModel;


@protocol MYKLineDelegate <NSObject>

/**
 请求k线数据
 
 @param type 0:分时图 1:1分 2:5分 3:15分 4:30分 5:1小时
 */
- (void)MYKlineRequestDateWithType:(NSInteger)type;

@end

@interface MYKLineVC : UIViewController

//------------------ k线的delegate ------------------
@property (nonatomic, weak) id <MYKLineDelegate>delegate;

//------------------ k线固定参数 ------------------
@property (nonatomic, assign) int digits;                     //保留小数点
@property (nonatomic, retain) NSString *symbol;               //k线商品内容
@property (nonatomic, retain) NSMutableArray *mainIndexAry;   //默认住指标参数
@property (nonatomic, retain) NSMutableArray *plotIndexAry;   //默认副指标参数
@property (nonatomic, assign) NSInteger candleNum;            //展示蜡烛图数据个数
@property (nonatomic, assign) NSInteger candleType;           //0:蜡烛图 1:蜡状图 2:折线图
@property (nonatomic, assign) BOOL candleIsEmpty;             //是否是空心阳线
@property (nonatomic, assign) NSInteger lastDataCount;        //最后一组数据的个数，用于拖拽和放大
@property (nonatomic, assign) BOOL isCursor;                  //是否加载十字光标
@property (nonatomic, assign) NSInteger CursorIndex;          //十字光标下标

@property (nonatomic, assign) BOOL isSupportCrossScreen;      //是否支持横屏
@property (nonatomic, assign) NSInteger selectIndex;          //选择的segmengt数组下标

//------------------ 分时图参数 ------------------
@property (nonatomic, assign) CGFloat timeSharing_maxValue;   //分时图最大值
@property (nonatomic, assign) CGFloat timeSharing_minValue;   //分时图最小值

//------------------ k线分钟图参数 ------------------
@property (nonatomic, assign) BOOL hiddenPlotIndex;            //隐藏幅图指标
@property (nonatomic, retain) NSString *mainIndexName;         //主指标图类型
@property (nonatomic, retain) NSString *plotIndexName;         //副指标图类型
@property (nonatomic, assign) CGFloat mainIndex_maxValue;      //主指标图最大值
@property (nonatomic, assign) CGFloat mainIndex_minValue;      //主指标图最小值
@property (nonatomic, assign) CGFloat plotIndex_maxValue;      //副指标图最大值
@property (nonatomic, assign) CGFloat plotIndex_minValue;      //副指标图最小值
@property (nonatomic, assign) NSInteger firstNum;              //标记展示数据的第一个下标
@property (nonatomic, assign) NSInteger lastNum;               //标记展示数据的最后一个下标
@property (nonatomic, assign) BOOL hiddenCurrentPriceLine;     //隐藏现价线

//------------------ k线数组 ------------------
@property (nonatomic, retain) NSMutableArray *KLineDataArray;  //数据数组


/**
 单例创建k线VC

 @return k线VC
 */
+ (MYKLineVC *)shareMYKLineVC;


/**
 请求k线
 */
- (void)requestKLineDateWithType;


/**
 第一次请求k线数据成功时，处理第一批成组k线数据

 @param KLineDateArray webscocket或者http请求回来的k线数据数组
 */
- (void)dealWithDate:(NSMutableArray *)KLineDateArray;


/**
接收刷新的k线数据时，刷新k线当前画图操作

 @param updateDateModel 更新k线时新的k线数据
 */
- (void)updateKLineDate:(MYKLineDataModel *)updateDateModel;


@end
