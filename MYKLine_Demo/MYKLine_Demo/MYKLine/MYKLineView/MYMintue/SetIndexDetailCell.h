//
//  SetIndexDetailCell.h
//  XinShengInternational
//
//  Created by michelle on 2017/9/25.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface SetIndexDetailCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;          //指标参数名称label
@property (weak, nonatomic) IBOutlet UITextField *detailTextField;  //设置指标参数TextField
@property (weak, nonatomic) IBOutlet UISlider *detailSlider;        //设置指标参数Slider
@property (weak, nonatomic) IBOutlet UILabel *minValueLabel;        //指标参数的最小值label
@property (weak, nonatomic) IBOutlet UILabel *maxValueLabel;        //指标参数的最大值label

@end
