//
//  UserSignInRequest.m
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/22.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "UserSignInRequest.h"
#import <BMKLocationKit/BMKLocationComponent.h>

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
