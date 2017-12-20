//
//  SelectMintueTypeView.h
//  XinShengInternational
//
//  Created by michelle on 2017/10/17.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYSelectMintueTypeView : UIView

//选择蜡烛图 柱状图 线形图的SegmentControl
@property (weak, nonatomic) IBOutlet UISegmentedControl *selectSegC;


/**
 关闭
 */
@property (nonatomic, copy)void (^closeAction)(void);


/**
 改变选择蜡烛图 柱状图 线形图
 */
@property (nonatomic, copy)void (^changeMintueAction)(void);


/**
 设置选择蜡烛图 柱状图 线形图
 */
- (void)setSelectSegC;

@end
