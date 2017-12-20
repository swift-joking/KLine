//
//  UIButton+CustomButton.m
//  BaiLi
//
//  Created by xabaili on 15/11/19.
//  Copyright © 2015年 Hans. All rights reserved.
//

#import "UIButton+CustomButton.h"
#import <UIKit/UIKit.h>

@implementation UIButton (CustomButton)

#pragma mark  --- 设置边框颜色
- (void)setBorderColor:(UIColor *)color {
    self.layer.borderColor = color.CGColor;
}

#pragma mark  --- 设置线宽和颜色
- (void)setBorderWidth:(float)width andColor:(UIColor *)color {
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setBackgroundColor:[UIColor clearColor]];
}

#pragma mark  --- 设置圆角
- (void)setCornerRadius:(float)radius {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

#pragma mark  --- 设置圆角（圆角半径为半个按钮高度）
- (void)setCornerRadiusWithHalfHeight {
    self.layer.cornerRadius = self.frame.size.height / 2;
    self.layer.masksToBounds = YES;
}

#pragma mark  --- 设置圆角、边框有颜色
- (void)setTitle:(NSString *)title titleColor:(UIColor *)titleColor borderWidth:(float)borderWidth borderColor:(UIColor *)borderColor borderRadius:(float)radius {
    [self setBorderWidth:borderWidth andColor:borderColor];
    [self setCornerRadius:radius];
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}

#pragma mark  --- 根据按钮是否可用设置背景色
- (void)changeButtonAppearanceForButton:(UIButton *)button enable:(BOOL)flag backgroudColor:(UIColor *)color {
    button.backgroundColor = color;
    if (flag) {
        button.enabled = YES;
        button.alpha = 1.0;
    } else {
        button.enabled = NO;
        button.alpha = 0.4;
    }
}

#pragma mark  --- 根据按钮是否可用设置背景色为灰色
- (void)changeButtonAppearanceWithEnable:(BOOL)flag {
    UIColor *backgroundColor = self.backgroundColor;
    if (flag) {
        self.enabled = YES;
        self.backgroundColor = backgroundColor;
    } else {
        self.enabled = NO;
        self.backgroundColor = [UIColor grayColor];
    }
}

#pragma mark  --- 根据按钮是否可用设置背景色
- (void)changeButtonAppearanceWithEnable:(BOOL)flag
                          backgroudColor:(UIColor *)color {
    self.backgroundColor = color;
    if (flag) {
        self.enabled = YES;
        self.alpha = 1.0;
    } else {
        self.enabled = NO;
        self.alpha = 0.4;
    }
}

#pragma mark  --- 根据按钮是否可用设置背景色为自定义颜色或灰色
- (void)changeButtonAppearanceWithEnable:(BOOL)flag
                    normalBackgroudColor:(UIColor *)color {
    self.backgroundColor = [UIColor grayColor];
    if (flag) {
        self.enabled = YES;
        self.backgroundColor = color;
    } else {
        self.enabled = NO;
        self.backgroundColor = [UIColor grayColor];
    }
}

#pragma mark  --- 根据按钮是否可用将按钮隐藏
- (void)hiddenButtonAppearanceWithEnable:(BOOL)flag {
    if (flag) {
        self.enabled = YES;
        [self setHidden:NO];
    } else {
        self.enabled = NO;
        [self setHidden:YES];
    }
}

#pragma mark  --- 设置文字、字体大小、颜色
- (void)buttonWithTitle:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)buttonWithTextColor:(UIColor *)color {
    self.titleLabel.textColor = color;
}

- (void)buttonWithFontSize:(CGFloat)fontSize {
    self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
}

- (void)buttonWithTitle:(NSString *)title
              textColor:(UIColor *)textColor
               fontSize:(CGFloat)fontSize {
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:textColor forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 选其一即可
    [super touchesBegan:touches withEvent:event];
    [[[self nextResponder] nextResponder] touchesBegan:touches withEvent:event];
}
@end
