//
//  FactoryCollectionViewCell.m
//  Class_A_Product_MY
//
//  Created by xalo on 16/8/11.
//  Copyright © 2016年 蓝鸥科技有限公司西安分公司. All rights reserved.
//

#import "FactoryCollectionViewCell.h"

@implementation FactoryCollectionViewCell

+ (BaseCollectionViewCell *)createCollctionViewWithID:(NSString *)reUsedID
                                       collectionView:(UICollectionView *)collectionView
                                            indexPath:(NSIndexPath *)indexPath{
    return [collectionView dequeueReusableCellWithReuseIdentifier:reUsedID forIndexPath:indexPath];
}
@end
