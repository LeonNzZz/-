//
//  RunningViewC.m
//  MyApp1.2
//
//  Created by qingyun on 16/9/9.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#define kScreenWidth self.view.frame.size.width
#define kscreenHeight self.view.frame.size.height

#import "RunningViewC.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "XJAnnotation.h"
#import <CoreLocation/CoreLocation.h>

@interface RunningViewC ()<BMKMapViewDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) BMKMapView *mapView;
//按钮名称
@property (nonatomic, copy) NSArray *arrBtnNames;
//定位管理器
@property (nonatomic, strong) CLLocationManager *locationManager;
//所经过的所有位置的点的集合
@property (nonatomic, strong) NSMutableArray *allLocations;
//当前位置
@property (nonatomic, strong)CLLocation *nowLocation;
//当前标注点
@property (nonatomic, strong)XJAnnotation *nowAnnotation;

@end

@implementation RunningViewC

- (NSArray *)arrBtnNames{
    if (_arrBtnNames == nil) {
        _arrBtnNames = @[@"开始",@"暂停",@"停止"];
    }
    return _arrBtnNames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self createLocationManager];
    [self loadDefaultSetting];
    self.navigationController.navigationBar.hidden = YES;
    
    self.locationManager.delegate = self;
    self.mapView.delegate = self;
    self.allLocations = [[NSMutableArray alloc] init];

}

- (void) createLocationManager{
    
    self.locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization ];
    }
    self.locationManager.distanceFilter = 10.f;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
}

//在这里创建基础视图控件
- (void)loadDefaultSetting{
    
    for (NSUInteger index = 0; index < self.arrBtnNames.count; index ++) {
        UIButton *btnName = [[UIButton alloc] initWithFrame:CGRectMake(((kScreenWidth/3+kScreenWidth/6-40)*index), kscreenHeight/7*6, 80, 40)];
        [btnName setTitle:self.arrBtnNames[index] forState:UIControlStateNormal];
        [btnName setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btnName setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [btnName addTarget:self action:@selector(tapButtonAtButtonIndex:) forControlEvents:UIControlEventTouchUpInside];
        btnName.tag = 101 + index;
        [self.view addSubview:btnName];
    }
    
    BMKMapView *mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kscreenHeight/6*5)];
    [mapView setBackgroundColor:[UIColor redColor]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:mapView];
}

- (void)tapButtonAtButtonIndex:(UIButton *)button{
    switch (button.tag ) {
        case 101:
            [self tapStartButtonAction];
            break;
        case 102:
            [self tapPauseButtonAction];
            break;
        case 103:
            [self tapEndButtonAction];

        default:
            break;
            
    }
}

- (void)tapStartButtonAction{
    [self.locationManager startUpdatingLocation];
}

- (void)tapPauseButtonAction{
    [self.locationManager stopUpdatingLocation];
    
    //暂停位置的标注点
    XJAnnotation *anno = [[XJAnnotation alloc] init];
    anno.coordinate = self.nowLocation.coordinate;
    anno.type = kAnnotationPause;
    [self.mapView addAnnotation:anno];
}

- (void)tapEndButtonAction{
    [self.locationManager stopUpdatingLocation];
  
    XJAnnotation *anno = [[XJAnnotation alloc] init];
    anno.coordinate = self.nowLocation.coordinate;
    anno.type = kAnnotationEnd;
    [self.mapView addAnnotation:anno];
}

#pragma mark locationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = locations.lastObject;
    if (location.horizontalAccuracy > 1000 || location.horizontalAccuracy < 0) {
        return;
    }
    
    if (!self.nowLocation) {
        //设置地图区域
        BMKCoordinateSpan span;//自身跨度设置
        span.latitudeDelta = 0.05;//维度跨度
        span.longitudeDelta = 0.05;//经度跨度
        BMKCoordinateRegion bRegion;//设置地区
        bRegion.center = location.coordinate;//中心点就是定位的中心点
        bRegion.span = span;//设置地区跨度为已设置的跨度
        [self.mapView setRegion:bRegion animated:YES];//设置mapView的地区
        
        //以第一个点为起始点
        XJAnnotation *begin = [[XJAnnotation alloc] init];
        begin.coordinate = location.coordinate;
        begin.type = kAnnotationBegin;//状态
        [self.mapView addAnnotation:begin];
    }
    
    //起始地点标注点设置
    XJAnnotation *nowAnno = [[XJAnnotation alloc] init];
    nowAnno.coordinate = location.coordinate;
    nowAnno.type = kAnnotationNow;
    [self.mapView addAnnotation:nowAnno];//添加标注点
    
    //将上一个点移除（连续不断）
    if (self.nowAnnotation) {
        [self.mapView removeAnnotation:self.nowAnnotation];
    }
    self.nowAnnotation = nowAnno;
    //将当前位置点置于全局变量中
    self.nowLocation = location;
    //将所有的点保存在数组中
    [self.allLocations addObject:location];
    
    //绘制经过的路线
    CLLocationCoordinate2D *coordinate = malloc(sizeof(CLLocationCoordinate2D)*self.allLocations.count);
    for (NSInteger index = 0; index < self.allLocations.count; index ++) {
        coordinate[index] = [self.allLocations[index]coordinate];
        
    }
    //曲线覆盖数据
    BMKPolyline *polyline = [BMKPolyline polylineWithCoordinates:coordinate count:self.allLocations.count];
    //添加的方法要看遵守的啥协议
    [self.mapView addOverlay:polyline];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[XJAnnotation class]]) {
        static NSString *strId = @"XJAnnotation";
        XJAnnotation *anno = (XJAnnotation *)annotation;
        BMKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:strId];
        if (!view) {
            view = [[BMKAnnotationView alloc] initWithAnnotation:anno reuseIdentifier:strId];
        }
        //绑定数据
        switch (anno.type) {
            case kAnnotationBegin:
                view.image = [UIImage imageNamed:@"map_start_icon"];
                view.centerOffset = CGPointMake(0, -12);//这句是什么意思，为什么要这样做**明白了，这个图片有高度，要让图片看着像是浮在地图上，就需要让图片的中心点偏移一点
                break;
            case kAnnotationNow:
                view.image = [UIImage imageNamed:@"currentlocation"];
                view.centerOffset = CGPointZero;
                break;
            case kAnnotationPause:
                view.image = [UIImage imageNamed:@"map_susoend_icon"];
                view.centerOffset = CGPointMake(0, -12);
                break;
            case kAnnotationEnd:
                view.image = [UIImage imageNamed:@"map_stop_icon"];
                view.centerOffset = CGPointMake(0, -12);
                
            default:
                break;
        }
        return view;
    }
    return nil;
}

//经过的路线的设置
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView *view = [[BMKPolylineView alloc] initWithOverlay:overlay];
        view.lineWidth = 3.f;
        view.strokeColor = [UIColor blueColor];
        
        return view;
    }
    return nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

@end
