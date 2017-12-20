//
//  MYSelectIndexVC.h
//  XinShengInternational
//
//  Created by michelle on 2017/10/17.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYSelectIndexVC : UIViewController
@property (nonatomic, copy)void (^closeAction)(void);   //关闭切换k线类型
@property (nonatomic, copy)void (^updataKLine)(void);   //重新绘制k线
@end
