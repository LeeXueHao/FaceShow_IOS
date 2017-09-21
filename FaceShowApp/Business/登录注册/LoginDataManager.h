//
//  LoginDataManager.h
//  FaceShowApp
//
//  Created by LiuWenXing on 2017/9/20.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginDataManager : NSObject

+ (void)loginWithName:(NSString *)name password:(NSString *)password completeBlock:(void(^)(NSError *error))completeBlock;

@end
