//
//  AlbumListViewController.h
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/1/11.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"

@interface AlbumListViewController : BaseViewController
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, strong) void(^completeBlock)(NSArray *imageArray);
@end
