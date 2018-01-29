//
//  QiniuDataManager.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/17.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "QiniuDataManager.h"
#import <QNUploadManager.h>

@interface QiniuDataManager ()
@property (nonatomic, strong) QiniuTokenRequest *tokenRequest;
@property (nonatomic, strong) QNUploadManager *upManager;
@end

@implementation QiniuDataManager
+ (QiniuDataManager *)sharedInstance {
    static QiniuDataManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[QiniuDataManager alloc] init];
    });
    return sharedInstance;
}

- (void)updateTokenWithCompleteBlock:(void(^)(QiniuTokenRequestItem *item,NSError *error))completeBlock {
    [self.tokenRequest stopRequest];
    self.tokenRequest = [[QiniuTokenRequest alloc]init];
    WEAK_SELF
    [self.tokenRequest startRequestWithRetClass:[QiniuTokenRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,nil,error);
            return;
        }
        QiniuTokenRequestItem *item = (QiniuTokenRequestItem *)retItem;
        BLOCK_EXEC(completeBlock,item,nil);
    }];
}

- (void)uploadData:(NSData *)data
 withProgressBlock:(void(^)(CGFloat percent))progressBlock
     completeBlock:(void(^)(NSString *key,NSError *error))completeBlock {
    WEAK_SELF
    [self updateTokenWithCompleteBlock:^(QiniuTokenRequestItem *item, NSError *error) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,nil,error);
            return;
        }
        [self uploadData:data withToken:item.data.token progressBlock:progressBlock completeBlock:completeBlock];
    }];
}

- (void)uploadData:(NSData *)data
         withToken:(NSString *)token
     progressBlock:(void(^)(CGFloat percent))progressBlock
     completeBlock:(void(^)(NSString *key,NSError *error))completeBlock {
    QNUploadOption *uploadOption = [[QNUploadOption alloc]initWithProgressHandler:^(NSString *key, float percent) {
        BLOCK_EXEC(progressBlock,percent);
    }];
    
    WEAK_SELF
    self.upManager = [[QNUploadManager alloc]init];
    [self.upManager putData:data key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        STRONG_SELF
        if (!resp) {
            NSError *err = [NSError errorWithDomain:@"QiniuUploadError" code:1 userInfo:@{NSLocalizedDescriptionKey:@"上传数据失败"}];
            BLOCK_EXEC(completeBlock,nil,err);
            return;
        }
        NSString *qiniu_key = [resp valueForKey:@"key"];
        BLOCK_EXEC(completeBlock,qiniu_key,nil);
    } option:uploadOption];
}

#pragma mark - Utils
+ (NSString *)resizedUrlStringWithOriString:(NSString *)oriStr
                                maxLongEdge:(CGFloat)longEdge
                               maxShortEdge:(CGFloat)shortEdge {
    NSString *resizedStr = [NSString stringWithFormat:@"%@?imageView2/0/w/%@/h/%@",oriStr,@(longEdge),@(shortEdge)];
    return resizedStr;
}

+ (NSString *)resizedUrlStringWithOriString:(NSString *)oriStr
                                maxLongEdge:(CGFloat)longEdge {
    NSString *resizedStr = [NSString stringWithFormat:@"%@?imageView2/0/w/%@",oriStr,@(longEdge)];
    return resizedStr;
}

+ (NSString *)resizedUrlStringWithOriString:(NSString *)oriStr
                               maxShortEdge:(CGFloat)shortEdge {
    NSString *resizedStr = [NSString stringWithFormat:@"%@?imageView2/0/h/%@",oriStr,@(shortEdge)];
    return resizedStr;
}

@end
