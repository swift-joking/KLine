//
//  SetIndexDetailCell.m
//  XinShengInternational
//
//  Created by michelle on 2017/9/25.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import "SetIndexDetailCell.h"

@implementation SetIndexDetailCell

- (void)setDataWithSourceData:(id)model {
    NSArray *ary = (NSArray *)model;
    NSDictionary *dic = ary[0];
    self.detailLabel.text = dic[@"Name"];
    
    self.minValueLabel.text = [dic[@"minValue"] stringValue];
    self.maxValueLabel.text = [dic[@"maxValue"] stringValue];
    self.detailSlider.minimumValue = [dic[@"minValue"] floatValue];
    self.detailSlider.maximumValue = [dic[@"maxValue"] floatValue];
    
    
    if ([dic[@"newValue"] integerValue] == -1) {
        self.detailSlider.value = [dic[@"value"] floatValue];
        self.detailTextField.text = [dic[@"value"] stringValue];
    } else {
        self.detailSlider.value = [dic[@"newValue"] floatValue];
        self.detailTextField.text = [dic[@"newValue"] stringValue];
    }
    
}

- (IBAction)sliderAction:(UISlider *)sender {
    self.detailTextField.text = [NSString stringWithFormat:@"%.0f",sender.value];
}


@end
