//
//  AppDelegate.m
//  MyApp1.1
//
//  Created by qingyun on 16/8/27.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "AppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>

@interface AppDelegate ()<BMKGeneralDelegate>

@end

@implementation AppDelegate

- (void)changeToTrainVC{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"HomeVC"];
    self.window.rootViewController = vc;
    
}

//查看百度联网状态
- (void) onGetNetworkState:(int)iError{
    NSLog(@"%d",iError);
}

//查看授权状态
- (void)onGetPermissionState:(int)iError{
    NSLog(@"%d",iError);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //使用百度PAI
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:@"vkQZUV6fYr5wxhzNMFoGLavlVKpBB5mK" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed");
    }
    
    //引入leancloud
    [AVOSCloud setApplicationId:@"yMGteNkJsIMWSVcNdD3DRo5g-gzGzoHsz" clientKey:@"eVNoegI2sGsBcpxOsp3HkpAS"];

    
   // AVOSCloud *user = [[AVOSCloud alloc] init];
//    [user setValue:@"zhangsan" forKey:@"name"];
//    [user setValue:@"23" forKey:@"age"];
    
    return YES;
}

- (void)changeToUpdateInfo{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"UploadInfo"];
    self.window.rootViewController = vc;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
