//
//  NSObject+Tool.h
//  MYKLine_Demo
//
//  Created by michelle on 2017/10/27.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Tool)



/**
 *  获得需要对应的小数点位数的数值
 *
 *  @param Digits   小数点保留位数
 *
 *  @param Number   float类型的数值
 *
 *  return 实际的宽度
 */
- (NSString *)getNumberWithDigits:(int)Digits Number:(float)Number;

@end
