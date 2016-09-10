//
//  AppDelegate.h
//  MyApp1.1
//
//  Created by qingyun on 16/8/27.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) BMKMapManager *mapManager;

- (void)changeToTrainVC;

- (void)changeToUpdateInfo;

@end

