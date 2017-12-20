//
//  BaseTableViewCell.h
//  Class_A_Product_MY
//
//  Created by xalo on 16/8/12.
//  Copyright © 2016年 蓝鸥科技有限公司西安分公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface BaseTableViewCell : UITableViewCell

@property (nonatomic, assign)float Screen_Width;
@property (nonatomic, assign)float Screen_Height;
//为cell赋值
- (void)setDataWithSourceData:(id)model;
- (void)setDataWithSourceData:(id)model
                    indexPath:(NSIndexPath *)indexPath;
@end
