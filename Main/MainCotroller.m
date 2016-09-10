//
//  MainCotroller.m
//  MyApp1.2
//
//  Created by qingyun on 16/9/8.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#define QLColorWithRGB(redValue, greenValue, blueValue) ([UIColor colorWithRed:((redValue)/255.0) green:((greenValue)/255.0) blue:((blueValue)/255.0) alpha:1])
#define QLColorRandom QLColorWithRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#define QLColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "MainCotroller.h"
#import "DiscoveryVC.h"
#import "RunningViewC.h"
#import "ProfileVC.h"

@interface MainCotroller ()

@end

@implementation MainCotroller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadDefaultSetting];
}

- (void)loadDefaultSetting {

    RunningViewC *run = [[RunningViewC alloc] init];
    [self addViewController:run ImageName:@"tabbar_home" Title:@"跑起来"];
    
    DiscoveryVC *discovery = [[DiscoveryVC alloc] init];    [self addViewController:discovery ImageName:@"tabbar_discover" Title:@"发现"];
    
    ProfileVC *profile = [[ProfileVC alloc] init];
    [self addViewController:profile ImageName:@"tabbar_profile" Title:@"我"];
}

- (void)addViewController:(UIViewController *)viewController ImageName:(NSString *)imageName Title:(NSString *)title{
    viewController.tabBarItem.image = [UIImage imageNamed:imageName];
    viewController.tabBarItem.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",imageName]];
    viewController.tabBarItem.title = title;
    viewController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -5);
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [self addChildViewController:naVC];
}


@end
