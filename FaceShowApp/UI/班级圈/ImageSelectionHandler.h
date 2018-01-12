//
//  ImageSelectionHandler.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/12.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageSelectionHandler : NSObject
- (void)pickImageWithMaxCount:(NSInteger)maxCount completeBlock:(void(^)(NSArray *array))completeBlock;

- (void)browseImageWithArray:(NSMutableArray *)imageArray index:(NSInteger)index deleteBlock:(void(^)(NSInteger index))deleteBlock;
@end
