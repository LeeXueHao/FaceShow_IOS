//
//  YXLocationManager.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/12/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "YXLocationManager.h"
#import <BMKLocationKit/BMKLocationComponent.h>
#import <BMKLocationKit/BMKLocationAuth.h>

@interface YXLocationManager ()<BMKLocationAuthDelegate, BMKLocationManagerDelegate>
@property (nonatomic, strong) BMKLocationManager *locationManager;
@end

@implementation YXLocationManager

+ (YXLocationManager *)sharedInstance {
    static YXLocationManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YXLocationManager alloc] init];
        [[BMKLocationAuth sharedInstance] checkPermisionWithKey:@"4Bf04BnzjHNH4xgQvONE8c3MNhGfwiBK" authDelegate:manager];
    });
    return manager;
}

- (BMKLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[BMKLocationManager alloc] init];
        //设置delegate
        _locationManager.delegate = self;
        //设置返回位置的坐标系类型
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设置距离过滤参数
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        //设置预期精度参数
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        //设置应用位置类型
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        //设置是否自动停止位置更新
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        //设置是否允许后台定位
//        _locationManager.allowsBackgroundLocationUpdates = YES;
        //设置位置获取超时时间
        _locationManager.locationTimeout = 3;
        //设置获取地址信息超时时间
        _locationManager.reGeocodeTimeout = 3;
    }
    return _locationManager;
}

- (void)requestLocation {
    [self.locationManager requestLocationWithReGeocode:YES withNetworkState:NO completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        if (error) {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        if (location) {
            if (location.location) {
                NSLog(@"LOC = %@",location.location);
            }
            if (location.rgcData) {
                NSLog(@"rgc = %@",[location.rgcData description]);
            }
        }
        NSLog(@"netstate = %d",state);
    }];
}

#pragma mark - BMKLocationAuthDelegate
- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError {
    if (iError != BMKLocationAuthErrorSuccess) {
        NSLog(@"鉴权失败 errorCode: %ld", (long)iError);
    }
}

@end
