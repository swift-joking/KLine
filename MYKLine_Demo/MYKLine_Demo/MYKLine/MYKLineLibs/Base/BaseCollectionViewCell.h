//
//  BaseCollectionViewCell.h
//  Class_A_Product_MY
//
//  Created by xalo on 16/8/11.
//  Copyright © 2016年 蓝鸥科技有限公司西安分公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCollectionViewCell : UICollectionViewCell

//为cell赋值的方法
- (void)setDataWithSourceModel:(id)model;

- (void)setDataWithSourceData:(id)model
                    indexPath:(NSIndexPath *)indexPath;

- (void)setDataWithSourceData:(id)model
                     arrayTag:(NSUInteger)arrayTag
                    indexPath:(NSIndexPath *)indexPath;
@end
