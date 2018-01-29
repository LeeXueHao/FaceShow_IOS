//
//  QiniuDataManager.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/17.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QiniuTokenRequest.h"

@interface QiniuDataManager : NSObject
+ (QiniuDataManager *)sharedInstance;

- (void)uploadData:(NSData *)data
 withProgressBlock:(void(^)(CGFloat percent))progressBlock
     completeBlock:(void(^)(NSString *key,NSError *error))completeBlock;

#pragma mark - Utils
+ (NSString *)resizedUrlStringWithOriString:(NSString *)oriStr
                                maxLongEdge:(CGFloat)longEdge
                               maxShortEdge:(CGFloat)shortEdge;

+ (NSString *)resizedUrlStringWithOriString:(NSString *)oriStr
                                maxLongEdge:(CGFloat)longEdge;

+ (NSString *)resizedUrlStringWithOriString:(NSString *)oriStr
                               maxShortEdge:(CGFloat)shortEdge;
@end
