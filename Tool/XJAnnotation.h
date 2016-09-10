//
//  XJAnnotation.h
//  MyApp1.2
//
//  Created by qingyun on 16/9/7.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

typedef enum:NSInteger {
    kAnnotationBegin,
    kAnnotationNow,
    kAnnotationPause,
    kAnnotationEnd
}AnnotationType;

@interface XJAnnotation : NSObject<BMKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic) AnnotationType type;

@end
