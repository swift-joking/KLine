//
//  SelectMintueTypeView.m
//  XinShengInternational
//
//  Created by michelle on 2017/10/17.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import "MYSelectMintueTypeView.h"

@implementation MYSelectMintueTypeView


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        //        NSLog(@"initWithCoder");
        [self initViews];
    }
    return self;
}

- (void)initViews {
    self.backgroundColor = [[HexColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.2];
}

/**
 设置选择蜡烛图 柱状图 线形图
 */
- (void)setSelectSegC {
    self.selectSegC.selectedSegmentIndex = MYKLineVC.shareMYKLineVC.candleType;
}


/**
 切换蜡烛图 柱状图 线形图

 @param sender 切换蜡烛图 柱状图 线形图的UISegmentedControl
 */
- (IBAction)selectSegAction:(UISegmentedControl *)sender {
    if (self.selectSegC.selectedSegmentIndex != MYKLineVC.shareMYKLineVC.candleType) {
        //赋值
        MYKLineVC.shareMYKLineVC.candleType = self.selectSegC.selectedSegmentIndex;
        //刷新mintue图
        self.changeMintueAction();
    }
}


/**
 关闭
 */
- (IBAction)closeAction:(id)sender {
    self.closeAction();
}

@end
