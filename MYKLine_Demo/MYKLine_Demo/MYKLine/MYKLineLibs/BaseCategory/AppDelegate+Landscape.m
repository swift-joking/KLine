//
//  AppDelegate+Landscape.m
//  MYKLine_Demo
//
//  Created by michelle on 2017/11/2.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import "AppDelegate+Landscape.h"

@implementation AppDelegate (Landscape)

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    
    if (MYKLineVC.shareMYKLineVC.isSupportCrossScreen) {
        
        return UIInterfaceOrientationMaskLandscape;
    }else if (!MYKLineVC.shareMYKLineVC.isSupportCrossScreen){
        
        return UIInterfaceOrientationMaskPortrait;
    }
    
    return UIInterfaceOrientationMaskPortrait;
}
@end
