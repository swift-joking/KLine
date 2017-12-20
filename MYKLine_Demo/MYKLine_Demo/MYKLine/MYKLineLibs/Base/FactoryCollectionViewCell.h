//
//  FactoryCollectionViewCell.h
//  Class_A_Product_MY
//
//  Created by xalo on 16/8/11.
//  Copyright © 2016年 蓝鸥科技有限公司西安分公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCollectionViewCell.h"

@interface FactoryCollectionViewCell : NSObject
+ (BaseCollectionViewCell *)createCollctionViewWithID:(NSString *)reUsedID
                                       collectionView:(UICollectionView *)collectionView
                                            indexPath:(NSIndexPath *)indexPath;
@end
