//
//  FileDownloadHelper.h
//  TrainApp
//
//  Created by niuzhaowang on 2016/12/12.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileDownloadHelper : NSObject
- (instancetype)initWithURLString:(NSString *)urlString baseViewController:(UIViewController *)baseViewController;
- (void)startDownloadWithCompleteBlock:(void(^)(NSString *path))completeBlock;
@end
