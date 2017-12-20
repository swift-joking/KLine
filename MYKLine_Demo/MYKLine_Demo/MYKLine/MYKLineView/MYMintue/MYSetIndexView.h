//
//  MYSetIndexView.h
//  XinShengInternational
//
//  Created by michelle on 2017/9/25.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYSetIndexView : UIView

@property (weak, nonatomic) IBOutlet UIButton *IndexButton;    //跳转设置指标参数的button
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;     //展示指标参数详情的label


/**
 根据当前k线谁显示指标参数详情

 @param index 指标名称
 */
- (void)detailLabel:(NSString *)index;


/**
 选择切换指标
 */
@property (nonatomic, copy) void (^setIndexAction)(NSString *index);


/**
 设置指标详情
 */
@property (nonatomic, copy) void (^setDetailAction)(NSString *index);
@end
