//
//  PhotoListViewController.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/11.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import <Photos/Photos.h>

@interface PhotoListViewController : BaseViewController
@property (nonatomic, strong) PHAssetCollection *collection;
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, strong) void(^completeBlock)(NSArray *imageArray);
@end
