//
//  SetIndexListCell.m
//  XinShengInternational
//
//  Created by michelle on 2017/9/25.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import "SetIndexListCell.h"

@implementation SetIndexListCell

- (void)setDataWithSourceData:(id)model {
    self.indexNameLabel.text = (NSString *)model;
}
@end
