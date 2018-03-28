//
//  IMHistoryMessageFetcher.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/3/28.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMHistoryFetchRecord.h"

@interface IMHistoryMessageFetcher : NSObject
+ (IMHistoryMessageFetcher *)sharedInstance;

- (void)addRecord:(IMHistoryFetchRecord *)record;
@end
