//
//  UIView+Frame.h
//  MYKLine_Demo
//
//  Created by michelle on 2017/10/27.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)
@property (nonatomic) CGFloat bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat centerY;     ///< Shortcut for center.y

- (void)addTarget:(id)target action:(SEL)action;
@end
