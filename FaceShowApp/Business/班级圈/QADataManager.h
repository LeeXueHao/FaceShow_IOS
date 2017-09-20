//
//  QADataManager.h
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/23.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QAFileUploadFirstStepRequest.h"
#import "QAFileUploadSecondStepRequest.h"

@interface QADataManager : NSObject

//上传图片
+ (void)uploadFile:(UIImage *)image fileName:(NSString *)fileName
     completeBlock:(void(^)(QAFileUploadSecondStepRequestItem *item,NSError *error))completeBlock;
@end
