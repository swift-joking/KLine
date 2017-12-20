//
//  FactoryTableViewCell.m
//  Class_A_Product_MY
//
//  Created by xalo on 16/8/12.
//  Copyright © 2016年 蓝鸥科技有限公司西安分公司. All rights reserved.
//

#import "FactoryTableViewCell.h"

@implementation FactoryTableViewCell

+ (BaseTableViewCell *)createTableViewCellWithID:(NSString *)reusedID tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:reusedID forIndexPath:indexPath];
}


@end
