//
//  NBLiveDetailViewController.h
//  FaceShowApp
//
//  Created by SRT on 2018/11/14.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NBLiveDetailViewController : BaseViewController
@property (nonatomic, copy) NSString *webUrl;
@property (nonatomic, copy) void(^backBlock)(void);
@end

NS_ASSUME_NONNULL_END
