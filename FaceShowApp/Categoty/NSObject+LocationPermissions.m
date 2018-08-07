//
//  NSObject+LocationPermissions.m
//  FaceShowApp
//
//  Created by ZLL on 2018/8/7.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "NSObject+LocationPermissions.h"
#import <CoreLocation/CLLocationManager.h>

@implementation NSObject (LocationPermissions)

- (BOOL)determineWhetherTheAPPOpensTheLocation {
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus]== kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus]== kCLAuthorizationStatusNotDetermined)) {
        return YES;
    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        return NO;
    }else {
        return NO;
    }
}

@end
