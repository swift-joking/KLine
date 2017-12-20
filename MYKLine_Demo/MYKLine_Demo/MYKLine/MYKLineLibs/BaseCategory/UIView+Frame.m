//
//  UIView+Frame.m
//  MYKLine_Demo
//
//  Created by michelle on 2017/10/27.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (void)addTarget:(id)target action:(SEL)action {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:target
                                                                           action:action];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}
@end
