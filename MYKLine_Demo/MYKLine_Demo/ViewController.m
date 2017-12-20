//
//  ViewController.m
//  MYKLine_Demo
//
//  Created by michelle on 2017/10/27.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <MYKLineDelegate>
@property (nonatomic, retain)MYKLineVC *myklintVC;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, assign) NSInteger KLineDateType;
@property (nonatomic, assign) NSInteger count;
@end

@implementation ViewController

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateKLineDate) userInfo:nil repeats:YES];
        [_timer setFireDate:[NSDate distantFuture]];
    }
    return _timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.count = 0;
}

//跳转k线
- (IBAction)turnToKLine:(UIButton *)sender {

    //跳转k线
    self.myklintVC = [MYKLineVC shareMYKLineVC];
    self.myklintVC.symbol = @"EURUSD";
    self.myklintVC.digits = 5;
    self.myklintVC.delegate = self;
    [self.navigationController pushViewController:self.myklintVC animated:YES];
    [self.myklintVC requestKLineDateWithType];
}

#pragma mark - MYKLineDelegate
//k线请求数据
- (void)MYKlineRequestDateWithType:(NSInteger)type {
    //创建新数组接收k线初始请求的数据
    NSMutableArray *kLineDataArray = [NSMutableArray array];
    //停止定时器
    [self.timer setFireDate:[NSDate distantFuture]];
    //用于标记刷新k线时刷新哪种类型
    self.KLineDateType = type;
    self.count = 0;
    //解析本地k线数据
    /*
     本demo使用的是本地的plist数据
     HTTP和websocket此处应该是正常的请求数据方式，并且在返回数据处解析数据为MYKLineDataModel类型存放数组，
     并且调用[self.myklintVC dealWithDate:kLineDataArray]来让k线刷新第一次请求回来的数据
     */
    kLineDataArray = [self analysisRequestKLineDateWithType:type];
    //k线绘制第一次请求回来的数据
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //刷新k线
        [self.myklintVC dealWithDate:kLineDataArray];
        //定时1秒发送刷新数据
        [self.timer setFireDate:[NSDate distantPast]];
    });
    
}

//解析PList文件的数据
- (NSMutableArray *)analysisRequestKLineDateWithType:(NSInteger)type{
    NSString *path = [NSString string];
    switch (type) {
        case 0:
            path = [[NSBundle mainBundle] pathForResource:@"TimeSharing" ofType:@"plist"];
            break;
        case 1:
            path = [[NSBundle mainBundle] pathForResource:@"1minute" ofType:@"plist"];
            break;
        case 2:
            path = [[NSBundle mainBundle] pathForResource:@"5minutes" ofType:@"plist"];
            break;
        case 3:
            path = [[NSBundle mainBundle] pathForResource:@"15minutes" ofType:@"plist"];
            break;
        case 4:
            path = [[NSBundle mainBundle] pathForResource:@"30minutes" ofType:@"plist"];
            break;
        case 5:
            path = [[NSBundle mainBundle] pathForResource:@"60minutes" ofType:@"plist"];
            break;
        default:
            break;
    }
    NSMutableArray *dataArray = [NSMutableArray arrayWithContentsOfFile:path];
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSDictionary *dic in dataArray) {
        MYKLineDataModel *KLineModel = [[MYKLineDataModel alloc] init];
        [KLineModel setValuesForKeysWithDictionary:dic];
        [resultArray addObject:KLineModel];
    }
    return resultArray;
}

#pragma mark - K线刷新数据
- (void)updateKLineDate {
    MYKLineDataModel *updateDateModel = [self analysisUpdateKLineDate];
    [self.myklintVC updateKLineDate:updateDateModel];
}

//解析PList文件的数据
- (MYKLineDataModel *)analysisUpdateKLineDate{
    NSString *path = [NSString string];
    switch (self.KLineDateType) {
        case 0:
            path = [[NSBundle mainBundle] pathForResource:@"TimeSharing_Update" ofType:@"plist"];
            break;
        case 1:
            path = [[NSBundle mainBundle] pathForResource:@"1minute_Update" ofType:@"plist"];
            break;
        case 2:
            path = [[NSBundle mainBundle] pathForResource:@"5minutes_Update" ofType:@"plist"];
            break;
        case 3:
            path = [[NSBundle mainBundle] pathForResource:@"15minutes_Update" ofType:@"plist"];
            break;
        case 4:
            path = [[NSBundle mainBundle] pathForResource:@"30minutes_Update" ofType:@"plist"];
            break;
        case 5:
            path = [[NSBundle mainBundle] pathForResource:@"60minutes_Update" ofType:@"plist"];
            break;
        default:
            break;
    }
    
    NSMutableArray *dataArray = [NSMutableArray arrayWithContentsOfFile:path];
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSDictionary *dic in dataArray) {
        MYKLineDataModel *KLineModel = [[MYKLineDataModel alloc] init];
        [KLineModel setValuesForKeysWithDictionary:dic];
        [resultArray addObject:KLineModel];
    }
    
    MYKLineDataModel *model = resultArray[self.count];
    if (self.count == resultArray.count - 1) {
        self.count = 0;
        [_timer setFireDate:[NSDate distantFuture]];
    } else {
        self.count++;
    }
    return model;
}
@end
