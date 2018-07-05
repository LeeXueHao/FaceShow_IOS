//
//  AreaManager.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/22.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "AreaManager.h"

@implementation Area
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"areaID"}];
}
@end

@implementation AreaModel
@end

@implementation AreaManager
+ (AreaManager *)sharedInstance {
    static dispatch_once_t once;
    static AreaManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[AreaManager alloc] init];
        NSString *path = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"json"];
        NSData *data = [[NSData alloc]initWithContentsOfFile:path];
        sharedInstance.areaModel = [[AreaModel alloc]initWithData:data error:nil];
    });
    
    return sharedInstance;
}
@end
