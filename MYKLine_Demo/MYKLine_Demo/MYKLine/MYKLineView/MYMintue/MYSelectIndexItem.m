//
//  MYSelectIndexItem.m
//  XinShengInternational
//
//  Created by michelle on 2017/10/17.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import "MYSelectIndexItem.h"

@implementation MYSelectIndexItem

//设置label内容
- (void)setDataWithSourceData:(id)model indexPath:(NSIndexPath *)indexPath {
    NSString *index = (NSString *)model;
    self.indexLabel.text = index;
}

@end
