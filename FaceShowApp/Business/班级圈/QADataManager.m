//
//  QADataManager.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "QADataManager.h"
#import "NSString+YXString.h"
#import "UIImage+YXImage.h"

@interface QADataManager()
@property (nonatomic, strong) QAFileUploadFirstStepRequest *fileUploadFirstStepRequest;
@property (nonatomic, strong) QAFileUploadSecondStepRequest *fileUploadSecondStepRequest;
@end

@implementation QADataManager

+ (QADataManager *)sharedInstance {
    static dispatch_once_t once;
    static QADataManager *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[QADataManager alloc] init];
    });
    
    return sharedInstance;
}

+ (void)uploadFile:(UIImage *)image fileName:(NSString *)fileName completeBlock:(void (^)(QAFileUploadSecondStepRequestItem *, NSError *))completeBlock {
    QADataManager *manager = [QADataManager sharedInstance];
    [manager.fileUploadFirstStepRequest stopRequest];
    manager.fileUploadFirstStepRequest = [[QAFileUploadFirstStepRequest alloc]init];
    
    NSData *data = [UIImage compressionImage:image limitSize:5 * 1024 * 1024];
    NSString *sizeStr = [NSString stringWithFormat:@"%@", @(data.length)];
    manager.fileUploadFirstStepRequest.size = sizeStr;
    manager.fileUploadFirstStepRequest.chunkSize = sizeStr;
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[date timeIntervalSince1970];
    NSString*dateStr = [NSString stringWithFormat:@"%0.f", time];
    NSString *userId = [UserManager sharedInstance].userModel.userID;
    NSString *infoStr = [NSString stringWithFormat:@"%@%@%@",userId,dateStr,sizeStr];
    NSString *md5 = [infoStr yx_md5];
    manager.fileUploadFirstStepRequest.md5 = md5;
    manager.fileUploadFirstStepRequest.name = fileName;
    manager.fileUploadFirstStepRequest.file = data;
    manager.fileUploadFirstStepRequest.userId = userId;
    manager.fileUploadFirstStepRequest.lastModifiedDate = dateStr;
    WEAK_SELF
    [manager.fileUploadFirstStepRequest startRequestWithRetClass:[NSObject class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            BLOCK_EXEC(completeBlock,nil,error);
            return;
        }
        [manager.fileUploadSecondStepRequest stopRequest];
        manager.fileUploadSecondStepRequest = [[QAFileUploadSecondStepRequest alloc]init];
        manager.fileUploadSecondStepRequest.filename = fileName;
        manager.fileUploadSecondStepRequest.md5 = md5;
        [manager.fileUploadSecondStepRequest startRequestWithRetClass:[QAFileUploadSecondStepRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
            STRONG_SELF
            if (error) {
                BLOCK_EXEC(completeBlock,nil,error);
                return;
            }
            BLOCK_EXEC(completeBlock,retItem,nil);
        }];
    }];
}

@end
