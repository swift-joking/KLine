//
//  MYSetIndexVC.h
//  XinShengInternational
//
//  Created by michelle on 2017/9/25.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYSetIndexVC : UIViewController

/**
 进入该view时选择的指标的名称

 @param index 指标名称
 */
- (void)setIndex:(NSString *)index;


/**
 修改指标参数
 */
@property (nonatomic, copy) void (^setIndex)(NSString *indexName);

@end
