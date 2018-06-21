//
//  UserSignInRequest.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserSignInRequest.h"
#import <BMKLocationKit/BMKLocationComponent.h>
#import <CoreLocation/CoreLocation.h>

@implementation UserSignInRequestItem_Data
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id" : @"userSignInId"}];
}
@end

@implementation UserSignInRequestItem
@end

@interface UserSignInRequest ()<BMKLocationManagerDelegate>
@property (nonatomic, strong) NSString *device;
@property (nonatomic, strong) NSString *from;

@property (nonatomic, strong) BMKLocationManager<Ignore> *locationManager;
@end

@implementation UserSignInRequest

- (instancetype)init {
    if (self = [super init]) {
        self.method = @"interact.userSignIn";
        self.device = @"ios";
        self.from = @"yxbApp";
        
        [self setupLocationManager];
    }
    return self;
}

- (void)setupLocationManager {
    self.locationManager = [[BMKLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.locationTimeout = 3;
    self.locationManager.reGeocodeTimeout = 3;
}

- (void)startRequestWithRetClass:(Class)retClass andCompleteBlock:(HttpRequestCompleteBlock)completeBlock {
    [self.locationManager stopUpdatingLocation];
    WEAK_SELF
    [self.locationManager requestLocationWithReGeocode:YES withNetworkState:NO completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        STRONG_SELF
        if (self.positionSignIn) {
            if (error) {
                NSError *positionErr = [NSError errorWithDomain:@"position_domain" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"获取位置信息失败"}];
                completeBlock(nil,positionErr,NO);
                return;
            }
            CLLocation *location1 = [[CLLocation alloc] initWithLatitude:location.location.coordinate.latitude longitude:location.location.coordinate.longitude];
            NSArray<NSString *> *arr = [self.signinPosition componentsSeparatedByString:@","];
            CLLocation *location2 = [[CLLocation alloc] initWithLatitude:arr.lastObject.floatValue longitude:arr.firstObject.floatValue];
            CLLocationDistance distance = [location1 distanceFromLocation:location2];
            if (distance > self.positionRange.floatValue) {
                NSError *positionErr = [NSError errorWithDomain:@"position_domain" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"您不在签到范围内"}];
                completeBlock(nil,positionErr,NO);
                return;
            }
        }
        if (error) {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
        }
        if (location) {
            if (location.location) {
                NSLog(@"LOC = %@",location.location);
                self.position = [NSString stringWithFormat:@"%@,%@", @(location.location.coordinate.longitude), @(location.location.coordinate.latitude)];
            }
            if (location.rgcData) {
                NSLog(@"rgc = %@",[location.rgcData description]);
                self.site = location.rgcData.locationDescribe;
            }
        }
        [super startRequestWithRetClass:retClass andCompleteBlock:completeBlock];
    }];
}
@end

@implementation UserSignInHelper
+ (NSDictionary *)getParametersFromUrlString:(NSString *)urlString {
    if (![urlString containsString:@"stepId="]) {
        return nil;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSArray *paraStrings = [[urlString componentsSeparatedByString:@"?"].lastObject componentsSeparatedByString:@"&"];
    for (NSString *paraString in paraStrings) {
        NSString *name = [paraString componentsSeparatedByString:@"="].firstObject;
        NSString *value = [paraString componentsSeparatedByString:@"="].lastObject;
        if (([name isEqualToString:kStepId] && !isEmpty(value)) ||
            ([name isEqualToString:kTimestamp] && !isEmpty(value))) {
            [parameters setObject:value forKey:name];
        }
    }
    if (isEmpty([parameters objectForKey:kStepId])) {
        return nil;
    }
    return parameters;
}
@end
