//
//  MYLandscapeVC.h
//  XinShengInternational
//
//  Created by michelle on 2017/10/18.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYLandscapeVC : UIViewController

//------------------ storyboard创建的 ------------------
@property (weak, nonatomic) IBOutlet UIView *topView;          //顶部view
@property (weak, nonatomic) IBOutlet UILabel *chiSymbolLabel;  //中文SymbolLabel
@property (weak, nonatomic) IBOutlet UILabel *enSymbolLabel;   //英文SymbolLabel
@property (weak, nonatomic) IBOutlet UISegmentedControl *segC; //选择k线类型的SegmentedControl

@property (nonatomic, assign) NSInteger selectIndex;                       //选择的SegmentedControl的下标

//------------------ block ------------------
@property (nonatomic, copy)void(^changeSegCSelect)(NSInteger selectIndex); //选择k线类型改变
@property (nonatomic, copy)void(^backAction)(void);                        //返回竖屏


/**
 绘制k线图
 */
- (void)dealWithData;
@end
