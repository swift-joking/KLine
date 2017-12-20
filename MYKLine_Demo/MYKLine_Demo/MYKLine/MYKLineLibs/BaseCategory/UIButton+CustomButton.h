//
//  UIButton+CustomButton.h
//  BaiLi
//
//  Created by xabaili on 15/11/19.
//  Copyright © 2015年 Hans. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 自定义按钮
@interface UIButton (CustomButton)

/**
 * 设置边框颜色
 *
 * @param color          边框颜色
 */
- (void)setBorderColor:(UIColor *)color;

/**
 * 设置线宽和颜色
 *
 * @param color          边框颜色
 * @param width          边框宽度
 */
- (void)setBorderWidth:(float)width andColor:(UIColor *)color;

/**
 * 设置圆角
 *
 * @param radius         圆角
 */
- (void)setCornerRadius:(float)radius;

/**
 * 设置圆角（圆角半径为半个按钮高度）
 *
 */
- (void)setCornerRadiusWithHalfHeight;

/**
 * 设置圆角、边框有颜色
 *
 * @param title          主题
 * @param titleColor     主题颜色
 * @param borderWidth    边框线宽
 * @param borderColor    边框颜色
 * @param radius   边框半径
 */
- (void)setTitle:(NSString *)title
      titleColor:(UIColor *)titleColor
     borderWidth:(float)borderWidth
     borderColor:(UIColor *)borderColor
    borderRadius:(float)radius;

/**
 * 根据按钮是否可用设置背景色为灰色
 */
- (void)changeButtonAppearanceWithEnable:(BOOL)flag;

/**
 * 根据按钮是否可用设置按钮背景色
 */
- (void)changeButtonAppearanceWithEnable:(BOOL)flag backgroudColor:(UIColor *)color;

/**
 * 根据按钮是否可用设置背景色为自定义颜色或灰色
 */
- (void)changeButtonAppearanceWithEnable:(BOOL)flag
                    normalBackgroudColor:(UIColor *)color;

/**
 * 根据按钮是否可用将按钮隐藏
 */
- (void)hiddenButtonAppearanceWithEnable:(BOOL)flag;

/**
 * 设置文字、字体大小、颜色
 */
- (void)buttonWithTitle:(NSString *)title;

- (void)buttonWithTextColor:(UIColor *)color;

- (void)buttonWithFontSize:(CGFloat)fontSize;

- (void)buttonWithTitle:(NSString *)title
              textColor:(UIColor *)textColor
               fontSize:(CGFloat)fontSize;

@end
